//
//  SenateXMLParserDelegate.m
//  Core Data Generator
//
//  Created by Christopher Febles on 3/5/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "MemberXMLParserDelegate.h"

@implementation MemberXMLParserDelegate

@synthesize members, member, elementValue, curCommittee;

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"Started parsing %@", elementName);
    
    if ( members == nil )
        members = [[NSMutableArray alloc] init];
    
    if ([elementName isEqualToString:@"member"]) {
        
        if ( member != nil ) {            
            //Check if image exists for this member
            UIImage *tempImage = [UIImage imageNamed:member.photoFileName];
            if ( !tempImage )
                NSLog(@"Image not found: %@", member.photoFileName);
            else
            //Save member
            [members addObject:member];
        }
        
        //Create new Senate Member
        member = [[Member alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"Processing value for : %@", string);
    if ( !elementValue )
        elementValue = [NSMutableString string];
    [elementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
//    NSLog(@"Setting value for element: %@", elementName);
    
    if ( elementValue != nil ) {
        elementValue = [[NSMutableString alloc] initWithString:[elementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        //Check for Java "null"
        if ( [elementValue isEqualToString:@"null"] ) {
            elementValue = nil;
            return;
        }
        
//        NSLog(@"Processing value for: %@", elementValue);
//        if ([elementName isEqualToString:@"lastName"]) {
//            member.lastName = elementValue;
//        } else if ([elementName isEqualToString:@"firstName"]) {
//            member.firstName = elementValue;
//        } else if ([elementName isEqualToString:@"party"]) {
//            member.party = elementValue;
//        } else if ([elementName isEqualToString:@"state"]) {
//            member.state = elementValue;
//        } else if ([elementName isEqualToString:@"address"]) {
//            member.address = elementValue;
//        } else if ([elementName isEqualToString:@"phone"]) {
//            member.phone = elementValue;
//        } else if ([elementName isEqualToString:@"email"]) {
//            member.email = elementValue;
//        } else if ([elementName isEqualToString:@"website"]) {
//            member.website = elementValue;
//        } else if ([elementName isEqualToString:@"classDistrict"]) {
//            member.classDistrict = elementValue;
//        } else if ([elementName isEqualToString:@"bioguideId"]) {
//            member.bioguide_id = elementValue;
//        } else if ([elementName isEqualToString:@"imgFileName"]) {
//            member.photoFileName = elementValue;
//        } else if ([elementName isEqualToString:@"isSenator"]) {
//            member.senator = [elementValue isEqualToString:@"true"];
//        } else if ([elementName isEqualToString:@"hometown"]) {
//            member.hometown = elementValue;
//        } else if ([elementName isEqualToString:@"leadershipPosition"]) {
//            member.leadershipPosition = elementValue;
//        } else if ([elementName isEqualToString:@"name"]) {
//            curCommittee = [[CommitteeAssignment alloc] init];
//            curCommittee.name = elementValue;
//        } else if ([elementName isEqualToString:@"position"]) {
//            curCommittee.position = elementValue;
//            [member addCommitteeAssignment:curCommittee];
//        } else if ([elementName isEqualToString:@"link"]) {
//            curCommittee.link = elementValue;
////            [member addCommitteeAssignment:curCommittee];
//        }
        elementValue = nil;
    }
//    NSLog(@"Finished parsing %@", elementName);
}

@end
