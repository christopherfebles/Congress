//
//  ParentViewController.h
//  Congress
//
//  Created by Christopher Febles on 4/9/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface ParentViewController : UIViewController {
    BOOL incomingTransition;
    int initCount;
    int position;
    NSArray *photos;
}

@property (nonatomic, assign) BOOL incomingTransition;
@property (nonatomic, assign) int initCount;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) int position;

- (void)addBorderToView: (UIView *) view
             withMember: (Member *) member;

- (UIColor *) getPartyColor: (NSString *) party;
- (NSString *) getPartyColorAsString: (NSString *) party;
- (IBAction)rightSwipe:(id)sender;
- (IBAction)leftSwipe:(id)sender;
- (NSString *) getMemberTitle: (Member *) member;

- (NSString *) getStateSealImgFilename: (NSString *) state;

@end
