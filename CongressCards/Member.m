//
//  Member.m
//  CongressCards
//
//  Created by Christopher Febles on 3/27/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "Member.h"
#import "Committee.h"
#import "CommitteeMember.h"
#import "StatePickerViewDelegate.h"

@implementation Member

@synthesize memberFull,first_name,last_name,nickname,middle_name,name_suffix,in_office,party,gender,state,state_name,district,title,senator,chamber,senate_class,state_rank,birthday,term_start,term_end,bioguide_id,thomas_id,govtrack_id,votesmart_id,crp_id,lis_id,fec_ids,phone,website,office,contact_form,fax,twitter_id,youtube_id,facebook_id,photoFileName,thumbnailFileName,leadershipPosition,committees,terms, memberData, committeeData, committeeMemberData;

+ (NSString *) path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"200x250"];
    
    return documentsDirectory;
}

- (NSString *) photoFileName {
    NSString *filename = [self bioguide_id];
    filename = [filename stringByAppendingPathExtension:@"jpg"];
    return [[Member path] stringByAppendingPathComponent:filename];
}

- (NSString *) thumbnailFileName {
    NSMutableString *filename = [[NSMutableString alloc] initWithString:[self bioguide_id]];
    [filename appendString:@"-thumb"];
    NSString *filenameStr = [filename stringByAppendingPathExtension:@"jpg"];
    return [[Member path] stringByAppendingPathComponent:filenameStr];
}

- (void) addCommitteeMemberData:(NSArray *)data {
    if ( committeeMemberData == nil ) committeeMemberData = [[NSMutableArray alloc] init];
    [committeeMemberData addObject:data];
    [self handleCommitteeMemberData:data];
}

- (void) setCommitteeMemberData:(NSMutableArray *)newCommitteeMemberData {
    committeeMemberData = newCommitteeMemberData;
    for ( NSArray *committeeMember in committeeMemberData )
        [self handleCommitteeMemberData:committeeMember];
}

- (void) handleCommitteeMemberData:(NSArray *)data {
    
    for ( NSDictionary *committeeMember in data ) {
        NSArray *legislator = [committeeMember valueForKey:@"legislator"];
        if ( [(NSString *)[legislator valueForKey:@"bioguide_id"] isEqualToString: [self bioguide_id]] ) {
            CommitteeMember *member = [[CommitteeMember alloc] init];
            
            [member setSide:[committeeMember valueForKey:@"side"]];
            [member setRank:[committeeMember valueForKey:@"rank"]];
            [member setTitle:[committeeMember valueForKey:@"title"]];
            [member setCommittee_id:[committeeMember valueForKey:@"committee_id"]];
            
            Member *newMember = [[Member alloc] init];
            [newMember setBioguide_id:[legislator valueForKey:@"bioguide_id"]];
            [member setLegislator:newMember];
            
            if ( [self committees] == nil ) [self setCommittees:[[NSMutableArray alloc] init]];
            Committee *newCommittee = [[Committee alloc] init];
            [newCommittee setCommittee_id:[committeeMember valueForKey:@"committee_id"]];
            int index = [[self committees] indexOfObject:newCommittee];
            Committee *committee = [[self committees] objectAtIndex:index];
            if ( [committee members] == nil ) [committee setMembers:[[NSMutableArray alloc] init]];
            [[committee members] addObject:member];
        }
    }
}

- (void) setMemberData:(NSDictionary *)newData {
    
    memberData = newData;
    
    [self setContact_form:[newData valueForKey:@"contact_form"]];
    [self setCrp_id:[newData valueForKey:@"crp_id"]];
    [self setName_suffix:[newData valueForKey:@"name_suffix"]];
    [self setState:[newData valueForKey:@"state"]];
    [self setThomas_id:[newData valueForKey:@"thomas_id"]];
    [self setPhone:[newData valueForKey:@"phone"]];
    [self setFax:[newData valueForKey:@"fax"]];
    [self setGovtrack_id: [newData valueForKey:@"govtrack_id"]];
    NSNumber *dist =[newData valueForKey:@"district"];
    if ( dist != nil && ![[NSNull null] isEqual:dist] )
        [self setDistrict:[dist intValue]];
    NSNumber *senClass = [newData valueForKey:@"senate_class"];
    if ( senClass != nil && ![[NSNull null] isEqual:senClass] )
        [self setSenate_class:[senClass intValue]];
    [self setWebsite:[newData valueForKey:@"website"]];
    [self setBirthday:[newData valueForKey:@"birthday"]];
    [self setMiddle_name:[newData valueForKey:@"middle_name"]];
    [self setFirst_name:[newData valueForKey:@"first_name"]];
    [self setParty:[newData valueForKey:@"party"]];
    [self setVotesmart_id:[newData valueForKey:@"votesmart_id"]];
    [self setGender:[newData valueForKey:@"gender"]];
    [self setBioguide_id:[newData valueForKey:@"bioguide_id"]];
    [self setChamber:[newData valueForKey:@"chamber"]];
    [self setLast_name:[newData valueForKey:@"last_name"]];
    [self setNickname:[newData valueForKey:@"nickname"]];
    [self setState_name:[newData valueForKey:@"state_name"]];
    [self setTitle:[newData valueForKey:@"title"]];
    [self setOffice:[newData valueForKey:@"office"]];
    [self setIn_office:[[newData valueForKey:@"in_office"] boolValue]];
    
    NSArray *fecIds = [newData valueForKey:@"fec_ids"];
    if ( fecIds != nil && ![[NSNull null] isEqual:fecIds] ) {
        NSMutableArray *fecIdsMut = [[NSMutableArray alloc] initWithArray:fecIds];
        [self setFec_ids:fecIdsMut];
    }
    
}

