//
//  DataManager.m
//  Congress
//
//  Created by Christopher Febles on 2/21/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import "DataManager.h"
#import "MemberXMLParserDelegate.h"
#import "Member.h"
#import "StatePickerViewDelegate.h"

@implementation DataManager

+(NSArray *) loadSenatorsFromXML {
    return [DataManager loadFromXML:@"senators"];
}

+(NSArray *) loadRepresentativesFromXML {
    return [DataManager loadFromXML:@"representatives"];;
}

+(NSArray *) loadFromXML: (NSString *) xmlFileName {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    MemberXMLParserDelegate *delegate = [[MemberXMLParserDelegate alloc] init];
    parser.delegate = delegate;
    [parser parse];
    
    NSMutableArray *members = delegate.members;
    
    //Let's try sorting the members by state
    //See: http://stackoverflow.com/questions/805547/how-to-sort-an-nsmutablearray-with-custom-objects-in-it
    NSArray *sortedArray;
    sortedArray = [members sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        NSComparisonResult retVal;
        Member *aMember = (Member *)a;
        Member *bMember = (Member *)b;
        
        //Sort by full state name
        NSDictionary *states = [[[StatePickerViewDelegate alloc] init] states];
        NSString *firstState = [states objectForKey:[(Member*)a state]];
        NSString *secondState = [states objectForKey:[(Member*)b state]];

        if ( [firstState isEqualToString:secondState] ) {
            if ( aMember.isSenator ) {
                //Order senior Senators first
                if ( [aMember.stateRank isEqualToString:@"junior"] ) {
                    retVal = NSOrderedAscending;
                } else {
                    retVal = NSOrderedDescending;
                }
            } else {
                //Order Representatives by district
                NSInteger firstDist = [aMember.district integerValue];
                NSInteger secondDist = [bMember.district integerValue];
                if ( firstDist == secondDist ) {
                    retVal = NSOrderedSame;
                } else if ( firstDist > secondDist ) {
                    retVal = NSOrderedDescending;
                } else {
                    retVal = NSOrderedAscending;
                }
            }
        } else
            retVal = [firstState compare:secondState];
        
        return retVal;
    }];
    
    return sortedArray;
}

@end
