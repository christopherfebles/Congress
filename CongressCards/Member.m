//
//  Member.m
//  Congress
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Member.h"
#import "Committee.h"

@implementation Member {
    BOOL sorted;
}

- (id)init {
    self = [super init];
    if (self) {
        sorted = NO;
    }
    return self;
}

- (NSString *) memberFull {
    
    NSMutableString *displayText = [NSMutableString stringWithString:self.firstName];
    [displayText appendString:@" "];
    [displayText appendString:self.lastName];
    [displayText appendString:@" ("];
    [displayText appendString:self.party];
    [displayText appendString:@"-"];
    [displayText appendString:self.state];
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

- (NSMutableArray *) committees {
    
    if ( !sorted ) {
        //Sort alphabetically
        NSArray *sortedArray = [_committees sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSComparisonResult retVal = [[(Committee*)a name] compare:[(Committee*)b name]];
            
            return retVal;
        }];
        _committees = [[NSMutableArray alloc] initWithArray:sortedArray];
    }
    
    return _committees;
}

- (NSString *) photoFileName {
    if ( !_photoFileName ) {
        _photoFileName = [self.bioguideId stringByAppendingString:@".png"];
    }
    
    return _photoFileName;
}

- (NSString *) thumbnailFileName {
    if ( !_thumbnailFileName ) {
        _thumbnailFileName = [self.bioguideId stringByAppendingString:@"_thumb.png"];
    }
    
    return _thumbnailFileName;
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
