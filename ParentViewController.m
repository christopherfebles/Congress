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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self preferredStatusBarStyle];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle]];
    }
    
    self.initCount = 0;
    self.incomingTransition = NO;
}

- (void) setIncomingTransition:(BOOL)newIncomingTransition {
    _incomingTransition = newIncomingTransition;
    self.initCount = 0;
}

- (void)addBorderToView: (UIView *) view
             withMember: (Member *) member
{
    view.layer.borderColor = [self getPartyColor:member.party].CGColor;
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

- (NSString *) getPartyColorAsString: (NSString *) party {
    NSString *retVal = nil;
    if ( [party isEqualToString:@"R"] ) {
        retVal = @"red";
    } else if ( [party isEqualToString:@"D"] ) {
        retVal = @"blue";
    } else if ( [party isEqualToString:@"I"] ) {
        retVal = @"white";
    }
    return retVal;
}

- (NSString *) getStateSealImgFilename: (NSString *) state {
    NSMutableString *filename = [[NSMutableString alloc] initWithString:state];
    
    if ( [state isEqualToString:@"VI"] ) {
        [filename appendString:@".gif"];
    } else {
        [filename appendString:@".png"];
    }
    return filename;
}

- (IBAction)rightSwipe:(id)sender {
    //Go back to previous image
    self.position--;
    if ( self.position < 0 )
        self.position = [self.photos count]-1;
}

- (IBAction)leftSwipe:(id)sender {
    //Go forward to next image
    self.position++;
    if ( self.position > ([self.photos count]-1) )
        self.position = 0;
}

@end
