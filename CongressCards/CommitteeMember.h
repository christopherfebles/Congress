//
//  CommitteeMember.h
//  Congress
//
//  Created by Christopher Febles on 7/12/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface CommitteeMember : NSObject {
    NSString *side;
    NSString *rank;
    NSString *title;
    Member *legislator;
    NSString *committee_id;
}

@property (nonatomic, retain) NSString *side;
@property (nonatomic, retain) NSString *rank;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) Member *legislator;
@property (nonatomic, retain) NSString *committee_id;

- (BOOL)isEqual:(id)other;
- (NSUInteger)hash;

@end
