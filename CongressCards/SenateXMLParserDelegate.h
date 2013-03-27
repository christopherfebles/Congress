//
//  SenateXMLParserDelegate.h
//  Core Data Generator
//
//  Created by Christopher Febles on 3/5/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Senator.h"

@interface SenateXMLParserDelegate : NSObject <NSXMLParserDelegate> {
    Senator *member;
    NSMutableArray *senators;
    NSString *elementValue;
}

@property (nonatomic, retain) Senator *member;
@property (nonatomic, retain) NSMutableArray *senators;
@property (nonatomic, retain) NSString *elementValue;

@end
