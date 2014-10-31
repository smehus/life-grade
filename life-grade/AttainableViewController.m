//
//  AttainableViewController.m
//  life-grade
//
//  Created by scott mehus on 9/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AttainableViewController.h"
#import "MainAppDelegate.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QuartzCore/QuartzCore.h"
#import <MGBoxKit/MGBoxKit.h>
#import "UIView+draggable.h"
#import "RealisticViewController.h"

@interface AttainableViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *yesFrame;
@property (nonatomic, strong) UIView *noFrame;
@property (nonatomic, strong) NSArray *attributes;

@end

@implementation AttainableViewController {
    MainAppDelegate *del;
    NSString *avFont;
    CGRect originalFrame;
    UIColor *blueColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    avFont = AVENIR_BLACK;
    blueColor = BLUE_COLOR;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    self.attributes = [self loadAttributes];
    
    
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    [self setTitleView];
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIColor *grey = GREY_COLOR;
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    [barBtnItem setTintColor:grey];
    self.navigationItem.backBarButtonItem = barBtnItem;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 100)];
    titleLabel.text = @"Tracking Progress";
    titleLabel.font = [UIFont fontWithName:avFont size:24];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
    
    [self addAnswerFrames];
    [self addViews];
    [self addButton];

}

- (NSArray *)loadAttributes {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *ary = [dict objectForKey:@"attributes"];
    NSArray *attributes = [ary componentsSeparatedByString:@" "];
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:10];
    [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *n = [NSNumber numberWithInteger:idx];
        NSDictionary *dict = @{@"isSelected" : @NO, @"attribute" : obj};
        [a addObject:dict];
    }];
    
    
    return a;
}

- (void)setTitleView {
    
    // TITLE VIEW SET
    
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,44*4,44)];
    [iv setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = iv;
    UIImage *titleImage = [UIImage imageNamed:@"header_image.png"];
    
    CGFloat imageHeight = 35.0f;
    CGFloat imageWidth = imageHeight * 4;
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    titleImageView.frame = CGRectMake(iv.frame.size.width/2 - imageWidth/2, 3, imageHeight * 4, imageHeight);
    [iv addSubview:titleImageView];
    self.navigationItem.titleView = iv;
    
    
}

- (void)addViews {
    for (int i = 0; i < 10; i++) {
       
        originalFrame = CGRectMake(25, 150, 100, 160);
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
        
        UIView *thing = [[UIView alloc] initWithFrame:originalFrame];
        thing.layer.cornerRadius = 8.0f;
        
        UILabel *at = [[UILabel alloc] initWithFrame:CGRectMake(0, thing.frame.size.height/2-25, originalFrame.size.width - 20, 50)];
        at.textAlignment = NSTextAlignmentCenter;
        at.font = FONT_AMATIC_REG(24);
        at.lineBreakMode = NSLineBreakByWordWrapping;
        at.numberOfLines = 0;
        
        
        NSDictionary *d = self.attributes[i];
        at.text =  d[@"attribute"];
        [thing addSubview:at];
        
        thing.backgroundColor = blueColor;
        [thing addGestureRecognizer:panGest];
        [self.view addSubview:thing];
    }
}

- (void)addAnswerFrames {
    
    self.yesFrame = [[UIView alloc] initWithFrame:CGRectMake(175, 75, 110, 150)];
    self.yesFrame.backgroundColor = [UIColor clearColor];
    self.yesFrame.layer.borderColor = [UIColor greenColor].CGColor;
    self.yesFrame.layer.borderWidth = 1.0f;
    [self.view addSubview:self.yesFrame];
    
    
    self.noFrame = [[UIView alloc] initWithFrame:CGRectMake(175, CGRectGetMaxY(self.yesFrame.frame) + 35, 110, 150)];
    self.noFrame.backgroundColor = [UIColor clearColor];
    self.noFrame.layer.borderColor = [UIColor greenColor].CGColor;
    self.noFrame.layer.borderWidth = 1.0f;
    self.noFrame.panGesture.delegate = self;
    [self.view addSubview:self.noFrame];
}

- (void)addButton {
    
    UIColor *gC = GREEN_COLOR;
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.noFrame.frame) + 10, self.view.frame.size.width - 20, 50)];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:gC];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        RealisticViewController *controller = [[RealisticViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
    }];
    [self.view addSubview:nextButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didDragView:(UIPanGestureRecognizer *)recognizer {

    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [self.view bringSubviewToFront:recognizer.view];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.05 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:^(BOOL finished) {
           
            CGPoint translation = CGPointMake(recognizer.view.center.x - self.yesFrame.center.x, recognizer.view.center.y - self.yesFrame.center.y);
            CGFloat distanceToYes = hypotf(translation.x, translation.y);
            
            CGPoint translationNo = CGPointMake(recognizer.view.center.x - self.noFrame.center.x, recognizer.view.center.y - self.noFrame.center.y);
            CGFloat distanceToNo = hypotf(translationNo.x, translationNo.y);
            
            // Need to sublcass UIView to add index & Custom objects
            if (distanceToYes < 100) {
                
                recognizer.view.springBounciness = 15.0f;
                recognizer.view.spring.frame = self.yesFrame.frame;

                
            } else if (distanceToNo < 100) {
                
                recognizer.view.springBounciness = 15.0f;
                recognizer.view.spring.frame = self.noFrame.frame;
            } else {
                // back to orig frame
                recognizer.view.springBounciness = 15.0f;
                recognizer.view.spring.frame = originalFrame;
            }
            
        }];
    }
}






@end
