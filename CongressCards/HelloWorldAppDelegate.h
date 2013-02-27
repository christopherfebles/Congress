//
//  HelloWorldAppDelegate.h
//  CongressCards
//
//  Created by Christopher Febles on 1/31/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HelloWorldAppDelegate : UIResponder <UIApplicationDelegate> {

NSManagedObjectModel *managedObjectModel;
NSManagedObjectContext *managedObjectContext;
NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end
