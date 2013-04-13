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

@synthesize member, mainController, tapRecognizer, backWebView;

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
}

-(void) setupBackView {
     
    int x = -5;
    int y = -5;
    int width = self.view.bounds.size.width;
    int height = self.view.bounds.size.height;
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    self.tapRecognizer.delegate = self;
    self.tapRecognizer.cancelsTouchesInView = NO;
    
    self.backWebView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.backWebView.backgroundColor = [UIColor clearColor];
    self.backWebView.opaque = NO;
    self.backWebView.scrollView.scrollEnabled = NO;
    self.backWebView.scrollView.bounces = NO;
    self.backWebView.delegate = self;
    [self.backWebView addGestureRecognizer:self.tapRecognizer];
    
    //Setup display using HTML/CSS
    NSMutableString *htmlString = [[NSMutableString alloc] initWithString:@""];
    
    [htmlString appendString:@"<table style=\"margin: auto; width: 100%;\">"];
    [htmlString appendString:@"	<tr>"];
    [htmlString appendString:@"		<td rowspan=\"2\" style=\"text-align: center;\">"];
    [htmlString appendString:@"		<img src=\"Senate_VT_1_I_thumb.jpg\">"];
    [htmlString appendString:@"		</td>"];
    [htmlString appendString:@"		<td style=\"border: 1px solid black; padding-left: 10px; padding-right: 10px; \">"];
    [htmlString appendString:@"			<span id=\"titleDiv\" style=\"text-align: center; color: white; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; line-height: 150%;\">"];
    [htmlString appendString:@"				<div style=\"font-variant:small-caps;\">Senator</div>"];
    [htmlString appendString:@"				<div style=\"font-variant:small-caps; font-size: xx-large;\">Bernie Sanders</div>"];
    [htmlString appendString:@"				<div style=\"font-variant:small-caps;\">Vermont - I</div>"];
    [htmlString appendString:@"				<div style=\"font-family:'Snell Roundhand'; font-size: x-large;\">Majority Leader</div>"];
    [htmlString appendString:@"			</span>"];
    [htmlString appendString:@"		</td>"];
    [htmlString appendString:@"	</tr>"];
    [htmlString appendString:@"	<tr>"];
    [htmlString appendString:@"		<td style=\"border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;\">"];
    [htmlString appendString:@"			<table style=\"margin: auto; width: 100%; line-height: 90%;\">"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\">Address</td>"];
    [htmlString appendString:@"					<td style=\"text-align: right\">Hometown, VT</td>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\">Phone</td>"];
    [htmlString appendString:@"					<td style=\"text-align: right\"><a href=\"http://www.google.com/\">BioGuide Link</a></td>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\"><a href=\"http://www.google.com/\">Email</a></td>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\"><a href=\"http://www.google.com/\">Website</a></td>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"			</table>"];
    [htmlString appendString:@"		</td>"];
    [htmlString appendString:@"	</tr>"];
    [htmlString appendString:@"	<tr>"];
    [htmlString appendString:@"		<td style=\"text-align: center;\">"];
    [htmlString appendString:@"		<img src=\"VT.png\" style=\"width: 115px\">"];
    [htmlString appendString:@"		</td>"];
    [htmlString appendString:@"		<td>"];
    [htmlString appendString:@"			<table style=\"margin: auto; width: 100%;\">"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<th>Rank</th>"];
    [htmlString appendString:@"					<th>Committee</th>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\">Member</td>"];
    [htmlString appendString:@"					<td style=\"text-align: left\"><a href=\"http://www.google.com/\">Committee</a></td>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\">Member</td>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\"><a href=\"http://www.google.com/\">Committee</a></td>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"				<tr>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\">Member</td>"];
    [htmlString appendString:@"					<td style=\"text-align: left;\"><a href=\"http://www.google.com/\">Committee</a></td>"];
    [htmlString appendString:@"				</tr>"];
    [htmlString appendString:@"			</table>"];
    [htmlString appendString:@"		</td>"];
    [htmlString appendString:@"	</tr>"];
    [htmlString appendString:@"</table>"];
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [backWebView loadHTMLString:htmlString baseURL:baseURL];
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
            NSLog(@"Link Clicked");
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
