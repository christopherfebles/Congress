//
//  Committee.m
//  CongressCards
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Committee.h"

@implementation Committee

@synthesize name,committee_id,chamber,url,office,phone,subcommittee,members,subcommittees,parent_committee_id,parent_committee;

- (BOOL)isEqual:(id)other {
    return [[self committee_id] isEqualToString:[(Committee *)other committee_id]];
}
- (NSUInteger)hash {
    return [[self committee_id] hash];
}

@end
