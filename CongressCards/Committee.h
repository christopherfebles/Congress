//
//  Committee.h
//  CongressCards
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Committee : NSObject {
    NSString *name;
    NSString *committee_id;
    NSString *chamber;
    NSString *url;
    NSString *office;
    NSString *phone;
    BOOL subcommittee;
    
    NSMutableArray *members;
    NSMutableArray *subcommittees;
    NSString *parent_committee_id;
    Committee *parent_committee;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *committee_id;
@property (nonatomic, retain) NSString *chamber;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, assign) BOOL subcommittee;
@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSMutableArray *subcommittees;
@property (nonatomic, retain) NSString *parent_committee_id;
@property (nonatomic, retain) Committee *parent_committee;

- (BOOL)isEqual:(id)other;
- (NSUInteger)hash;

@end
