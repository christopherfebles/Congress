//
//  SenateXMLParserDelegate.m
//  Core Data Generator
//
//  Created by Christopher Febles on 3/5/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "MemberXMLParserDelegate.h"
// I really feel like there's a better way to do this, but I can't seem to find it.
@implementation MemberXMLParserDelegate

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"Started parsing %@", elementName);
    
    if ( !self.members )
        self.members = [[NSMutableArray alloc] init];
    
    if ( [elementName isEqualToString:@"committee"] ) {
        self.currentCommittee = [[Committee alloc] init];
    }
    
    if ([elementName isEqualToString:@"legislator"]) {
        //Create new Member
        self.member = [[Member alloc] init];
    }
    
    if ( [elementName isEqualToString:@"parent_committee"] ) {
        self.parentCommittee = [[Committee alloc] init];
    }
    
    if ( [elementName isEqualToString:@"subcommittees"] ) {
        self.subCommittee = [[Committee alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"Processing value for : %@", string);
    if ( !self.elementValue )
        self.elementValue = [NSMutableString string];
    [self.elementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    //Maybe I should have given each field a unique name. Live and learn.
//    NSLog(@"Setting value for element: %@", elementName);
    
    if ( self.elementValue != nil ) {
        self.elementValue = [[NSMutableString alloc] initWithString:[self.elementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        //Check for Java "null"
        if ( [self.elementValue isEqualToString:@"null"] ) {
            self.elementValue = nil;
            return;
        }
        
//        NSLog(@"Processing value for: %@", self.elementValue);
        
        //Sunlight Fields
        if ([elementName isEqualToString:@"in_office"]) {
            self.member.inOffice = [self.elementValue isEqualToString:@"true"];
        } else if ([elementName isEqualToString:@"party"]) {
            self.member.party = self.elementValue;
        } else if ([elementName isEqualToString:@"gender"]) {
            self.member.gender = self.elementValue;
        } else if ([elementName isEqualToString:@"state"]) {
            self.member.state = self.elementValue;
        } else if ([elementName isEqualToString:@"state_name"]) {
            self.member.stateName = self.elementValue;
        } else if ([elementName isEqualToString:@"district"]) {
            self.member.district = self.elementValue;
        } else if ([elementName isEqualToString:@"title"]) {
            self.member.title = self.elementValue;
        } else if ([elementName isEqualToString:@"chamber"]) {
            if ( self.currentCommittee && !self.currentCommittee.chamber ) {
                //Committee chamber may be "joint"
                self.currentCommittee.chamber = self.elementValue;
            } else if ( self.subCommittee ) {
                self.subCommittee.chamber = self.elementValue;
            } else if ( self.parentCommittee ) {
                self.parentCommittee.chamber = self.elementValue;
            } else {
                self.member.chamber = self.elementValue;
            }
        } else if ([elementName isEqualToString:@"senate_class"]) {
            self.member.senateClass = self.elementValue;
        } else if ([elementName isEqualToString:@"state_rank"]) {
            self.member.stateRank = self.elementValue;
        } else if ([elementName isEqualToString:@"birthday"]) {
            self.member.birthday = self.elementValue;
        } else if ([elementName isEqualToString:@"term_start"]) {
            self.member.termStart = self.elementValue;
        } else if ([elementName isEqualToString:@"term_end"]) {
            self.member.termEnd = self.elementValue;
        }
        
        //Identifying Fields
        else if ([elementName isEqualToString:@"bioguide_id"]) {
            self.member.bioguideId = self.elementValue;
        } else if ([elementName isEqualToString:@"thomas_id"]) {
            self.member.thomasId = self.elementValue;
        } else if ([elementName isEqualToString:@"govtrack_id"]) {
            self.member.govtrackId = self.elementValue;
        } else if ([elementName isEqualToString:@"votesmart_id"]) {
            self.member.votesmartId = self.elementValue;
        } else if ([elementName isEqualToString:@"crp_id"]) {
            self.member.crpId = self.elementValue;
        } else if ([elementName isEqualToString:@"lis_id"]) {
            self.member.lisId = self.elementValue;
        } else if ([elementName isEqualToString:@"fec_ids"]) {
            [self.member addFECId: self.elementValue];
        }
        
        //Names
        else if ([elementName isEqualToString:@"first_name"]) {
            self.member.firstName = self.elementValue;
        } else if ([elementName isEqualToString:@"last_name"]) {
            self.member.lastName = self.elementValue;
        } else if ([elementName isEqualToString:@"nickname"]) {
            self.member.nickname = self.elementValue;
        } else if ([elementName isEqualToString:@"middle_name"]) {
            self.member.middleName = self.elementValue;
        } else if ([elementName isEqualToString:@"name_suffix"]) {
            self.member.nameSuffix = self.elementValue;
        }
        
        //Contact fields
        else if ([elementName isEqualToString:@"phone"]) {
            if ( self.currentCommittee && !self.currentCommittee.phone ) {
                self.currentCommittee.phone = self.elementValue;
            } else if ( self.subCommittee ) {
                self.subCommittee.phone = self.elementValue;
            } else if ( self.parentCommittee ) {
                self.parentCommittee.phone = self.elementValue;
            } else {
                self.member.phone = self.elementValue;
            }
        } else if ([elementName isEqualToString:@"website"]) {
            self.member.website = self.elementValue;
        } else if ([elementName isEqualToString:@"office"]) {
            if ( self.currentCommittee && !self.currentCommittee.office ) {
                self.currentCommittee.office = self.elementValue;
            } else if ( self.subCommittee ) {
                self.subCommittee.office = self.elementValue;
            } else if ( self.parentCommittee ) {
                self.parentCommittee.office = self.elementValue;
            } else {
                self.member.office = self.elementValue;
            }
        } else if ([elementName isEqualToString:@"contact_form"]) {
            self.member.contactForm = self.elementValue;
        } else if ([elementName isEqualToString:@"fax"]) {
            self.member.fax = self.elementValue;
        }
        
        //Social Media
        else if ([elementName isEqualToString:@"twitter_id"]) {
            self.member.twitterId = self.elementValue;
        } else if ([elementName isEqualToString:@"youtube_id"]) {
            self.member.youtubeId = self.elementValue;
        } else if ([elementName isEqualToString:@"facebook_id"]) {
            self.member.facebookId = self.elementValue;
        }
        
        //Committees
        else if ([elementName isEqualToString:@"name"]) {
            if ( self.currentCommittee && !self.currentCommittee.name ) {
                self.currentCommittee.name = self.elementValue;
            } else if ( self.subCommittee ) {
                self.subCommittee.name = self.elementValue;
            } else if ( self.parentCommittee ) {
                self.parentCommittee.name = self.elementValue;
            }
        } else if ([elementName isEqualToString:@"committee_id"]) {
            if ( self.currentCommittee && !self.currentCommittee.committeeId ) {
                self.currentCommittee.committeeId = self.elementValue;
            } else if ( self.subCommittee ) {
                self.subCommittee.committeeId = self.elementValue;
            } else if ( self.parentCommittee ) {
                self.parentCommittee.committeeId = self.elementValue;
            }
        } else if ([elementName isEqualToString:@"subcommittee"]) {
            if ( self.currentCommittee && !self.currentCommittee.subcommittee ) {
                self.currentCommittee.subcommittee = [self.elementValue isEqualToString:@"true"];
            } else if ( self.subCommittee ) {
                self.subCommittee.subcommittee = [self.elementValue isEqualToString:@"true"];
            } else if ( self.parentCommittee ) {
                self.parentCommittee.subcommittee = [self.elementValue isEqualToString:@"true"];
            }
        } else if ([elementName isEqualToString:@"parent_committee_id"]) {
            if ( self.currentCommittee && !self.currentCommittee.parentCommitteeId ) {
                self.currentCommittee.parentCommitteeId = self.elementValue;
            } else if ( self.subCommittee ) {
                self.subCommittee.parentCommitteeId = self.elementValue;
            } else if ( self.parentCommittee ) {
                self.parentCommittee.parentCommitteeId = self.elementValue;
            }
        } else if ([elementName isEqualToString:@"url"]) {
            if ( self.currentCommittee && !self.currentCommittee.url ) {
                self.currentCommittee.url = self.elementValue;
            } else if ( self.subCommittee ) {
                self.subCommittee.url = self.elementValue;
            } else if ( self.parentCommittee ) {
                self.parentCommittee.url = self.elementValue;
            }
        }
        
        self.elementValue = nil;
    }
    
    if ( [elementName isEqualToString:@"committee"] ) {
        //Save last processed Parent or Subcommittee
        if ( self.parentCommittee ) {
            self.currentCommittee.parentCommittee = self.parentCommittee;
            self.currentCommittee.parentCommitteeId = self.parentCommittee.parentCommitteeId;
            self.parentCommittee = nil;
        }
        if ( self.subCommittee ) {
            [self.currentCommittee addSubCommittee:self.subCommittee];
            self.subCommittee = nil;
        }
        
        if ( self.currentCommittee ) {
            [self.member addCommittee:self.currentCommittee];
        }
        self.currentCommittee = nil;
    }
    
    if ([elementName isEqualToString:@"legislator"]) {
        
        if ( self.member ) {
            //Save last processed committee
            if ( self.currentCommittee ) {
                [self.member addCommittee:self.currentCommittee];
                self.currentCommittee = nil;
            }
            //Save member
            [self.members addObject:self.member];
        }
        
        self.member = nil;
    }
    
    if ( [elementName isEqualToString:@"subcommittees"] ) {
        //Save last processed Subcommittee
        if ( self.subCommittee ) {
            [self.currentCommittee addSubCommittee:self.subCommittee];
            self.subCommittee = nil;
        }
    }
    
    if ( [elementName isEqualToString:@"parent_committee"] ) {
        //Save last processed Parent Committee
        if ( self.parentCommittee ) {
            self.currentCommittee.parentCommittee = self.parentCommittee;
            self.currentCommittee.parentCommitteeId = self.parentCommittee.parentCommitteeId;
            self.parentCommittee = nil;
        }
    }
    
//    NSLog(@"Finished parsing %@", elementName);
}

@end
