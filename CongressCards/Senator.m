//
//  Senator.m
//  CongressCards
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Senator.h"

@implementation Senator

@synthesize senatorClass;

- (void) setSenatorClass:(NSString *)newSenatorClass {
    if ( [newSenatorClass caseInsensitiveCompare:@"Class I"] == NSOrderedSame ) {
        senatorClass = @"1";
    } else if ( [newSenatorClass caseInsensitiveCompare:@"Class II"] == NSOrderedSame ) {
        senatorClass = @"2";
    } if ( [newSenatorClass caseInsensitiveCompare:@"Class III"] == NSOrderedSame ) {
        senatorClass = @"3";
    }
}

@end
