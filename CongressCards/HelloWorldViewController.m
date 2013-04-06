//
//  HelloWorldViewController.m
//  CongressCards
//
//  Created by Christopher Febles on 1/31/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import "HelloWorldViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataManager.h"
#import "Member.h"

@interface HelloWorldViewController () {
    NSArray *photos;
    int position;
    int lastSenatePosition;
    int lastHousePosition;
    NSArray *senators;
    NSArray *representatives;
    BOOL viewingSenate;
    
    //Dynamically added views
    UIWebView *nameWebView;
    UIImageView *logoView;
    UIImageView *sealView;
}
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightRecognizer;

@end

@implementation HelloWorldViewController

@synthesize fetchedResultsController, managedObjectContext;

- (IBAction)rightSwipe:(id)sender {
    //Go back to previous image
    position--;
    if ( position < 0 )
        position = [photos count]-1;
    
    [self updateImage:NO];
}

- (IBAction)leftSwipe:(id)sender {
    //Go forward to next image
    position++;
    if ( position > ([photos count]-1) )
        position = 0;
    
    [self updateImage:YES];
}

- (void)updateImage: (bool)rightAnimation
{
    Member *member = photos[position];
    
    NSString *animationSubType = kCATransitionFromLeft;
    if ( rightAnimation )
        animationSubType = kCATransitionFromRight;
    
    UIImage *picture = [UIImage imageNamed:[member photoFileName]];
    [self setImage:picture withAnimationSubType: animationSubType];
    
    [self addBorderToView: self.view withMember: member];
    [self addLogo:[member senator]];
    [self addStateSeal:member];
    
    //Add UIWebView instead of a UITextView
    [self addMemberName: member];
}

- (void) addMemberName: (Member *) member {
    int x = 0;
    int y = [UIScreen mainScreen].bounds.size.height - 75;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if ( nameWebView != nil )
        [nameWebView removeFromSuperview];
    nameWebView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    
    NSMutableString *htmlString =
        [[NSMutableString alloc] initWithString:@"<span style=\"color: white; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;\"><span style=\"font-variant:small-caps;\">"];
    if ( [member senator] )
        [htmlString appendString:@"Senator"];
    else if ( ![member senator] && ![[member state] isEqualToString:@"AS"] && ![[member state] isEqualToString:@"DC"] && ![[member state] isEqualToString:@"GU"] &&
             ![[member state] isEqualToString:@"PR"] && ![[member state] isEqualToString:@"VI"] && ![[member state] isEqualToString:@"MP"])
        [htmlString appendString:@"Representative"];
    else if ( [[member state] isEqualToString:@"PR"] )
        [htmlString appendString:@"Resident Commissioner"];
    else
        [htmlString appendString:@"Delegate"];
    
    [htmlString appendString:@"&nbsp;"];
    [htmlString appendString:[member firstName]];
    [htmlString appendString:@"</span>&nbsp;<span style=\"font-variant:small-caps; font-size: xx-large;\">"];
    [htmlString appendString:[member lastName]];
    [htmlString appendString:@"</span></span>"];

    [nameWebView loadHTMLString:htmlString baseURL:nil];
    nameWebView.opaque = NO;
    nameWebView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:nameWebView];
    [self.view bringSubviewToFront:nameWebView];
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

