//
//  SenateXMLParserDelegate.h
//  Core Data Generator
//
//  Created by Christopher Febles on 3/5/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Member.h"
#import "CommitteeAssignment.h"

@interface MemberXMLParserDelegate : NSObject <NSXMLParserDelegate> {
    Member *member;
    NSMutableArray *members;
    NSMutableString *elementValue;
    CommitteeAssignment *curCommittee;
}

@property (nonatomic, retain) Member *member;
@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSMutableString *elementValue;
@property (nonatomic, retain) CommitteeAssignment *curCommittee;

@end
