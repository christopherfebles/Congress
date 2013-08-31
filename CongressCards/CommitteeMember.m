//
//  CommitteeMember.m
//  Congress
//
//  Created by Christopher Febles on 7/12/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "CommitteeMember.h"

@implementation CommitteeMember

@synthesize side, rank, title, legislator, committee_id;

- (BOOL)isEqual:(id)other {
    return [[self legislator] isEqual:[(CommitteeMember *)other legislator]] && [[self committee_id] isEqualToString:[(CommitteeMember *)other committee_id]];
}
- (NSUInteger)hash {
    return [[self legislator] hash] + [[self committee_id] hash];
}

@end
