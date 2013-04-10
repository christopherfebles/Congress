//
//  ParentViewController.h
//  Congress
//
//  Created by Christopher Febles on 4/9/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController {
    BOOL incomingTransition;
    int initCount;
}

@property (nonatomic, assign) BOOL incomingTransition;
@property (nonatomic, assign) int initCount;

@end