//For animation, see http://goo.gl/DkA1W
- (void)setImage:(UIImage *)image
    withAnimationSubType:(NSString *) animationSubType
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionMoveIn;
    animation.subtype = animationSubType;
    [self.currentImage.layer addAnimation:animation forKey:@"imageTransition"];
    self.currentImage.image = image;

    int x = 20;
    int y = -10;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    self.currentImage.frame = CGRectMake(x, y, width, height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
//    [self.view addSubview:self.textView];
//    [self.view bringSubviewToFront:self.textView];
    
    [self setupData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateImage:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Load the XML and setup the data to display
- (void)setupData
{
    position = 0;
    lastHousePosition = 0;
    lastSenatePosition = 0;
    
    NSMutableArray *photoList = [[NSMutableArray alloc] init];
    
    senators = [DataManager loadSenatorsFromXML];
    representatives = [DataManager loadRepresentativesFromXML];
    [photoList addObjectsFromArray:senators];
    
    photos = photoList;
    viewingSenate = YES;
}

- (void) addLogo: (BOOL) senate {
    UIImage *logo;
    if ( senate )
        logo = [HelloWorldViewController senateLogo];
    else
        logo = [HelloWorldViewController houseLogo];
    
    if ( logoView != nil )
        [logoView removeFromSuperview];
    
    logoView = [[UIImageView alloc] initWithImage:logo];
    [logoView setContentMode:UIViewContentModeScaleAspectFit];
    
    int x = 5;
    int y = -15;
    int width = [UIScreen mainScreen].bounds.size.width / 4;
    int height = [UIScreen mainScreen].bounds.size.height / 4;
    
    logoView.frame = CGRectMake(x, y, width, height);
    
    logoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchChamber:)];
    [logoView addGestureRecognizer:tap];
    
    [self.view addSubview:logoView];
    [self.view bringSubviewToFront:logoView];
}

- (void) addStateSeal: (Member *) member {
    NSMutableString *filename = [[NSMutableString alloc] initWithString:[member state]];
    [filename appendString:@".png"];
    UIImage *seal = [UIImage imageNamed:filename];
    if ( !seal ) {
        filename = [[NSMutableString alloc] initWithString:[filename stringByDeletingPathExtension]];
        [filename appendString:@".gif"];
        seal = [UIImage imageNamed:filename];
        if ( !seal )
            return;
    }
    
    if ( sealView != nil )
        [sealView removeFromSuperview];
    sealView = [[UIImageView alloc] initWithImage:seal];
    [sealView setContentMode:UIViewContentModeScaleAspectFit];
    
    int x = [UIScreen mainScreen].bounds.size.width - 85;
    int y = [UIScreen mainScreen].bounds.size.height - 155;
    int width = [UIScreen mainScreen].bounds.size.width / 4;
    int height = [UIScreen mainScreen].bounds.size.height / 4;
    
    sealView.frame = CGRectMake(x, y, width, height);
    
//    sealView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchChamber:)];
//    [sealView addGestureRecognizer:tap];
    
    NSMutableString *labelText = [[NSMutableString alloc] initWithString:[member state]];
    if ( ![member senator] ) {
        [labelText appendString:@" - "];
        NSString *district = [member classDistrict];
        if ( [district isEqualToString:@"At Large"] )
            district = @"AL";
        [labelText appendString:district];
    }
    
    UILabel *sealLabel = [[UILabel alloc] initWithFrame:[sealView frame]];
//    sealLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    sealLabel.opaque = NO;
    sealLabel.backgroundColor = [UIColor clearColor];
    sealLabel.font = [UIFont boldSystemFontOfSize:18];
    sealLabel.textColor = [self getPartyColor:[member party]];
    sealLabel.shadowColor = [UIColor blackColor];
    sealLabel.shadowOffset = CGSizeMake(0, -3.0);
    sealLabel.text = labelText;
    sealLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:sealView];
    [self.view addSubview:sealLabel];
    [self.view bringSubviewToFront:sealView];
    [self.view bringSubviewToFront:sealLabel];
    
}

- (IBAction) switchChamber: (UIGestureRecognizer *) sender  {
    //Switch between House and Senate views
    NSMutableArray *photoList = [[NSMutableArray alloc] init];
    if ( viewingSenate ) {
        //Switch to House
        viewingSenate = NO;
        [photoList addObjectsFromArray:representatives];
        lastSenatePosition = position;
        position = lastHousePosition;
    } else {
        //Switch to Senate
        viewingSenate = YES;
        [photoList addObjectsFromArray:senators];
        lastHousePosition = position;
        position = lastSenatePosition;
    }
    
    photos = photoList;
    [self updateImage:YES];
}

+ (UIImage *) houseLogo {
    static UIImage *houseImage = nil;
    if (!houseImage) {
        houseImage = [UIImage imageNamed:@"house_logo.png"];
    }
    return houseImage;
}
+ (UIImage *) senateLogo {
    static UIImage *senateImage = nil;
    if (!senateImage) {
        senateImage = [UIImage imageNamed:@"senate_logo.png"];
    }
    return senateImage;

}

@end
