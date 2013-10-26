//
//  Committee.m
//  Congress
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Committee.h"
#import "Member.h"

@implementation Committee

- (void) addCommitteeMember: (Member *) newCommitteeMember {
    if ( !self.committeeMembers ) {
        self.committeeMembers = [[NSMutableArray alloc] init];
    }
    
    [self.committeeMembers addObject:newCommitteeMember];
}

- (void) addSubCommittee:(Committee *)newCommittee {
    if ( !self.subCommittees ) {
        self.subCommittees = [[NSMutableArray alloc] init];
    }
    
    [self.subCommittees addObject:newCommittee];
}

- (BOOL)isEqual:(id)other {
    
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self.committeeId isEqualToString:((Committee *)other).committeeId];
}

- (NSUInteger)hash {
    return [self.committeeId hash];
}

@end
