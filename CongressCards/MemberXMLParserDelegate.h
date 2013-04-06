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

@interface MemberXMLParserDelegate : NSObject <NSXMLParserDelegate> {
    Member *member;
    NSMutableArray *members;
    NSString *elementValue;
}

@property (nonatomic, retain) Member *member;
@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSString *elementValue;

@end
