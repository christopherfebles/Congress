//
//  HelloWorldViewController.h
//  CongressCards
//
//  Created by Christopher Febles on 1/31/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "StatePickerViewDelegate.h"

@interface HelloWorldViewController : UIViewController <UIGestureRecognizerDelegate, UIPickerViewDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    
    StatePickerViewDelegate *statePickerDelegate;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) StatePickerViewDelegate *statePickerDelegate;

- (void)updateImage: (bool)rightAnimation;
- (void)setupData;

+ (UIImage *) houseLogo;
+ (UIImage *) senateLogo;

@end
