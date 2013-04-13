//
//  Member.m
//  CongressCards
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Member.h"
#import "CommitteeAssignment.h"
#import "StatePickerViewDelegate.h"

@implementation Member

@synthesize memberFull, lastName, firstName, party, state, address, phone, email, website, bioguide_id, photoFileName,
    thumbnailFileName, classDistrict, hometown, leadershipPosition, committees, senator;

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

- (void) addCommitteeAssignment: (CommitteeAssignment *) newCommittee {
    if ( !self.committees )
        self.committees = [[NSMutableArray alloc] init];
    [[self committees] addObject:newCommittee];
}

- (void) setPhotoFileName:(NSString *)newPhotoFileName {
    photoFileName = newPhotoFileName;
    thumbnailFileName = [newPhotoFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumb.jpg"];
}

- (NSString *) address {
    NSMutableString *retVal = [[NSMutableString alloc] initWithString:[address capitalizedString]];
    
    //Capitalize states in address
    NSArray *stateAbbrs = [[[StatePickerViewDelegate alloc] init].states allKeys];
    for ( NSString *abbr in stateAbbrs ) {
        NSMutableString *abbrToCheck = [[NSMutableString alloc] initWithString:abbr];
        [abbrToCheck appendString:@" "];
        [abbrToCheck insertString:@" " atIndex:0];
        NSRange range = [retVal rangeOfString:abbrToCheck options:NSCaseInsensitiveSearch];
        if ( range.location != NSNotFound ) {
            [retVal replaceCharactersInRange:range withString:abbrToCheck];
            break;
        }
    }
    
    //Capitalize HOB addresses
    NSRange range = [retVal rangeOfString:@" Hob "];
    if ( range.location != NSNotFound )
        [retVal replaceCharactersInRange:range withString:@" HOB "];
    
    return retVal;
}

@end
