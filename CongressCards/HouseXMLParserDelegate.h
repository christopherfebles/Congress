//
//  HouseXMLParserDelegate.h
//  CongressCards
//
//  Created by Christopher Febles on 4/1/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Representative.h"

@interface HouseXMLParserDelegate : NSObject <NSXMLParserDelegate> {
    Representative *member;
    NSMutableArray *members;
    NSString *elementValue;
}

@property (nonatomic, retain) Representative *member;
@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSString *elementValue;

@end
