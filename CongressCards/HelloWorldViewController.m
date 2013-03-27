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

@interface HelloWorldViewController () {
    NSArray *photos;
    int position;
}
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
    
    NSMutableString *fileName = [NSMutableString stringWithString:photos[position]];
    [fileName appendString:@".jpg"];
    UIImage *picture = [UIImage imageNamed:fileName];
    
    [self setImage:picture withAnimationSubType: kCATransitionFromLeft];
}

- (IBAction)leftSwipe:(id)sender {
    //Go forward to next image
    position++;
    if ( position > ([photos count]-1) )
        position = 0;
    
    NSMutableString *fileName = [NSMutableString stringWithString:photos[position]];
    [fileName appendString:@".jpg"];
    UIImage *picture = [UIImage imageNamed:fileName];
    
    [self setImage:picture withAnimationSubType: kCATransitionFromRight];
}

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
                                         [UIScreen mainScreen].bounds.size.height-image.size.height+40,
                                         [UIScreen mainScreen].bounds.size.width,
                                         image.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
        
    photos = [NSArray arrayWithObjects: @"Obama", @"Biden", @"Boehner", @"Inouye", nil];
    position = 0;
    
    [DataManager loadSenatorsFromXML];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initImage];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//For animation, see http://goo.gl/DkA1W
- (void)initImage
{
    //Set image to current position
    NSMutableString *fileName = [NSMutableString stringWithString:photos[0]];
    [fileName appendString:@".jpg"];
    UIImage *picture = [UIImage imageNamed:fileName];
    [self setImage:picture withAnimationSubType: kCATransitionFromRight];
}

@end
