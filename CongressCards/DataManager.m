//
//  DataManager.m
//  CongressCards
//
//  Created by Christopher Febles on 2/21/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import "DataManager.h"
#import "SenateXMLParserDelegate.h"
#import "Senator.h"

@implementation DataManager

NSString *const SenateURL = @"http://www.senate.gov/general/contact_information/senators_cfm.xml";

+(NSArray *) loadSenatorsFromXML {
    
    NSURL *url = [NSURL URLWithString:SenateURL];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    SenateXMLParserDelegate *delegate = [[SenateXMLParserDelegate alloc] init];
    [parser setDelegate:delegate];
    [parser parse];
    
    NSMutableArray *senators = [delegate senators];
    
    //Let's try sorting the senators by state
    //See: http://stackoverflow.com/questions/805547/how-to-sort-an-nsmutablearray-with-custom-objects-in-it
    NSArray *sortedArray;
    sortedArray = [senators sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Senator*)a state];
        NSString *second = [(Senator*)b state];
        return [first compare:second];
    }];
    
    return sortedArray;
}

@end
