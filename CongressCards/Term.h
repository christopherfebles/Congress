//
//  Term.h
//  Congress
//
//  Created by Christopher Febles on 7/12/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Term : NSObject {
    
    NSString *start;
    NSString *end;
    NSString *state;
    NSString *party;
    NSString *senateClass;
    NSString *title;
    NSString *chamber;
}

@property (nonatomic, retain) NSString *start;
@property (nonatomic, retain) NSString *end;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *party;
@property (nonatomic, retain) NSString *senateClass;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *chamber;

@end
