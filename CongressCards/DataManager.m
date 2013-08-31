//
//  DataManager.m
//  CongressCards
//
//  Created by Christopher Febles on 2/21/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import "DataManager.h"
#import "MemberXMLParserDelegate.h"
#import "Member.h"
#import "StatePickerViewDelegate.h"
#import "SSZipArchive.h"

@implementation DataManager

static NSString *const SUNLIGHT_DOMAIN = @"http://congress.api.sunlightfoundation.com";
static NSString *const API_KEY = @"08e7c62666a240168ce580933969092f";
static NSString *const FILE_NAME = @"Congress.dat";
static NSString *const SUNLIGHT_PHOTOS_ZIP = @"http://assets.sunlightfoundation.com/moc/200x250.zip";

static NSMutableDictionary *masterCommitteeList;

+(NSArray *) loadSenators {
    return [self filterArray:[self loadMembers] ByChamber:@"senate"];
}

+(NSArray *) loadRepresentatives {
    return [self filterArray:[self loadMembers] ByChamber:@"house"];
}

+(NSArray *) filterArray: (NSArray *) members
               ByChamber: (NSString *) chamber {
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    for ( Member *member in members ) {
        if ( [[member chamber] isEqualToString:chamber] )
            [retVal addObject:member];
    }
    
    //Sort results by State, then District, then name
    NSArray *sortedArray = [retVal sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        Member *first = (Member *)a;
        Member *second = (Member *)b;
        
        NSInteger retVal = [[first state_name] compare:[second state_name]];
        
        if ( retVal == NSOrderedSame )
            retVal = [[NSNumber numberWithInt:[first district]] compare:[NSNumber numberWithInt:[second district]]];
        if ( retVal == NSOrderedSame )
            retVal = [[first last_name] compare:[second last_name]];
        if ( retVal == NSOrderedSame )
            retVal = [[first first_name] compare:[second first_name]];
        
        return retVal;
    }];

    
    return sortedArray;
}

//Update data from JSON Stream, and write to local file
+(NSArray *) updateLocalFiles {
    
    NSMutableArray *members = [[NSMutableArray alloc] init];
    NSMutableString *url = [[NSMutableString alloc] initWithString:SUNLIGHT_DOMAIN];
    [url appendString:@"/legislators?per_page=50&apikey="];
    [url appendString:API_KEY];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    NSDictionary *items = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: &err];
    int numResults = [[items objectForKey:@"count"] integerValue];
    int page = 1;
    BOOL notDone = YES;
    do {
        NSMutableArray *results = [items objectForKey:@"results"];
        
        //Create Member objects
        for ( NSDictionary *member in results ) {
            Member *newMember = [self loadMember:member];
            
            if ( [members containsObject:newMember] ) {
                //This would be an error.
                NSLog(@"DUPLICATE MEMBER: %@", [newMember memberFull]);
            } else {
                NSLog(@"%@: %@", [newMember bioguide_id], [newMember memberFull]);
                [members addObject:newMember];
            }
        }
        notDone = page*50 < numResults;
        if ( notDone ) {
            page++;
            NSLog(@"Advancing to page: %d", page);
            NSMutableString *pageUrl = [[NSMutableString alloc] initWithString:url];
            [pageUrl appendString:@"&page="];
            [pageUrl appendString:[NSString stringWithFormat:@"%d", page]];
            theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:pageUrl]];
            response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
            items = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: &err];
        }
    } while ( notDone );
    
    [self loadPhotos:members];
    
    NSLog(@"Total members processed: %d", [members count]);
    //Write the generated list to local storage for retrieval
    [self writeMembers:members];
    
    return members;
}

+(void) loadPhotos: (NSArray *) members {
    
    //Load all photos from Sunlight API
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:SUNLIGHT_PHOTOS_ZIP];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *err = nil;
    
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&err];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:@"photos.zip"];

    [data writeToFile:zipPath atomically:YES];
    
    //Unzip photo file
    [SSZipArchive unzipFileAtPath:zipPath toDestination:documentsDirectory];
    
    //Resize, rename, and save photos
    
}

+(void) writeMembers: (NSArray *) members {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:FILE_NAME];
    
    NSData* memberData = [NSKeyedArchiver archivedDataWithRootObject:members];
    BOOL success = [memberData writeToFile:filePath atomically:YES];
    
    if ( !success ) {
        NSString *successStr = success ? @"Yes" : @"No";
        NSLog(@"Successfully wrote file %@: %@", filePath, successStr);
    }
}

//Read data from local
+(NSArray *) loadMembers {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:FILE_NAME];
    
    NSArray *members = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] copy];
    
    //For Testing, comment out if statement to always re-load data
    //Maybe auto-update every 3 months or so?
//    if ( members == nil ) {
        NSLog(@"Unable to load Congress data file. Reimporting from API.");
        members = [self updateLocalFiles];
//    }
    
    return members;
}

+(Member *)loadMember: (NSDictionary *) member {
    
    Member *newMember = [[Member alloc] init];
    
    [newMember setMemberData:member];
    
    //Load committee assignments for this member
    [self loadCommittees:newMember];
    
    return newMember;
}

+(void) loadCommittees: (Member *) newMember {
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    
    NSMutableString *committeeURL = [[NSMutableString alloc] initWithString:SUNLIGHT_DOMAIN];
    [committeeURL appendString:@"/committees?per_page=50&apikey="];
    [committeeURL appendString:API_KEY];
    [committeeURL appendString:@"&member_ids="];
    [committeeURL appendString:[newMember bioguide_id]];
    
    NSURLRequest *committeeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:committeeURL]];
    NSData *committeeResponse = [NSURLConnection sendSynchronousRequest: committeeRequest returningResponse: &resp error: &err];
    NSDictionary *committees = [NSJSONSerialization JSONObjectWithData: committeeResponse options: NSJSONReadingMutableContainers error: &err];
    
    NSMutableArray *committeeResults = [committees objectForKey:@"results"];
    [newMember setCommitteeData:committeeResults];
    
    //Load committee members
    if ( masterCommitteeList == nil ) masterCommitteeList = [[NSMutableDictionary alloc] init];
    for ( Committee *committee in [newMember committees] ) {
        
        if ( [masterCommitteeList objectForKey:[committee committee_id]] == nil ) {
            committeeURL = [[NSMutableString alloc] initWithString:SUNLIGHT_DOMAIN];
            [committeeURL appendString:@"/committees?per_page=50&apikey="];
            [committeeURL appendString:API_KEY];
            [committeeURL appendString:@"&committee_id="];
            [committeeURL appendString:[committee committee_id]];
            [committeeURL appendString:@"&fields=members"];
            
            committeeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:committeeURL]];
            committeeResponse = [NSURLConnection sendSynchronousRequest: committeeRequest returningResponse: &resp error: &err];
            committees = [NSJSONSerialization JSONObjectWithData: committeeResponse options: NSJSONReadingMutableContainers error: &err];
            committeeResults = [[committees objectForKey:@"results"] valueForKey:@"members"];
            NSArray *committeeMembers = [committeeResults objectAtIndex:0];
            
            for ( NSMutableDictionary *committeeDictionary in committeeMembers ) {
                [committeeDictionary setObject:[committee committee_id] forKey:@"committee_id"];
            }
            
            [masterCommitteeList setObject:committeeMembers forKey:[committee committee_id]];
        }
        
        [newMember addCommitteeMemberData:[masterCommitteeList objectForKey:[committee committee_id]]];
    }
    
}

@end
