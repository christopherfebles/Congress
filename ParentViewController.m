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

- (NSString *) getMemberTitle: (Member *) member {
    NSString *retVal = nil;
    if ( [member senator] )
        retVal = @"Senator";
    else if ( ![member senator] && ![[member state] isEqualToString:@"AS"] && ![[member state] isEqualToString:@"DC"] && ![[member state] isEqualToString:@"GU"] &&
             ![[member state] isEqualToString:@"PR"] && ![[member state] isEqualToString:@"VI"] && ![[member state] isEqualToString:@"MP"])
        retVal = @"Representative";
    else if ( [[member state] isEqualToString:@"PR"] )
        retVal = @"Resident Commissioner";
    else
        retVal = @"Delegate";
    return retVal;
}

- (NSString *) getStateSealImgFilename: (NSString *) state {
    NSMutableString *filename = [[NSMutableString alloc] initWithString:state];
    [filename appendString:@".png"];
    UIImage *seal = [UIImage imageNamed:filename];
    if ( !seal ) {
        filename = [[NSMutableString alloc] initWithString:[filename stringByDeletingPathExtension]];
        [filename appendString:@".gif"];
        seal = [UIImage imageNamed:filename];
        if ( !seal )
            return @"";
    }
    return filename;
}

@end
