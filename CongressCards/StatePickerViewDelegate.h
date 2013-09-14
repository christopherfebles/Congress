//
//  StatePickerViewDelegate.h
//  Congress
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatePickerViewDelegate : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *states;

- (NSString *) getStateAbbreviation: (NSInteger)index;
- (NSString *) getStateName: (NSInteger)index;
- (NSInteger) getStateIndex: (NSString *) stateAbbreviation;

@end
