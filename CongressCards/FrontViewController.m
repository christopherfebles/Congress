//
//  FrontViewController.m
//  Congress
//
//  Created by Christopher Febles on 1/31/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import "FrontViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataManager.h"
#import "Member.h"
#import "StatePickerViewDelegate.h"
#import "CongressAppDelegate.h"
#import "BackViewController.h"

@interface FrontViewController () {
    int lastSenatePosition;
    int lastHousePosition;
    NSArray *senators;
    NSArray *representatives;
    BOOL viewingSenate;
    BOOL switchingState;
    
    //Dynamically added views
    UITextView *nameTextView;
    UIWebView *nameWebView;
    UIImageView *logoView;
    UIImageView *sealView;
    UIPickerView *statePickerView;
    UIView *statePickerBackgroundView;
    UIToolbar *pickerToolbar;
    UILabel *sealLabel;
}
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@end

@implementation FrontViewController

#pragma mark -
#pragma mark Interface Controls

- (IBAction)rightSwipe:(id)sender {
    if ( switchingState ) return;
    [super rightSwipe:sender];    
    [self updateImage:NO];
}

- (IBAction)leftSwipe:(id)sender {
    if ( switchingState ) return;
    [super leftSwipe:sender];    
    [self updateImage:YES];
}

- (IBAction)handleTap {
//    NSLog(@"Registered Tap.");
    //Switch to other controller view
    
    BackViewController *vc = [[BackViewController alloc] init];
    vc.member = self.photos[self.position];
    vc.photos = self.photos;
    vc.position = self.position;
    vc.mainController = self;
    
    CongressAppDelegate *appDelegate = (CongressAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate transitionToViewController:vc
                             withTransition:UIViewAnimationOptionTransitionFlipFromRight];
}

#pragma mark -
#pragma mark Image Handling

- (void)updateImage: (bool)rightAnimation
{
    Member *member = self.photos[self.position];
    
    NSString *animationSubType = kCATransitionFromLeft;
    if ( rightAnimation )
        animationSubType = kCATransitionFromRight;
    
    UIImage *picture = [UIImage imageNamed:member.photoFileName];
    [self setImage:picture withAnimationSubType: animationSubType];
    
    [self addBorderToView: self.view withMember: member];
    [self addLogo:member.isSenator];
    [self addStateSeal:member];
    [self addMemberName: member];
}

//For animation, see http://goo.gl/DkA1W
- (void)setImage:(UIImage *)image
withAnimationSubType:(NSString *) animationSubType
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionMoveIn;
    animation.subtype = animationSubType;
    if ( !self.incomingTransition )
        [self.currentImage.layer addAnimation:animation forKey:@"imageTransition"];
    else if ( self.initCount > 0 ) {
        self.incomingTransition = NO;
        self.initCount = 0;
    }
    self.currentImage.image = image;
    
    int x = 20;
    int y = -10;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    self.currentImage.frame = CGRectMake(x, y, width, height);
}

#pragma mark -
#pragma mark Build Interface

