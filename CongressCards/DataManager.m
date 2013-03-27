//
//  DataManager.m
//  CongressCards
//
//  Created by Christopher Febles on 2/21/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import "DataManager.h"
#import "SenateXMLParserDelegate.h"

@implementation DataManager

NSString *const SenateURL = @"http://www.senate.gov/general/contact_information/senators_cfm.xml";

+(NSArray *) loadSenatorsFromXML {
    
//    NSMutableArray *senatorList = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:SenateURL];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    SenateXMLParserDelegate *delegate = [[SenateXMLParserDelegate alloc] init];
    [parser setDelegate:delegate];
    [parser parse];
    
    NSMutableArray *senators = [delegate senators];
    
    return senators;
}

@end
