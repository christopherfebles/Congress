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
#import "Senator.h"

@interface HelloWorldViewController () {
    NSArray *photos;
    int position;
    NSArray *senators;
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
    
    [self addBorder];
    
    NSMutableString *displayText = [NSMutableString stringWithString:[member firstName]];
    [displayText appendString:@" "];
    [displayText appendString:[member memberFull]];
    
    self.textView.text = displayText;
}

- (void)addBorder
{
    Member *member = photos[position];
    
    if ( [[member party] isEqualToString:@"R"] ) {
        self.view.layer.borderColor = [UIColor redColor].CGColor;
    } else if ( [[member party] isEqualToString:@"D"] ) {
        self.view.layer.borderColor = [UIColor blueColor].CGColor;
    } else if ( [[member party] isEqualToString:@"I"] ) {
        self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    }

    self.view.layer.borderWidth = 5;
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
    
    self.currentImage.frame = CGRectMake(20,
                                         [UIScreen mainScreen].bounds.size.height-image.size.height+25, //Adjust constant to move image around
                                         [UIScreen mainScreen].bounds.size.width,
                                         image.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
    [self.view addSubview:self.textView];
    
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
    
    NSMutableArray *photoList = [[NSMutableArray alloc] init];
    
    senators = [DataManager loadSenatorsFromXML];
    [photoList addObjectsFromArray:senators];
    
    photos = photoList;
}

@end
