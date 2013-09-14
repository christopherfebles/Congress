//
//  Member.m
//  Congress
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Member.h"
#import "Committee.h"

@implementation Member

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

- (void) addCommittee: (Committee *) newCommittee {
    if ( !self.committees ) {
        self.committees = [[NSMutableArray alloc] init];
    }
    [self.committees addObject:newCommittee];
}

- (void) addFECId: (NSString *) fecId {
    if ( !self.fecIds ) {
        self.fecIds = [[NSMutableArray alloc] init];
    }
    [self.fecIds addObject:fecId];
}

- (void) setPhotoFileName:(NSString *)newPhotoFileName {
    _photoFileName = newPhotoFileName;
    _thumbnailFileName = [newPhotoFileName stringByReplacingOccurrencesOfString:@".png" withString:@"_thumb.png"];
}

- (BOOL) isSenator {
    return [self.chamber isEqualToString:@"senate"];
}

- (NSString *) fullTitle {
    NSString *title = self.title;
    if ( [title isEqualToString:@"Rep"] )
        title = @"Representative";
    else if ( [title isEqualToString:@"Del"] )
        title = @"Delegate";
    else if ( [title isEqualToString:@"Com"] )
        title = @"Resident Commissioner";
    else if ( [title isEqualToString:@"Sen"] )
        title = @"Senator";
    return title;
}

- (BOOL)isEqual:(id)other {
    
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self.bioguideId isEqualToString:((Member *)other).bioguideId];
}

- (NSUInteger)hash {
    return [self.bioguideId hash];
}

@end
