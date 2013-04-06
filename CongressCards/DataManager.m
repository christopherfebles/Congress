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

@implementation DataManager

+(NSArray *) loadSenatorsFromXML {
    return [DataManager loadFromXML:@"senate"];
}

+(NSArray *) loadRepresentativesFromXML {
    return [DataManager loadFromXML:@"house"];;
}

+(NSArray *) loadFromXML: (NSString *) xmlFileName {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    MemberXMLParserDelegate *delegate = [[MemberXMLParserDelegate alloc] init];
    [parser setDelegate:delegate];
    [parser parse];
    
    NSMutableArray *members = [delegate members];
    
    //Let's try sorting the members by state
    //See: http://stackoverflow.com/questions/805547/how-to-sort-an-nsmutablearray-with-custom-objects-in-it
    NSArray *sortedArray;
    sortedArray = [members sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSMutableString *first = [[NSMutableString alloc] initWithString:[(Member*)a state]];
        [first appendString:[(Member*)a classDistrict]];
        
        NSMutableString *second = [[NSMutableString alloc] initWithString:[(Member*)b state]];
        [second appendString:[(Member*)b classDistrict]];
        
        return [first compare:second];
    }];
    
    return sortedArray;
}

@end
