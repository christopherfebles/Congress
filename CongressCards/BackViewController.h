//
//  BackViewController.h
//  Congress
//
//  Created by Christopher Febles on 4/7/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"
#import "HelloWorldViewController.h"
#import "ParentViewController.h"

@interface BackViewController : ParentViewController {
    Member *member;
    UIImageView *imageView;
    HelloWorldViewController *mainController;
}

@property (nonatomic, strong) Member *member;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HelloWorldViewController *mainController;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end
