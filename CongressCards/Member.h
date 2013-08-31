//
//  Member.h
//  CongressCards
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Committee.h"

@interface Member : NSObject <NSCoding> {
    
    //Raw data objects
    NSDictionary *memberData;
    NSArray *committeeData;
    NSMutableArray *committeeMemberData;
    
    //Name
    NSString *memberFull;
    NSString *first_name;
    NSString *last_name;
    NSString *nickname;
    NSString *middle_name;
    NSString *name_suffix;
    
    //Legislative Fields
    BOOL in_office;
    NSString *party;
    NSString *gender;
    NSString *state;
    NSString *state_name;
    int district;
    NSString *title;
    BOOL senator;
    NSString *chamber;
    int senate_class;
    NSString *state_rank;
    NSString *birthday;
    NSString *term_start;
    NSString *term_end;
    
    //Identifiers
    NSString *bioguide_id;
    NSString *thomas_id;
    NSString *govtrack_id;
    NSString *votesmart_id;
    NSString *crp_id;
    NSString *lis_id;
    NSMutableArray *fec_ids;
    
    //Contact
    NSString *phone;
    NSString *website;
    NSString *office;
    NSString *contact_form;
    NSString *fax;
    
    //Social Media
    NSString *twitter_id;
    NSString *youtube_id;
    NSString *facebook_id;
    
    //Photos
    NSString *photoFileName;
    NSString *thumbnailFileName;
    
    NSString *leadershipPosition;
    NSMutableArray *committees;
    NSMutableArray *terms;
}

@property (nonatomic, retain) NSDictionary *memberData;
@property (nonatomic, retain) NSArray *committeeData;
@property (nonatomic, retain) NSMutableArray *committeeMemberData;

@property (nonatomic, retain) NSString *memberFull;
@property (nonatomic, retain) NSString *first_name;
@property (nonatomic, retain) NSString *last_name;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *middle_name;
@property (nonatomic, retain) NSString *name_suffix;

//Legislative Fields
@property (nonatomic, assign) BOOL in_office;
@property (nonatomic, retain) NSString *party;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *state_name;
@property (nonatomic, assign) int district;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) BOOL senator;
@property (nonatomic, retain) NSString *chamber;
@property (nonatomic, assign) int senate_class;
@property (nonatomic, retain) NSString *state_rank;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *term_start;
@property (nonatomic, retain) NSString *term_end;

//Identifiers
@property (nonatomic, retain) NSString *bioguide_id;
@property (nonatomic, retain) NSString *thomas_id;
@property (nonatomic, retain) NSString *govtrack_id;
@property (nonatomic, retain) NSString *votesmart_id;
@property (nonatomic, retain) NSString *crp_id;
@property (nonatomic, retain) NSString *lis_id;
@property (nonatomic, retain) NSMutableArray *fec_ids;

//Contact
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *contact_form;
@property (nonatomic, retain) NSString *fax;

//Social Media
@property (nonatomic, retain) NSString *twitter_id;
@property (nonatomic, retain) NSString *youtube_id;
@property (nonatomic, retain) NSString *facebook_id;

//Photos
@property (nonatomic, retain) NSString *photoFileName;
@property (nonatomic, retain) NSString *thumbnailFileName;

@property (nonatomic, retain) NSString *leadershipPosition;
@property (nonatomic, retain) NSMutableArray *committees;
@property (nonatomic, retain) NSMutableArray *terms;

- (NSString *) memberFull;
- (NSString *) address;
- (void) addCommittee: (Committee *) newCommittee;

- (void) addCommitteeMemberData:(NSArray *)data;
- (void) handleCommitteeMemberData:(NSArray *)data;

- (BOOL)isEqual:(id)other;
- (NSUInteger)hash;

@end
