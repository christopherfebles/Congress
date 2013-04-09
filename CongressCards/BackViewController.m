//
//  BackViewController.m
//  Congress
//
//  Created by Christopher Febles on 4/7/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "BackViewController.h"

@implementation BackViewController

@synthesize tempWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ( self.view )
        NSLog(@"BackViewController Self.View Loaded.");
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if ( window && !self.view.superview )
        [window addSubview:self.view];
    
    //Fill the whole view
    self.tempWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    self.tempWebView.backgroundColor = [UIColor whiteColor];
    
    [self.tempWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/"]]];
    
    [self.view addSubview:tempWebView];
    [self.view bringSubviewToFront:tempWebView];
    
    NSLog(@"BackViewController Object Loaded.");
}

//This method does not appear to be called. Perhaps because no UIView is actually loaded?
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"BackViewController View Appeared.");
}

@end
