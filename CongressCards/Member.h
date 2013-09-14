//
//  Member.h
//  Congress
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Committee.h"

@interface Member : NSObject

//Custom Fields
@property (nonatomic, retain) NSString *memberFull;
@property (nonatomic, retain) NSMutableArray *committees;
@property (nonatomic, retain) NSString *photoFileName;
@property (nonatomic, retain) NSString *thumbnailFileName;

//Sunlight Fields
@property (nonatomic, assign) BOOL inOffice;
@property (nonatomic, retain) NSString *party;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *stateName;
@property (nonatomic, retain) NSString *district;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *chamber;
@property (nonatomic, retain) NSString *senateClass;
@property (nonatomic, retain) NSString *stateRank;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *termStart;
@property (nonatomic, retain) NSString *termEnd;

//Identifiers
@property (nonatomic, retain) NSString *bioguideId;
@property (nonatomic, retain) NSString *thomasId;
@property (nonatomic, retain) NSString *govtrackId;
@property (nonatomic, retain) NSString *votesmartId;
@property (nonatomic, retain) NSString *crpId;
@property (nonatomic, retain) NSString *lisId;
@property (nonatomic, retain) NSMutableArray *fecIds;

//Names
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *middleName;
@property (nonatomic, retain) NSString *nameSuffix;

//Contact fields
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *contactForm;
@property (nonatomic, retain) NSString *fax;

//Social Media
@property (nonatomic, retain) NSString *twitterId;
@property (nonatomic, retain) NSString *youtubeId;
@property (nonatomic, retain) NSString *facebookId;

- (NSString *) memberFull;
- (void) addCommittee: (Committee *) newCommittee;
- (void) addFECId: (NSString *) fecId;
- (BOOL) isSenator;
- (NSString *) fullTitle;

@end
