//
//  CommitteeAssignment.h
//  CongressCards
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitteeAssignment : NSObject {
    NSString *name;
    NSString *position;
    NSMutableDictionary *committeeSites;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSMutableDictionary *committeeSites;

- (NSString *) website;

@end
