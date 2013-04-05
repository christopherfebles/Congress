//
//  HelloWorldViewController.h
//  CongressCards
//
//  Created by Christopher Febles on 1/31/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HelloWorldViewController : UIViewController <UIGestureRecognizerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)updateImage: (bool)rightAnimation;
- (void)setupData;
- (void)addBorder;

+ (UIImage *) houseLogo;
+ (UIImage *) senateLogo;

@end
