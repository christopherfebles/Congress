//
//  ParentViewController.m
//  Congress
//
//  Created by Christopher Febles on 4/9/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "ParentViewController.h"

@implementation ParentViewController

@synthesize initCount, incomingTransition;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    initCount = 0;
    incomingTransition = NO;
}

- (void) setIncomingTransition:(BOOL)newIncomingTransition {
    incomingTransition = newIncomingTransition;
    initCount = 0;
}

@end
