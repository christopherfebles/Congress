//
//  CommitteeAssignment.m
//  CongressCards
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "CommitteeAssignment.h"

@implementation CommitteeAssignment

@synthesize name, position, committeeSites;

- (NSString *) website {
    if ( !committeeSites )
        [self populateSites];
    
    NSString *retVal = @"";
    
    for ( NSString *key in [committeeSites allKeys] ) {
        NSRange range = [self.name rangeOfString:key options:NSCaseInsensitiveSearch];
        if ( range.location != NSNotFound ) {
            retVal = [committeeSites valueForKey:key];
            break;
        }
    }
    
    return retVal;
}

-(void) populateSites {
    if ( !committeeSites )
        committeeSites = [[NSMutableDictionary alloc] init];
    
    [committeeSites setObject:@"http://www.agriculture.senate.gov/" forKey:@"Agriculture, Nutrition, and Forestry"];
    [committeeSites setObject:@"http://www.appropriations.senate.gov/" forKey:@"Appropriations"];
    [committeeSites setObject:@"http://www.armed-services.senate.gov/" forKey:@"Armed Services"];
    [committeeSites setObject:@"http://www.banking.senate.gov/" forKey:@"Banking, Housing, and Urban Affairs"];
    [committeeSites setObject:@"http://www.budget.senate.gov/" forKey:@"Budget"];
    [committeeSites setObject:@"http://www.commerce.senate.gov/" forKey:@"Commerce, Science, and Transportation"];
    [committeeSites setObject:@"http://www.energy.senate.gov/" forKey:@"Energy and Natural Resources"];
    [committeeSites setObject:@"http://www.epw.senate.gov/" forKey:@"Environment and Public Works"];
    [committeeSites setObject:@"http://www.finance.senate.gov/" forKey:@"Finance"];
    [committeeSites setObject:@"http://www.foreign.senate.gov/" forKey:@"Foreign Relations"];
    [committeeSites setObject:@"http://www.help.senate.gov/" forKey:@"Health, Education, Labor, and Pensions"];
    [committeeSites setObject:@"http://www.hsgac.senate.gov/" forKey:@"Homeland Security and Governmental Affairs"];
    [committeeSites setObject:@"http://www.judiciary.senate.gov/" forKey:@"Judiciary"];
    [committeeSites setObject:@"http://www.rules.senate.gov/" forKey:@"Rules and Administration"];
    [committeeSites setObject:@"http://www.sbc.senate.gov/" forKey:@"Small Business and Entrepreneurship"];
    [committeeSites setObject:@"http://www.veterans.senate.gov/" forKey:@"Veterans' Affairs"];
    [committeeSites setObject:@"http://www.indian.senate.gov/" forKey:@"Indian Affairs"];
    [committeeSites setObject:@"http://www.ethics.senate.gov/" forKey:@"Select Committee on Ethics"];
    [committeeSites setObject:@"http://www.intelligence.senate.gov/" forKey:@"Select Committee on Intelligence"];
    [committeeSites setObject:@"http://www.aging.senate.gov" forKey:@"Special Committee on Aging"];
    [committeeSites setObject:@"http://www.senate.gov/general/committee_membership/committee_memberships_JSPR.htm" forKey:@"Joint Committee on Printing"];
    [committeeSites setObject:@"http://www.jct.gov/" forKey:@"Joint Committee on Taxation"];
    [committeeSites setObject:@"http://www.senate.gov/general/committee_membership/committee_memberships_JSLC.htm" forKey:@"Joint Committee on the Library"];
    [committeeSites setObject:@"http://www.jec.senate.gov/" forKey:@"Joint Economic Committee"];
}

@end
