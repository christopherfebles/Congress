//
//  BackViewController.m
//  Congress
//
//  Created by Christopher Febles on 4/7/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "BackViewController.h"
#import "HelloWorldAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation BackViewController {
    CATransition *animation;
}

@synthesize member, mainController, tapRecognizer, backWebView, swipeLeftRecognizer, swipeRightRecognizer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if ( window && !self.view.superview )
        [window addSubview:self.view];
    if ( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
        //Load default view
        [self setupMainView];
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
        if ( self.backWebView == nil ) [self setupBackView];
        [self.backWebView removeFromSuperview];
        [self.view addSubview:backWebView];
        [self addBorderToView: self.view withMember: member];
    }
    initCount++;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void) setupMainView {
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    //Gesture Recognizers
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    self.tapRecognizer.delegate = self;
    self.tapRecognizer.cancelsTouchesInView = NO;
    //Swipe
    self.swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    self.swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    self.swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
}

- (NSString *) getLongPartyName: (NSString *) party {
    NSString *retVal;
    
    if ( [party isEqualToString:@"D"] )
        retVal = @"Democratic Party";
    else if ( [party isEqualToString:@"R"] )
        retVal = @"Republican Party";
    else if ( [party isEqualToString:@"I"] )
        retVal = @"Independent";        
    
    return retVal;
}

