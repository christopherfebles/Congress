//
//  ParentViewController.m
//  Congress
//
//  Created by Christopher Febles on 4/9/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "ParentViewController.h"
#import "Member.h"
#import <QuartzCore/QuartzCore.h>

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

- (void)addBorderToView: (UIView *) view
             withMember: (Member *) member
{
    view.layer.borderColor = [self getPartyColor:[member party]].CGColor;
    view.layer.borderWidth = 5;
}

- (UIColor *) getPartyColor: (NSString *) party {
    UIColor *retVal = nil;
    if ( [party isEqualToString:@"R"] ) {
        retVal = [UIColor redColor];
    } else if ( [party isEqualToString:@"D"] ) {
        retVal = [UIColor blueColor];
    } else if ( [party isEqualToString:@"I"] ) {
        retVal = [UIColor whiteColor];
    }
    return retVal;
}

@end
