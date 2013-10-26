//
//  SenateXMLParserDelegate.h
//  Core Data Generator
//
//  Created by Christopher Febles on 3/5/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
#import "Committee.h"

@interface MemberXMLParserDelegate : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain) Member *member;
@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSMutableString *elementValue;
@property (nonatomic, retain) Committee *currentCommittee;
@property (nonatomic, retain) Member *committeeMember;
@property (nonatomic, retain) Committee *parentCommittee;
@property (nonatomic, retain) Committee *subCommittee;

@end
