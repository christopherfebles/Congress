//
//  Member.m
//  CongressCards
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Member.h"

@implementation Member

@synthesize memberFull, lastName, firstName, party, state, address, phone, email, website, bioguide_id, photoFileName;

- (NSString *) memberFull {
    
    NSMutableString *displayText = [NSMutableString stringWithString:[self firstName]];
    [displayText appendString:@" "];
    [displayText appendString:[self lastName]];
    [displayText appendString:@" ("];
    [displayText appendString:[self party]];
    [displayText appendString:@"-"];
    [displayText appendString:[self state]];
    [displayText appendString:@")"];
    
    return displayText;
}

@end
