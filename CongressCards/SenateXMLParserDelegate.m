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
//    NSLog(@"Started parsing %@", elementName);
    
    if ( senators == nil )
        senators = [[NSMutableArray alloc] init];
    
    if ([elementName isEqualToString:@"member"]) {
        
        if ( member != nil ) {
            //Set Photo Filename
            NSString *firstName = [[member firstName] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            firstName = [firstName stringByReplacingOccurrencesOfString:@",_Jr." withString:@""];
            firstName = [firstName stringByReplacingOccurrencesOfString:@",_III" withString:@""];
            firstName = [firstName stringByReplacingOccurrencesOfString:@",_IV" withString:@""];
            NSString *lastName = [[member lastName] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            
            NSMutableString *fileName = [NSMutableString stringWithString: firstName];
            [fileName appendString:@"_"];
            [fileName appendString:lastName];
            
            NSMutableString *photoFileName = [NSMutableString stringWithString: fileName];
            [photoFileName appendString:@".jpeg"];
            
            //Check if file exists
            UIImage *tempImage = [UIImage imageNamed:photoFileName];
            if ( !tempImage ) {
                //Append state and check again
                photoFileName = [NSMutableString stringWithString: fileName];
                [photoFileName appendString:@"_"];
                [photoFileName appendString:[member state]];
                [photoFileName appendString:@".jpeg"];
                
                tempImage = [UIImage imageNamed:photoFileName];
                if ( !tempImage ) {
                    //If still not found, default to blank
                    NSLog(@"Unable to load image for member: %@", photoFileName);
                    photoFileName = [NSMutableString stringWithString: @"blank.jpeg"];
                }
            }
            
            member.photoFileName = photoFileName;
            //Save member
            [senators addObject:member];
        }
        
        //Create new Senate Member
        member = [[Senator alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"Processing value for : %@", string);
    elementValue = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
//    NSLog(@"Setting value for element: %@", elementName);
    if ( elementValue != nil ) {
//        NSLog(@"Processing value for: %@", elementValue);
        if ([elementName isEqualToString:@"member_full"]) {
            member.memberFull = elementValue;
        } else if ([elementName isEqualToString:@"last_name"]) {
            member.lastName = elementValue;
        } else if ([elementName isEqualToString:@"first_name"]) {
            member.firstName = elementValue;
        } else if ([elementName isEqualToString:@"party"]) {
            member.party = elementValue;
        } else if ([elementName isEqualToString:@"state"]) {
            member.state = elementValue;
        } else if ([elementName isEqualToString:@"address"]) {
            member.address = elementValue;
        } else if ([elementName isEqualToString:@"phone"]) {
            member.phone = elementValue;
        } else if ([elementName isEqualToString:@"email"]) {
            member.email = elementValue;
        } else if ([elementName isEqualToString:@"website"]) {
            member.website = elementValue;
        } else if ([elementName isEqualToString:@"class"]) {
            member.senatorClass = elementValue;
        } else if ([elementName isEqualToString:@"bioguide_id"]) {
            member.bioguide_id = elementValue;
        }
        elementValue = nil;
    }
//    NSLog(@"Finished parsing %@", elementName);
}

@end
