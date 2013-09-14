//
//  StatePickerViewDelegate.m
//  Congress
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "StatePickerViewDelegate.h"

@implementation StatePickerViewDelegate

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
    if ( !self.states ) [self populateStates];
    return [[self.states allKeys] count];
}

// tell the picker how many columns it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self getStateName:row];
}

- (NSString *) getStateAbbreviation: (NSInteger)index {
    if ( !self.states ) [self populateStates];
    NSArray *stateAbbrs = [self sortKeys];    
    return [stateAbbrs objectAtIndex:index];
}

- (NSString *) getStateName: (NSInteger)index {
    if ( !self.states ) [self populateStates];
    NSArray *stateAbbrs = [self sortKeys];    
    return [self.states objectForKey:[stateAbbrs objectAtIndex:index]];
}

- (NSInteger) getStateIndex: (NSString *) stateAbbreviation {
    if ( !self.states ) [self populateStates];
    NSArray *stateAbbrs = [self sortKeys];
    return [stateAbbrs indexOfObject:stateAbbreviation];
}

- (NSArray *) sortKeys {
    //Return a list of State abbreviations, sorted alphabetically by full state name
    NSArray *stateNames = [self.states allValues];
    stateNames = [stateNames sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = (NSString *)a;
        NSString *second = (NSString *)b;
        
        return [first compare:second];
    }];
    
    NSMutableArray *sortedKeys = [[NSMutableArray alloc] init];
    for ( NSString *stateName in stateNames )
        [sortedKeys addObject:[self.states allKeysForObject:stateName][0]];    
    
    return sortedKeys;
}

- (void) populateStates {
    if ( !_states )
        _states = [[NSMutableDictionary alloc] init];
    
    [_states setObject:@"Alabama" forKey:@"AL"];
    [_states setObject:@"Alaska" forKey:@"AK"];
    [_states setObject:@"Arizona" forKey:@"AZ"];
    [_states setObject:@"Arkansas" forKey:@"AR"];
    [_states setObject:@"California" forKey:@"CA"];
    [_states setObject:@"Colorado" forKey:@"CO"];
    [_states setObject:@"Connecticut" forKey:@"CT"];
    [_states setObject:@"Delaware" forKey:@"DE"];
    [_states setObject:@"District of Columbia" forKey:@"DC"];
    [_states setObject:@"Florida" forKey:@"FL"];
    [_states setObject:@"Georgia" forKey:@"GA"];
    [_states setObject:@"Hawaii" forKey:@"HI"];
    [_states setObject:@"Idaho" forKey:@"ID"];
    [_states setObject:@"Illinois" forKey:@"IL"];
    [_states setObject:@"Indiana" forKey:@"IN"];
    [_states setObject:@"Iowa" forKey:@"IA"];
    [_states setObject:@"Kansas" forKey:@"KS"];
    [_states setObject:@"Kentucky" forKey:@"KY"];
    [_states setObject:@"Louisiana" forKey:@"LA"];
    [_states setObject:@"Maine" forKey:@"ME"];
    [_states setObject:@"Maryland" forKey:@"MD"];
    [_states setObject:@"Massachusetts" forKey:@"MA"];
    [_states setObject:@"Michigan" forKey:@"MI"];
    [_states setObject:@"Minnesota" forKey:@"MN"];
    [_states setObject:@"Mississippi" forKey:@"MS"];
    [_states setObject:@"Missouri" forKey:@"MO"];
    [_states setObject:@"Montana" forKey:@"MT"];
    [_states setObject:@"Nebraska" forKey:@"NE"];
    [_states setObject:@"Nevada" forKey:@"NV"];
    [_states setObject:@"New Hampshire" forKey:@"NH"];
    [_states setObject:@"New Jersey" forKey:@"NJ"];
    [_states setObject:@"New Mexico" forKey:@"NM"];
    [_states setObject:@"New York" forKey:@"NY"];
    [_states setObject:@"North Carolina" forKey:@"NC"];
    [_states setObject:@"North Dakota" forKey:@"ND"];
    [_states setObject:@"Ohio" forKey:@"OH"];
    [_states setObject:@"Oklahoma" forKey:@"OK"];
    [_states setObject:@"Oregon" forKey:@"OR"];
    [_states setObject:@"Pennsylvania" forKey:@"PA"];
    [_states setObject:@"Rhode Island" forKey:@"RI"];
    [_states setObject:@"South Carolina" forKey:@"SC"];
    [_states setObject:@"South Dakota" forKey:@"SD"];
    [_states setObject:@"Tennessee" forKey:@"TN"];
    [_states setObject:@"Texas" forKey:@"TX"];
    [_states setObject:@"Utah" forKey:@"UT"];
    [_states setObject:@"Vermont" forKey:@"VT"];
    [_states setObject:@"Virginia" forKey:@"VA"];
    [_states setObject:@"US Virgin Islands" forKey:@"VI"];
    [_states setObject:@"Washington" forKey:@"WA"];
    [_states setObject:@"West Virginia" forKey:@"WV"];
    [_states setObject:@"Wisconsin" forKey:@"WI"];
    [_states setObject:@"Wyoming" forKey:@"WY"];
    [_states setObject:@"American Samoa" forKey:@"AS"];
    [_states setObject:@"Puerto Rico" forKey:@"PR"];
    [_states setObject:@"Guam" forKey:@"GU"];
    [_states setObject:@"Northern Mariana Islands" forKey:@"MP"];
}

@end