- (void) addMemberName: (Member *) member {
    int x = 0;
    int y = [UIScreen mainScreen].bounds.size.height - 75;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if ( nameTextView != nil )
        [nameTextView removeFromSuperview];
    nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    nameTextView.backgroundColor = [UIColor blackColor];
    nameTextView.editable = NO;
    
    NSMutableString *titleAndFirstName = [[NSMutableString alloc] initWithString:@""];
    
    NSShadow *textShadow = [[NSShadow alloc] init];
    textShadow.shadowOffset = CGSizeMake(1, 1);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.0f;
    
    UIFont *font = [UIFont fontWithName: @"BodoniSvtyTwoSCITCTT-Book" size:14.0];
    
    NSDictionary *nameAndTitleAttrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSBackgroundColorAttributeName: [UIColor clearColor],
                                        NSShadowAttributeName:textShadow,
                                        NSFontAttributeName: font,
                                        NSParagraphStyleAttributeName: paragraphStyle
                                      };
    
    [titleAndFirstName appendString:member.fullTitle];
    [titleAndFirstName appendString:@" "];
    [titleAndFirstName appendString:member.firstName];
    [titleAndFirstName appendString:@" "];
    
    NSMutableString *lastName = [[NSMutableString alloc] initWithString:@""];
    [lastName appendString:member.lastName];
    font = [UIFont fontWithName: @"BodoniSvtyTwoSCITCTT-Book" size:28.0];
    NSDictionary *lastNameAttrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                    NSBackgroundColorAttributeName: [UIColor clearColor],
                                    NSShadowAttributeName:textShadow,
                                    NSFontAttributeName: font,
                                    NSParagraphStyleAttributeName: paragraphStyle
                                        };
    
    //New Sunlight API source does not contain leadership information
    //Committee leadership positions only available if all committee members are imported.
    //  Currently, committee members are not imported.
    //See previous revisions for Leadership code
    
    //Combine all strings
    NSMutableString *combinedString = [[NSMutableString alloc] initWithString:titleAndFirstName];
    [combinedString appendString: lastName];
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:combinedString];
    //Set ranges using substring objects length
    [displayString setAttributes:nameAndTitleAttrs range:NSMakeRange(0, titleAndFirstName.length)];
    [displayString setAttributes:lastNameAttrs range:NSMakeRange(titleAndFirstName.length, lastName.length)];
    nameTextView.attributedText = displayString;
    
    [self.view addSubview:nameTextView];
}

- (void) addLogo: (BOOL) senate {
    UIImage *logo;
    if ( senate )
        logo = [FrontViewController senateLogo];
    else
        logo = [FrontViewController houseLogo];
    
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

- (IBAction) switchChamber: (UIGestureRecognizer *) sender  {
    if ( switchingState ) return;
    //Switch between House and Senate views
    NSMutableArray *photoList = [[NSMutableArray alloc] init];
    if ( viewingSenate ) {
        //Switch to House
        viewingSenate = NO;
        [photoList addObjectsFromArray:representatives];
        lastSenatePosition = self.position;
        self.position = lastHousePosition;
    } else {
        //Switch to Senate
        viewingSenate = YES;
        [photoList addObjectsFromArray:senators];
        lastHousePosition = self.position;
        self.position = lastSenatePosition;
    }
    
    self.photos = photoList;
    [self updateImage:YES];
}

- (void) addStateSeal: (Member *) member {
    NSString *filename = [self getStateSealImgFilename:[member state]];
    UIImage *seal = [UIImage imageNamed:filename];
    if ( !seal )
        return;
    
    if ( sealView != nil )
        [sealView removeFromSuperview];
    sealView = [[UIImageView alloc] initWithImage:seal];
    [sealView setContentMode:UIViewContentModeScaleAspectFit];
    
    int x = [UIScreen mainScreen].bounds.size.width - 85;
    int y = [UIScreen mainScreen].bounds.size.height - 185;  //155
    int width = [UIScreen mainScreen].bounds.size.width / 4;
    int height = [UIScreen mainScreen].bounds.size.height / 4;
    
    sealView.frame = CGRectMake(x, y, width, height);
    
    sealView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchState:)];
    [sealView addGestureRecognizer:tap];
    
    NSMutableString *labelText = [[NSMutableString alloc] initWithString:[member state]];
    if ( !member.isSenator ) {
        [labelText appendString:@" - "];
        NSString *district = [member district];
        if ( [district isEqualToString:@"0"] )
            district = @"AL";
        [labelText appendString:district];
    }
    
    sealLabel = [[UILabel alloc] initWithFrame:sealView.frame];
    sealLabel.opaque = NO;
    sealLabel.backgroundColor = [UIColor clearColor];
    sealLabel.font = [UIFont boldSystemFontOfSize:18];
    sealLabel.textColor = [self getPartyColor:member.party];
    sealLabel.shadowColor = [UIColor blackColor];
    sealLabel.shadowOffset = CGSizeMake(0, -2.5);
    sealLabel.text = labelText;
    sealLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:sealView];
    [self.view addSubview:sealLabel];
    [self.view bringSubviewToFront:sealView];
    [self.view bringSubviewToFront:sealLabel];
    
}

