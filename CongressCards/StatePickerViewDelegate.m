//
//  StatePickerViewDelegate.m
//  CongressCards
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "StatePickerViewDelegate.h"

@implementation StatePickerViewDelegate

@synthesize states;

- (id)init {
    self = [super init];
    if (self) {
        [self populateStates];
    }
    return self;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
//    if ( !states ) [self populateStates];
//    NSLog(@"Selected State: %@", [self getState:row]);
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ( !states ) [self populateStates];
    return [[states allKeys] count];
}

// tell the picker how many columns it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self getState:row];
}

- (NSString *) getAbbr: (NSInteger)index {
    if ( !states ) [self populateStates];
    NSArray *stateAbbrs = [self sortKeys];    
    return [stateAbbrs objectAtIndex:index];
}

- (NSString *) getState: (NSInteger)index {
    if ( !states ) [self populateStates];
    NSArray *stateAbbrs = [self sortKeys];    
    return [states objectForKey:[stateAbbrs objectAtIndex:index]];
}

- (NSInteger) getIndex: (NSString *) stateAbbr {
    if ( !states ) [self populateStates];
    NSArray *stateAbbrs = [self sortKeys];
    return [stateAbbrs indexOfObject:stateAbbr];
}

- (NSArray *) sortKeys {
    //Return a list of State abbreviations, sorted alphabetically by full state name
    NSArray *stateNames = [states allValues];
    stateNames = [stateNames sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = (NSString *)a;
        NSString *second = (NSString *)b;
        
        return [first compare:second];
    }];
    
    NSMutableArray *sortedKeys = [[NSMutableArray alloc] init];
    for ( NSString *stateName in stateNames )
        [sortedKeys addObject:[states allKeysForObject:stateName][0]];    
    
    return sortedKeys;
}

- (void) populateStates {
    if ( !states )
        states = [[NSMutableDictionary alloc] init];
    
    [states setObject:@"Alabama" forKey:@"AL"];
    [states setObject:@"Alaska" forKey:@"AK"];
    [states setObject:@"Arizona" forKey:@"AZ"];
    [states setObject:@"Arkansas" forKey:@"AR"];
    [states setObject:@"California" forKey:@"CA"];
    [states setObject:@"Colorado" forKey:@"CO"];
    [states setObject:@"Connecticut" forKey:@"CT"];
    [states setObject:@"Delaware" forKey:@"DE"];
    [states setObject:@"District of Columbia" forKey:@"DC"];
    [states setObject:@"Florida" forKey:@"FL"];
    [states setObject:@"Georgia" forKey:@"GA"];
    [states setObject:@"Hawaii" forKey:@"HI"];
    [states setObject:@"Idaho" forKey:@"ID"];
    [states setObject:@"Illinois" forKey:@"IL"];
    [states setObject:@"Indiana" forKey:@"IN"];
    [states setObject:@"Iowa" forKey:@"IA"];
    [states setObject:@"Kansas" forKey:@"KS"];
    [states setObject:@"Kentucky" forKey:@"KY"];
    [states setObject:@"Louisiana" forKey:@"LA"];
    [states setObject:@"Maine" forKey:@"ME"];
    [states setObject:@"Maryland" forKey:@"MD"];
    [states setObject:@"Massachusetts" forKey:@"MA"];
    [states setObject:@"Michigan" forKey:@"MI"];
    [states setObject:@"Minnesota" forKey:@"MN"];
    [states setObject:@"Mississippi" forKey:@"MS"];
    [states setObject:@"Missouri" forKey:@"MO"];
    [states setObject:@"Montana" forKey:@"MT"];
    [states setObject:@"Nebraska" forKey:@"NE"];
    [states setObject:@"Nevada" forKey:@"NV"];
    [states setObject:@"New Hampshire" forKey:@"NH"];
    [states setObject:@"New Jersey" forKey:@"NJ"];
    [states setObject:@"New Mexico" forKey:@"NM"];
    [states setObject:@"New York" forKey:@"NY"];
    [states setObject:@"North Carolina" forKey:@"NC"];
    [states setObject:@"North Dakota" forKey:@"ND"];
    [states setObject:@"Ohio" forKey:@"OH"];
    [states setObject:@"Oklahoma" forKey:@"OK"];
    [states setObject:@"Oregon" forKey:@"OR"];
    [states setObject:@"Pennsylvania" forKey:@"PA"];
    [states setObject:@"Rhode Island" forKey:@"RI"];
    [states setObject:@"South Carolina" forKey:@"SC"];
    [states setObject:@"South Dakota" forKey:@"SD"];
    [states setObject:@"Tennessee" forKey:@"TN"];
    [states setObject:@"Texas" forKey:@"TX"];
    [states setObject:@"Utah" forKey:@"UT"];
    [states setObject:@"Vermont" forKey:@"VT"];
    [states setObject:@"Virginia" forKey:@"VA"];
    [states setObject:@"Virgin Islands" forKey:@"VI"];
    [states setObject:@"Washington" forKey:@"WA"];
    [states setObject:@"West Virginia" forKey:@"WV"];
    [states setObject:@"Wisconsin" forKey:@"WI"];
    [states setObject:@"Wyoming" forKey:@"WY"];
    [states setObject:@"American Samoa" forKey:@"AS"];
    [states setObject:@"Puerto Rico" forKey:@"PR"];
    [states setObject:@"Guam" forKey:@"GU"];
}

@end
