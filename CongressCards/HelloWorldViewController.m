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
#import "StatePickerViewDelegate.h"
#import "HelloWorldAppDelegate.h"
#import "BackViewController.h"

@interface HelloWorldViewController () {
    NSArray *photos;
    int position;
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

@implementation HelloWorldViewController

@synthesize fetchedResultsController, managedObjectContext, statePickerDelegate;

- (IBAction)rightSwipe:(id)sender {
    if ( switchingState ) return;
    //Go back to previous image
    position--;
    if ( position < 0 )
        position = [photos count]-1;
    
    [self updateImage:NO];
}

- (IBAction)leftSwipe:(id)sender {
    if ( switchingState ) return;
    //Go forward to next image
    position++;
    if ( position > ([photos count]-1) )
        position = 0;
    
    [self updateImage:YES];
}

- (IBAction)handleTap {
//    NSLog(@"Registered Tap.");
    //Switch to other controller view
    
    BackViewController *vc = [[BackViewController alloc] init];
    vc.member = photos[position];
    vc.mainController = self;
    
    HelloWorldAppDelegate *appDelegate = (HelloWorldAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate transitionToViewController:vc
                             withTransition:UIViewAnimationOptionTransitionFlipFromRight];
    
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
    [self addMemberName: member];
//    [self addMemberNameViaTextView: member];
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
    else if ( initCount > 0 ) {
        self.incomingTransition = NO;
        initCount = 0;
    }
    self.currentImage.image = image;
    
    int x = 20;
    int y = -10;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    self.currentImage.frame = CGRectMake(x, y, width, height);
}

//There is a bug in UITextView: http://www.cocoanetics.com/2012/12/radar-uitextview-ignores-minimummaximum-line-height-in-attributed-string/
- (void) addMemberNameViaTextView: (Member *) member {
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
    
    if ( [member senator] )
        [titleAndFirstName appendString:@"Senator"];
    else if ( ![member senator] && ![[member state] isEqualToString:@"AS"] && ![[member state] isEqualToString:@"DC"] && ![[member state] isEqualToString:@"GU"] &&
             ![[member state] isEqualToString:@"PR"] && ![[member state] isEqualToString:@"VI"] && ![[member state] isEqualToString:@"MP"])
        [titleAndFirstName appendString:@"Representative"];
    else if ( [[member state] isEqualToString:@"PR"] )
        [titleAndFirstName appendString:@"Resident Commissioner"];
    else
        [titleAndFirstName appendString:@"Delegate"];
    
    [titleAndFirstName appendString:@" "];
    [titleAndFirstName appendString:[member firstName]];
    [titleAndFirstName appendString:@" "];
    
    NSMutableString *lastName = [[NSMutableString alloc] initWithString:@""];
    [lastName appendString:[member lastName]];
    font = [UIFont fontWithName: @"BodoniSvtyTwoSCITCTT-Book" size:28.0];
    NSDictionary *lastNameAttrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                    NSBackgroundColorAttributeName: [UIColor clearColor],
                                    NSShadowAttributeName:textShadow,
                                    NSFontAttributeName: font,
                                    NSParagraphStyleAttributeName: paragraphStyle
                                        };
    
