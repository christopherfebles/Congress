//
//  Representative.h
//  CongressCards
//
//  Created by Christopher Febles on 4/1/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Member.h"

@interface Representative : Member {
    NSString *district;
}

@property (nonatomic, retain) NSString *district;

@end