-(void) setupBackView {
     
    int x = -5;
    int y = -5;
    int width = self.view.bounds.size.width;
    int height = self.view.bounds.size.height;        
    
    if ( !self.backWebView ) {
        self.backWebView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        self.backWebView.backgroundColor = [UIColor clearColor];
        self.backWebView.opaque = NO;
        self.backWebView.scrollView.scrollEnabled = NO;
        self.backWebView.scrollView.bounces = NO;
        self.backWebView.delegate = self;
    //    self.backWebView.scalesPageToFit = YES;
        [self.backWebView addGestureRecognizer:self.tapRecognizer];
        [self.backWebView addGestureRecognizer:self.swipeLeftRecognizer];
        [self.backWebView addGestureRecognizer:self.swipeRightRecognizer];
    }
    
    //Setup display using HTML/CSS
    NSString *title = [self getMemberTitle:member];
    NSString *state = [[[StatePickerViewDelegate alloc] init].states valueForKey:[member state]];
    NSMutableString *htmlString = [[NSMutableString alloc] initWithString:@""];
    
    [htmlString appendString:@"<div style=\"width: 200px; margin: auto; float: left; text-align: center; position: absolute; top: 6px; left: -19px;\" >"];
    [htmlString appendString:@" <img src=\""];
    [htmlString appendString:[member thumbnailFileName]];
    [htmlString appendString:@"\">\n"];
    [htmlString appendString:@" <img src=\""];
    [htmlString appendString:[self getStateSealImgFilename:[member state]]];
    [htmlString appendString:@"\" style=\"width: 115px\">\n"];
    [htmlString appendString:@"</div>\n"];
    [htmlString appendString:@"<div id=\"titleDiv\" style=\"text-align: center; color: white; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; line-height: 115%; float: left; position: absolute; left: 225px; top: 6px;\">\n"];
    [htmlString appendString:@" <div style=\"font-variant:small-caps;\">"];
    [htmlString appendString:title];
    [htmlString appendString:@"</div>\n"];
    [htmlString appendString:@"	<div style=\"font-variant:small-caps; font-size: xx-large;\">"];
    [htmlString appendString:[member first_name]];
    [htmlString appendString:@"&nbsp;"];
    [htmlString appendString:[member last_name]];
    [htmlString appendString:@"</div>\n"];
    [htmlString appendString:@"	<div style=\"font-variant:small-caps;\">"];
    [htmlString appendString:@"	<span style=\"color: "];
    [htmlString appendString:[self getPartyColorAsString:[member party]]];
    [htmlString appendString:@";\">"];
    [htmlString appendString:[self getLongPartyName:[member party]]];
    [htmlString appendString:@"	</span>"];
    [htmlString appendString:@"&nbsp;-&nbsp;"];
    [htmlString appendString:state];
    [htmlString appendString:@"</div>\n"];
    
    //Add Leadership position, if available
    if ( [member leadershipPosition] ) {
        [htmlString appendString:@"	<div style=\"font-family:'Snell Roundhand'; font-size: medium;\">"];
        [htmlString appendString:[member leadershipPosition]];
        [htmlString appendString:@"</div>\n"];
    } else {
        //If no leadership position, check committee leadership
        if ( [[member committees] count] > 0 ) {
//            Committee *displayCommittee = nil;
//            NSString * committeeHTML = @"   <div style=\"font-family:'Snell Roundhand'; font-size: medium;\">";
            //Get highest ranked position (Assuming each Member can only chair one committee)
//            for ( Committee *committee in [member committees] ) {
//                if ( [[committee position] isEqualToString:@"Ranking Member"] ||
//                    [[committee position] isEqualToString:@"Chairman"]) {
//                    displayCommittee = committee;
//                    break;
//                } else if ( [[committee position] isEqualToString:@"Vice Chairman"] )
//                    displayCommittee = committee;
//            }
//            if ( displayCommittee ) {
//                [htmlString appendString:committeeHTML];
//                [htmlString appendString:@"Committee "];
//                [htmlString appendString:[displayCommittee position]];
//                [htmlString appendString:@"</div>\n"];
//            }
        }
    }
    
    [htmlString appendString:@"</div>\n"];
    [htmlString appendString:@"<div>\n"];
    [htmlString appendString:@" <div style=\"float:left; position: absolute; left: 160px; top: 77px; width: 145px;\">\n"];
    [htmlString appendString:@"     <ul style=\"list-style-type: none; margin: 0; padding: 0; font-size: x-small;\">"];
    [htmlString appendString:@"         <li style=\"font-size: x-small;\">\n"];
    [htmlString appendString:[member address]];
    [htmlString appendString:@"         </li>\n"];
    [htmlString appendString:@"         <li>\n"];
    [htmlString appendString:[member phone]];
    [htmlString appendString:@"         </li>\n"];
    
    if ( [member contact_form] ) {
        [htmlString appendString:@"         <li>\n"];
        [htmlString appendString:@"             <a href=\""];
        [htmlString appendString:[member contact_form]];
        [htmlString appendString:@"\">Contact Online</a>\n"];
        [htmlString appendString:@"         </li>\n"];
    } else {
        [htmlString appendString:@"         <li>&nbsp;</li>\n"];        
    }
    
    if ( [member website] ) {
        [htmlString appendString:@"         <li>\n"];
        [htmlString appendString:@"				<a href=\""];
        [htmlString appendString:[member website]];
        [htmlString appendString:@"\">Official Website</a>"];
        [htmlString appendString:@"         </li>\n"];
    } else {
        [htmlString appendString:@"         <li>&nbsp;</li>\n"];
    }
    
    [htmlString appendString:@"     </ul>\n"];
    [htmlString appendString:@" </div>\n"];
    [htmlString appendString:@" <div style=\"float: right; position: absolute; left: 360px; top: 77px;\">\n"];
    [htmlString appendString:@"     <ul style=\"list-style-type: none; margin: 0; padding: 0; font-size: x-small;\">"];
    
//    if ( [member hometown] ) {
//        [htmlString appendString:@"         <li style=\"font-size: x-small;\">\n"];
//        [htmlString appendString:@"				Hometown:&nbsp;"];
//        [htmlString appendString:[member hometown]];
//        [htmlString appendString:@",&nbsp;"];
//        [htmlString appendString:[member state]];
//        [htmlString appendString:@"         </li>\n"];
//    } else {
        [htmlString appendString:@"         <li>&nbsp;</li>\n"];
//    }
    
    if ( [member bioguide_id] ) {
        [htmlString appendString:@"         <li>\n"];
        [htmlString appendString:@"				<a href=\"http://bioguide.congress.gov/scripts/biodisplay.pl?index="];
        [htmlString appendString:[member bioguide_id]];
        [htmlString appendString:@"\">Congressional Biography</a>"];
        [htmlString appendString:@"         </li>\n"];
    } else {
        [htmlString appendString:@"         <li>&nbsp;</li>\n"];
    }
    
    
    [htmlString appendString:@"         <li>&nbsp;</li>\n"];
    [htmlString appendString:@"         <li>&nbsp;</li>\n"];
    [htmlString appendString:@"     </ul>\n"];
    [htmlString appendString:@" </div>\n"];
    [htmlString appendString:@"</div>\n"];
//    if ( [member committees] != nil && [[member committees] count] > 0 ) {
//        
//        NSArray *sortedArray;
//        sortedArray = [[member committees] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//            NSString *first = [(Committee*)a position];
//            NSString *second = [(Committee*)b position];
//            NSComparisonResult retVal = [[(Committee*)a name] compare:[(Committee*)b name]];
//            
//            if ( [first isEqualToString:@"Chairman"] && ![second isEqualToString:@"Chairman"])
//                retVal = NSOrderedAscending;
//            else if ( [first isEqualToString:@"Chairman"] && [second isEqualToString:@"Chairman"])
//                retVal = NSOrderedSame;
//            else if ( [second isEqualToString:@"Chairman"] && ![first isEqualToString:@"Chairman"])
//                retVal = NSOrderedDescending;
//            else if ( [first isEqualToString:@"Vice Chairman"] && ![second isEqualToString:@"Vice Chairman"])
//                retVal = NSOrderedAscending;
//            else if ( [first isEqualToString:@"Vice Chairman"] && [second isEqualToString:@"Vice Chairman"])
//                retVal = NSOrderedSame;
//            else if ( [second isEqualToString:@"Vice Chairman"] && ![first isEqualToString:@"Vice Chairman"])
//                retVal = NSOrderedDescending;
//            else if ( [first isEqualToString:@"Ranking Member"] && ![second isEqualToString:@"Ranking Member"])
//                retVal = NSOrderedAscending;
//            else if ( [first isEqualToString:@"Ranking Member"] && [second isEqualToString:@"Ranking Member"])
//                retVal = NSOrderedSame;
//            else if ( [second isEqualToString:@"Ranking Member"] && ![first isEqualToString:@"Ranking Member"])
//                retVal = NSOrderedDescending;
//            
//            return retVal;
//        }];

//        
//        [htmlString appendString:@"<div>\n"];
//        [htmlString appendString:@" <div style=\"float:left; width: 95px; font-size: small; position: absolute; left: 160px; top: 130px;\">\n"];
//        [htmlString appendString:@"     <h3>Rank</h3>\n"];
//        [htmlString appendString:@"     <ul style=\"list-style-type: none; margin: 0; padding: 0;\">"];
////        for ( Committee *committee in sortedArray ) {
////            [htmlString appendString:@"         <li>\n"];
////            [htmlString appendString:[committee position]];
////            [htmlString appendString:@"         </li>\n"];
////        }
//        [htmlString appendString:@"     </ul>\n"];
//        [htmlString appendString:@" </div>\n"];
//        [htmlString appendString:@" <div style=\"float:left; width: 50%; font-size: small; position: absolute; left: 260px; top: 130px;\">\n"];
//        [htmlString appendString:@"     <h3>Committee</h3>\n"];
//        [htmlString appendString:@"     <ul style=\"list-style-type: none; margin: 0; padding: 0;\">"];
////        for ( Committee *committee in sortedArray ) {
////            [htmlString appendString:@"         <li>\n"];
////            if ( ![[committee website] isEqualToString:@""] || [committee link] ) {
////                [htmlString appendString:@"             <a href=\""];
////                if ( [committee link] )
////                    [htmlString appendString:[committee link]];
////                else
////                    [htmlString appendString:[committee website]];
////                [htmlString appendString:@"\">"];
////                [htmlString appendString:[committee name]];
////                [htmlString appendString:@"</a>\n"];
////            } else
////                [htmlString appendString:[committee name]];
////            [htmlString appendString:@"         </li>\n"];
////        }
//        [htmlString appendString:@"     </ul>\n"];
//        [htmlString appendString:@" </div>\n"];
//        [htmlString appendString:@"</div>\n"];
//    }
    
//    NSLog(@"%@", htmlString);
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    if ( animation ) {
        [backWebView.layer addAnimation:animation forKey:kCATransition];
        animation = nil;
    }
    
    [backWebView loadHTMLString:htmlString baseURL:baseURL];
}