    //Add Leadership position, if available
    NSMutableString *leadershipPosition = [[NSMutableString alloc] initWithString:@""];
    font = [UIFont fontWithName: @"SnellRoundhand" size:14.0];
    NSDictionary *leadershipAttrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSBackgroundColorAttributeName: [UIColor clearColor],
                                      NSShadowAttributeName:textShadow,
                                      NSFontAttributeName: font,
                                      NSParagraphStyleAttributeName: paragraphStyle
                                      };
    [leadershipPosition appendString:@"\n"];
    if ( [member leadershipPosition] ) {
        [leadershipPosition appendString:[member leadershipPosition]];
    } else {
        //If no leadership position, check committee leadership
        if ( [[member committees] count] > 0 ) {
            CommitteeAssignment *displayCommittee = nil;
            //Get highest ranked position (Assuming each Member can only chair one committee)
            for ( CommitteeAssignment *committee in [member committees] ) {
                if ( [[committee position] isEqualToString:@"Ranking Member"] ||
                    [[committee position] isEqualToString:@"Chairman"]) {
                    displayCommittee = committee;
                    break;
                } else if ( [[committee position] isEqualToString:@"Vice Chairman"] )
                    displayCommittee = committee;
            }
            if ( displayCommittee ) {
                [leadershipPosition appendString:@"Committee "];
                [leadershipPosition appendString:[displayCommittee position]];
            }
        }
    }    
    
    //Combine all strings
    NSMutableString *combinedString = [[NSMutableString alloc] initWithString:titleAndFirstName];
    [combinedString appendString: lastName];
    [combinedString appendString: leadershipPosition];
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:combinedString];
    //Set ranges using substring objects length
    [displayString setAttributes:nameAndTitleAttrs range:NSMakeRange(0, titleAndFirstName.length)];
    [displayString setAttributes:lastNameAttrs range:NSMakeRange(titleAndFirstName.length, lastName.length)];
    [displayString setAttributes:leadershipAttrs range:NSMakeRange(titleAndFirstName.length+lastName.length, leadershipPosition.length)];
    
    nameTextView.attributedText = displayString;
    
    [self.view addSubview:nameTextView];
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
        [[NSMutableString alloc] initWithString:@"<span style=\"color: white; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;  line-height: 95%;\"><span style=\"font-variant:small-caps;\">"];
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
    [htmlString appendString:@"</span>"];

    //Add Leadership position, if available
    if ( [member leadershipPosition] ) {
        [htmlString appendString:@"<br><span style=\"font-family:'Snell Roundhand'; font-size: large;\">"];
        [htmlString appendString:[member leadershipPosition]];
        [htmlString appendString:@"</span>"];
    } else {
        //If no leadership position, check committee leadership
        if ( [[member committees] count] > 0 ) {
            CommitteeAssignment *displayCommittee = nil;
            NSString * committeeHTML = @"<br><span style=\"font-family:'Snell Roundhand'; font-size: large;\">";
            //Get highest ranked position (Assuming each Member can only chair one committee)
            for ( CommitteeAssignment *committee in [member committees] ) {
                if ( [[committee position] isEqualToString:@"Ranking Member"] ||
                    [[committee position] isEqualToString:@"Chairman"]) {
                    displayCommittee = committee;
                    break;
                } else if ( [[committee position] isEqualToString:@"Vice Chairman"] )
                    displayCommittee = committee;
            }
            if ( displayCommittee ) {
                [htmlString appendString:committeeHTML];
                [htmlString appendString:@"Committee "];
                [htmlString appendString:[displayCommittee position]];
                [htmlString appendString:@"</span>"];
            }
        }
    }
    [htmlString appendString:@"</span>"];
    
    [nameWebView loadHTMLString:htmlString baseURL:nil];
    nameWebView.opaque = NO;
    nameWebView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:nameWebView];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
    [self.view addGestureRecognizer:self.tapRecognizer];
    
    [self setupData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateImage:YES];
    initCount++;
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
    int y = [UIScreen mainScreen].bounds.size.height - 185;  //155
    int width = [UIScreen mainScreen].bounds.size.width / 4;
    int height = [UIScreen mainScreen].bounds.size.height / 4;
    
    sealView.frame = CGRectMake(x, y, width, height);
    
    sealView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchState:)];
    [sealView addGestureRecognizer:tap];
    
    NSMutableString *labelText = [[NSMutableString alloc] initWithString:[member state]];
    if ( ![member senator] ) {
        [labelText appendString:@" - "];
        NSString *district = [member classDistrict];
        if ( [district isEqualToString:@"At Large"] )
            district = @"AL";
        [labelText appendString:district];
    }
    
    sealLabel = [[UILabel alloc] initWithFrame:[sealView frame]];
    sealLabel.opaque = NO;
    sealLabel.backgroundColor = [UIColor clearColor];
    sealLabel.font = [UIFont boldSystemFontOfSize:18];
    sealLabel.textColor = [self getPartyColor:[member party]];
    sealLabel.shadowColor = [UIColor blackColor];
    sealLabel.shadowOffset = CGSizeMake(0, -2.5);
    sealLabel.text = labelText;
    sealLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:sealView];
    [self.view addSubview:sealLabel];
    [self.view bringSubviewToFront:sealView];
    [self.view bringSubviewToFront:sealLabel];
    
}

- (IBAction) switchChamber: (UIGestureRecognizer *) sender  {
    if ( switchingState ) return;
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

- (IBAction) switchState: (UIGestureRecognizer *) sender  {
    
    switchingState = YES;
    if ( statePickerView )
        [statePickerView removeFromSuperview];
    if ( pickerToolbar )
        [pickerToolbar removeFromSuperview];
    if (!statePickerDelegate)
        statePickerDelegate = [[StatePickerViewDelegate alloc] init];
    
    Member *currentMember = photos[position];
    NSInteger pickerIndex = [statePickerDelegate getIndex:[currentMember state]];
    int x = 0;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = 200;
    int y = [UIScreen mainScreen].bounds.size.height;
    
    statePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    statePickerView.delegate = statePickerDelegate;
    statePickerView.dataSource = statePickerDelegate;
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
    
    [self.view addSubview:statePickerView];
    [self.view addSubview:pickerToolbar];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -height);
    [UIView animateWithDuration:0.5 animations:^{
        statePickerView.transform = transform;
        pickerToolbar.transform = transform;
    }];
    
    self.tapRecognizer.enabled = NO;
}

- (void) statePickerDone {
//    NSLog(@"Done.");
    // Get the selected state, navigate to the first Member in that state, and close the picker
    NSInteger row = [statePickerView selectedRowInComponent:0];
    
    NSString *selectedState = [statePickerDelegate getAbbr:row];
    
    for ( int x = 0; x < [photos count]; x++ ) {
        Member *member = photos[x];
        if ( [[member state] isEqualToString:selectedState] ) {
            position = x;
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
    }];
    switchingState = NO;
    self.tapRecognizer.enabled = YES;
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

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
