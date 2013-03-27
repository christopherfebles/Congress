//
//  SenateXMLParserDelegate.m
//  Core Data Generator
//
//  Created by Christopher Febles on 3/5/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "SenateXMLParserDelegate.h"

@implementation SenateXMLParserDelegate

@synthesize senators, member, elementValue;

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"Started parsing %@", elementName);
    
    if ( senators == nil )
        senators = [[NSMutableArray alloc] init];
    
    if ([elementName isEqualToString:@"member"]) {
        
        if ( member != nil ) {
            //Save member
            [senators addObject:member];
        }
        
        //Create new Senate Member
        member = [[Senator alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"Processing value for : %@", string);
    elementValue = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    NSLog(@"Setting value for element: %@", elementName);
    if ( elementValue != nil ) {
        NSLog(@"Processing value for: %@", elementValue);
        if ([elementName isEqualToString:@"member_full"]) {
            member.memberFull = elementValue;
        }
        elementValue = nil;
    }
    NSLog(@"Finished parsing %@", elementName);
}

@end
