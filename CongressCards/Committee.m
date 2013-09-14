//
//  Committee.m
//  Congress
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Committee.h"

@implementation Committee

- (BOOL)isEqual:(id)other {
    
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self.committeeId isEqualToString:((Committee *)other).committeeId];
}

- (NSUInteger)hash {
    return [self.committeeId hash];
}

@end