- (void) handleTap {
    //Switch back to main view
    HelloWorldAppDelegate *appDelegate = (HelloWorldAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Reset position
    self.mainController.position = self.position;
    [appDelegate transitionToViewController:self.mainController
                             withTransition:UIViewAnimationOptionTransitionFlipFromRight];
}

- (IBAction)rightSwipe:(id)sender {
    [super rightSwipe:sender];
    member = photos[position];
    animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self setupBackView];
}

- (IBAction)leftSwipe:(id)sender {
    [super leftSwipe:sender];
    member = photos[position];
    animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self setupBackView];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    BOOL retVal = YES;

    //Check if a link was clicked. If so, do not rotate view.
    NSString *js = @"function f(){ var a = document.getElementsByTagName('a'); var retVal = new Array(); for (var idx= 0; idx < a.length; ++idx){ var r = a[idx].getBoundingClientRect(); retVal[idx] = '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } return retVal.join(';'); } f();";
    NSString *result = [self.backWebView stringByEvaluatingJavaScriptFromString:js];

    NSArray *linkArray = [result componentsSeparatedByString:@";"];
    CGPoint touchPoint = [touch locationInView:self.backWebView];
    for ( NSString *linkRectStr in linkArray ) {
        CGRect rect = CGRectFromString(linkRectStr);
        if ( CGRectContainsPoint( rect, touchPoint ) ) {
//            NSLog(@"Link Clicked");
            retVal = NO;
            break;
        }
    }
    
    return retVal;
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    //Open clicked links in Safari
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
