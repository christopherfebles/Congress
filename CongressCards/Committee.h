//
//  Committee.h
//  Congress
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Committee : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *committeeId;
@property (nonatomic, retain) NSString *chamber;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, assign) BOOL subcommittee;
@property (nonatomic, retain) NSString *parentCommitteeId;

@end
