//
//  Senator.h
//  CongressCards
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Member.h"

@interface Senator : Member {
    NSString *senatorClass;
}

@property (nonatomic, retain) NSString *senatorClass;

@end
