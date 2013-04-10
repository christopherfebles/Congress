//
//  BackViewController.m
//  Congress
//
//  Created by Christopher Febles on 4/7/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "BackViewController.h"
#import "HelloWorldAppDelegate.h"

@implementation BackViewController

@synthesize member, imageView, mainController, tapRecognizer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if ( window && !self.view.superview )
        [window addSubview:self.view];
    
    if ( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
        //Load default view
        [self setupView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSLog(@"Adding views to main view.");
    //Add subviews to main view here
    //Because this method is called twice, (Once initially, and once after rotation)
    //  it's safer to remove the views from their superview before re-adding them
    if ( initCount > 0 ) {
        [self.imageView removeFromSuperview];
        [self.view addSubview:self.imageView];
    }
    initCount++;
}

-(void)setupView {
//    NSLog(@"Setting up the UIViews.");
    [self setupMainView];
    [self setupImageView];
}

-(void) setupMainView {
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void) setupImageView {
    
    //Add image view
    UIImage *thumbImg = [UIImage imageNamed:[member thumbnailFileName]];
    
    int x = 0;
    int y = 0;
    int width = thumbImg.size.width;
    int height = thumbImg.size.height;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.imageView.image = thumbImg;
}

- (void) handleTap {
    //Switch back to main view
    HelloWorldAppDelegate *appDelegate = (HelloWorldAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate transitionToViewController:self.mainController
                             withTransition:UIViewAnimationOptionTransitionFlipFromRight];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