- (IBAction) switchState: (UIGestureRecognizer *) sender  {
    
    switchingState = YES;
    if ( statePickerView ) {
        [statePickerView removeFromSuperview];
        [statePickerBackgroundView removeFromSuperview];
    }
    if ( pickerToolbar )
        [pickerToolbar removeFromSuperview];
    if (!self.statePickerDelegate)
        self.statePickerDelegate = [[StatePickerViewDelegate alloc] init];
    
    Member *currentMember = self.photos[self.position];
    NSInteger pickerIndex = [self.statePickerDelegate getStateIndex:[currentMember state]];
    int x = 0;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = 200;
    int y = [UIScreen mainScreen].bounds.size.height;
    
    statePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    statePickerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    statePickerBackgroundView.backgroundColor = [UIColor whiteColor];
    statePickerBackgroundView.alpha = 0.5;
    statePickerView.delegate = self.statePickerDelegate;
    statePickerView.dataSource = self.statePickerDelegate;
    statePickerView.showsSelectionIndicator = YES;
    [statePickerView selectRow:pickerIndex inComponent:0 animated:YES];
    
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(x, y-44, width, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    pickerToolbar.hidden = NO;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(statePickerDone)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(statePickerCancel)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    [barItems addObject:cancelBtn];
    [barItems addObject:doneBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    [pickerToolbar sizeToFit];
    
    [self.view addSubview:statePickerBackgroundView];
    [self.view addSubview:statePickerView];
    [self.view addSubview:pickerToolbar];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -height);
    [UIView animateWithDuration:0.5 animations:^{
        statePickerView.transform = transform;
        pickerToolbar.transform = transform;
        statePickerBackgroundView.transform = transform;
    }];
    
    self.tapRecognizer.enabled = NO;
}

- (void) statePickerDone {
//    NSLog(@"Done.");
    // Get the selected state, navigate to the first Member in that state, and close the picker
    NSInteger row = [statePickerView selectedRowInComponent:0];
    
    NSString *selectedState = [self.statePickerDelegate getStateAbbreviation:row];
    
    for ( int x = 0; x < [self.photos count]; x++ ) {
        Member *member = self.photos[x];
        if ( [member.state isEqualToString:selectedState] ) {
            self.position = x;
            [self updateImage:YES];
            break;
        }
    }
    
    [self statePickerCancel];
}

- (void) statePickerCancel {
//    NSLog(@"Cancel.");

    //Slides the PickerView down out of sight
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 200);

    [UIView animateWithDuration:0.5 animations:^{
        statePickerView.transform = transform;
        pickerToolbar.transform = transform;
        statePickerBackgroundView.transform = transform;
    }];
    switchingState = NO;
    self.tapRecognizer.enabled = YES;
}

#pragma mark -
#pragma mark Initialization

//Load the XML and setup the data to display
- (void)setupData
{
    self.position = 0;
    lastHousePosition = 0;
    lastSenatePosition = 0;
    
    NSMutableArray *photoList = [[NSMutableArray alloc] init];
    
    senators = [DataManager loadSenatorsFromXML];
    representatives = [DataManager loadRepresentativesFromXML];
    [photoList addObjectsFromArray:senators];
    
    self.photos = photoList;
    viewingSenate = YES;
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

#pragma mark Default Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
    [self.view addGestureRecognizer:self.tapRecognizer];
    
    [self setupData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateImage:YES];
    
    self.initCount++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
