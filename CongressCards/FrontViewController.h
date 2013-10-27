//
//  FrontViewController.h
//  Congress
//
//  Created by Christopher Febles on 1/31/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "StatePickerViewDelegate.h"
#import "ParentViewController.h"

@interface FrontViewController : ParentViewController <UIGestureRecognizerDelegate, UIPickerViewDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) StatePickerViewDelegate *statePickerDelegate;

- (void)updateImage: (bool)rightAnimation;
- (void)setupData;

+ (UIImage *) houseLogo;
+ (UIImage *) senateLogo;

@end