- (void) setCommitteeData:(NSArray *)newData {
    
    committeeData = newData;
    
    for ( NSDictionary *committee in newData ) {
        Committee *newCommittee = [[Committee alloc] init];
        
        [newCommittee setName:[committee valueForKey:@"name"]];
        [newCommittee setCommittee_id:[committee valueForKey:@"committee_id"]];
        [newCommittee setChamber:[committee valueForKey:@"chamber"]];
        [newCommittee setSubcommittee:[[committee valueForKey:@"subcommittee"] boolValue]];
        
        //Optional Values
        NSString *temp = [committee valueForKey:@"office"];
        if ( temp != nil && ![[NSNull null] isEqual:temp] )
            [newCommittee setOffice:temp];
        temp = [committee valueForKey:@"phone"];
        if ( temp != nil && ![[NSNull null] isEqual:temp] )
            [newCommittee setPhone:temp];
        temp = [committee valueForKey:@"parent_committee_id"];
        if ( temp != nil && ![[NSNull null] isEqual:temp] )
            [newCommittee setParent_committee_id:temp];
        
        if ( [self committees] == nil ) [self setCommittees:[[NSMutableArray alloc] init]];
        [[self committees] addObject:newCommittee];
    }
    
}

- (BOOL) senator {
    senator = [[self chamber] isEqualToString:@"senate"];
    return senator;
}

- (NSString *) memberFull {
 
    if ( memberFull == nil ) {
    
        NSMutableString *displayText = [NSMutableString stringWithString:[self first_name]];
        [displayText appendString:@" "];
        [displayText appendString:[self last_name]];
        [displayText appendString:@" ("];
        [displayText appendString:[self party]];
        [displayText appendString:@"-"];
        [displayText appendString:[self state]];
        [displayText appendString:@")"];
        
        memberFull = displayText;
    }
    
    return memberFull;
}

- (void) addCommittee: (Committee *) newCommittee {
    if ( !self.committees )
        self.committees = [[NSMutableArray alloc] init];
    [[self committees] addObject:newCommittee];
}

- (void) setPhotoFileName:(NSString *)newPhotoFileName {
    photoFileName = newPhotoFileName;
    thumbnailFileName = [newPhotoFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumb.jpg"];
}

- (NSString *) address {
    NSMutableString *retVal = [[NSMutableString alloc] initWithString:[office capitalizedString]];
    
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

- (BOOL)isEqual:(id)other {
    return [[self bioguide_id] isEqualToString:[(Member *)other bioguide_id]];
}
- (NSUInteger)hash {
    return [[self bioguide_id] hash];
}

//NSCoding methods
static NSString *const MemberDataArchiveKey = @"memberData";
static NSString *const CommitteeArchiveKey = @"committeeData";
static NSString *const CommitteeMemberArchiveKey = @"committeeMemberData";

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        [self setMemberData:(NSDictionary *)[decoder decodeObjectForKey:MemberDataArchiveKey]];
        [self setCommitteeData:(NSArray *)[decoder decodeObjectForKey:CommitteeArchiveKey]];
        [self setCommitteeMemberData:(NSMutableArray *)[decoder decodeObjectForKey:CommitteeMemberArchiveKey]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self memberData] forKey:MemberDataArchiveKey];
    [encoder encodeObject:[self committeeData] forKey:CommitteeArchiveKey];
    [encoder encodeObject:[self committeeMemberData] forKey:CommitteeMemberArchiveKey];
}

@end
