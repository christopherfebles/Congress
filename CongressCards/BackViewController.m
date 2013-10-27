//
//  BackViewController.m
//  Congress
//
//  Created by Christopher Febles on 4/7/13.
//  Copyright (c) 2013 Christopher Febles. All rights reserved.
//

#import "BackViewController.h"
#import "CongressAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Committee.h"

@implementation BackViewController {
    CATransition *animation;
}

@synthesize member, mainController, tapRecognizer, backWebView, swipeLeftRecognizer, swipeRightRecognizer;

#pragma mark -
#pragma mark Initialization

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
    int y = 10; //Originally -5
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
    NSString *backViewPath = [[NSBundle mainBundle] pathForResource:@"backView" ofType:@"html"];
    NSMutableString *htmlString = [[NSMutableString alloc] initWithContentsOfFile:backViewPath encoding:NSUTF8StringEncoding error:nil];
    
    //Replace variables
    NSString *title = member.fullTitle;
    NSString *state = [[[StatePickerViewDelegate alloc] init].states valueForKey:member.state];
    NSString *stateSealImgFileName = [self getStateSealImgFilename:member.state];
    NSString *partyColorString = [self getPartyColorAsString:member.party];
    NSString *partyLongName = [self getLongPartyName:member.party];
    [htmlString replaceOccurrencesOfString:@"${thumbnailFileName}" withString:member.thumbnailFileName options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${stateSealImgFilename}" withString:stateSealImgFileName options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${title}" withString:title options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${firstName}" withString:member.firstName options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${lastName}" withString:member.lastName options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${partyColor}" withString:partyColorString options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${longPartyName}" withString:partyLongName options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${state}" withString:state options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${office}" withString:member.office options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${phone}" withString:member.phone options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${contactForm}" withString:member.contactForm options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${website}" withString:member.website options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${bioguideId}" withString:member.bioguideId options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    
    //Social Media
    NSMutableString *facebook = [[NSMutableString alloc] initWithString:@"&nbsp;"];
    NSMutableString *twitter = [[NSMutableString alloc] initWithString:@"&nbsp;"];
    if ( member.facebookId ) {
        NSString *facebookLogoPath = @"facebook_icon.png"; //[[NSBundle mainBundle] pathForResource:@"facebook_icon" ofType:@"png"];
        facebook = [[NSMutableString alloc] initWithString:@""];
        [facebook appendString:@"<a href=\""];
        [facebook appendString:@"http://www.facebook.com/"];
        [facebook appendString:member.facebookId];
        [facebook appendString:@"\">"];
        //[facebook appendString:@"Facebook"];
        [facebook appendString:@"<img style=\"width:50px; height:50px\" src=\""];
        [facebook appendString:facebookLogoPath];
        [facebook appendString:@"\" />"];
        [facebook appendString:@"</a>"];
    }
    if ( member.twitterId ) {
        NSString *twitterLogoPath = @"twitter_icon.png"; //[[NSBundle mainBundle] pathForResource:@"twitter_icon" ofType:@"png"];
        twitter = [[NSMutableString alloc] initWithString:@""];
        [twitter appendString:@"<a href=\""];
        [twitter appendString:@"http://www.twitter.com/"];
        [twitter appendString:member.twitterId];
        [twitter appendString:@"\">"];
        //[twitter appendString:@"Twitter"]; //Replace with img tag
        [twitter appendString:@"<img style=\"width:50px; height:50px\" src=\""];
        [twitter appendString:twitterLogoPath];
        [twitter appendString:@"\" />"];
        [twitter appendString:@"</a>"];
    }
    [htmlString replaceOccurrencesOfString:@"${twitter}" withString:twitter options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    [htmlString replaceOccurrencesOfString:@"${facebook}" withString:facebook options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
    
    //Generate Committee HTML List
    NSMutableString *committeeHtmlString = [[NSMutableString alloc] initWithString:@""];
    for ( Committee *committee in member.committees ) {
        if ( committee.subcommittee ) {
            //Only Display parent committees
            //Not all the committees fit in the display
            continue;
        }
        [committeeHtmlString appendString:@"<li>"];
        if ( committee.url ) {
            [committeeHtmlString appendString:@"<a href=\""];
            [committeeHtmlString appendString:committee.url];
            [committeeHtmlString appendString:@"\">"];
            [committeeHtmlString appendString:committee.name];
            [committeeHtmlString appendString:@"</a>"];
        } else {
            [committeeHtmlString appendString:committee.name];
        }
        [committeeHtmlString appendString:@"</li>\n"];
    }
    
    [htmlString replaceOccurrencesOfString:@"${committeeList}" withString:committeeHtmlString options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];

    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    if ( animation ) {
        [backWebView.layer addAnimation:animation forKey:kCATransition];
        animation = nil;
    }
    
    [backWebView loadHTMLString:htmlString baseURL:baseURL];
}

#pragma mark -
#pragma mark Interface Controls

- (void) handleTap {
    //Switch back to main view
    CongressAppDelegate *appDelegate = (CongressAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Reset position
    self.mainController.position = self.position;
    [appDelegate transitionToViewController:self.mainController
                             withTransition:UIViewAnimationOptionTransitionFlipFromRight];
}

- (IBAction)rightSwipe:(id)sender {
    [super rightSwipe:sender];
    member = self.photos[self.position];
    animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self setupBackView];
}

- (IBAction)leftSwipe:(id)sender {
    [super leftSwipe:sender];
    member = self.photos[self.position];
    animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self setupBackView];
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

#pragma mark -
#pragma mark Default Methods

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    NSLog(@"Adding views to main view.");
    //Add subviews to main view here
    //Because this method is called twice, (Once initially, and once after rotation)
    //  it's safer to remove the views from their superview before re-adding them
    if ( self.initCount > 0 ) {
        if ( self.backWebView == nil ) [self setupBackView];
        [self.backWebView removeFromSuperview];
        [self.view addSubview:backWebView];
        [self addBorderToView: self.view withMember: member];
    }
    self.initCount++;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
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
