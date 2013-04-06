//
//  StatePickerViewDelegate.h
//  CongressCards
//
//  Created by Christopher Febles on 4/6/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatePickerViewDelegate : NSObject <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSMutableDictionary *states;
}

@property (strong, nonatomic) NSMutableDictionary *states;

- (NSString *) getAbbr: (NSInteger)index;
- (NSString *) getState: (NSInteger)index;
- (NSInteger) getIndex: (NSString *) stateAbbr;

@end
