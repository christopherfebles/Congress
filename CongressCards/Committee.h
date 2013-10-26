//
//  Committee.h
//  Congress
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface Committee : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *committeeId;
@property (nonatomic, retain) NSString *chamber;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, assign) BOOL subcommittee;
@property (nonatomic, retain) NSString *parentCommitteeId;
@property (nonatomic, retain) Committee *parentCommittee;
@property (nonatomic, retain) NSMutableArray *committeeMembers;
@property (nonatomic, retain) NSMutableArray *subCommittees;

- (void) addCommitteeMember: (Member *) newCommitteeMember;
- (void) addSubCommittee: (Committee *) newCommittee;

@end
