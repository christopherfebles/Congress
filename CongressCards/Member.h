//
//  Member.h
//  CongressCards
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject {
    NSString *memberFull;
    NSString *lastName;
    NSString *firstName;
    NSString *party;
    NSString *state;
    NSString *address;
    NSString *phone;
    NSString *email;
    NSString *website;
    NSString *bioguide_id;
    NSString *photoFileName;
}

@property (nonatomic, retain) NSString *memberFull;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *party;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *bioguide_id;
@property (nonatomic, retain) NSString *photoFileName;

@end
