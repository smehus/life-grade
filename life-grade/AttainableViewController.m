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

@interface AttainableViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *yesFrame;
@property (nonatomic, strong) UIView *noFrame;

@end

@implementation AttainableViewController {
        MainAppDelegate *del;
        NSString *avFont;
        CGRect originalFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    avFont = AVENIR_BLACK;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIColor *grey = GREY_COLOR;
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    [barBtnItem setTintColor:grey];
    self.navigationItem.backBarButtonItem = barBtnItem;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 100)];
    titleLabel.text = @"Tracking Progress";
    titleLabel.font = [UIFont fontWithName:avFont size:24];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
    
    [self addAnswerFrames];
    [self addViews];

}

- (void)addViews {
    for (int i = 0; i < 10; i++) {
       
        originalFrame = CGRectMake(25, 200, 100, 150);
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
        
        UIView *thing = [[UIView alloc] initWithFrame:originalFrame];
        thing.backgroundColor = [UIColor redColor];
//        [thing enableDragging];
        [thing addGestureRecognizer:panGest];
        [self.view addSubview:thing];
    }
}

- (void)addAnswerFrames {
    
    self.yesFrame = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 100, 150)];
    self.yesFrame.backgroundColor = [UIColor clearColor];
    self.yesFrame.layer.borderColor = [UIColor greenColor].CGColor;
    self.yesFrame.layer.borderWidth = 1.0f;
    [self.view addSubview:self.yesFrame];
    
    
    self.noFrame = [[UIView alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(self.yesFrame.frame) + 50, 100, 150)];
    self.noFrame.backgroundColor = [UIColor clearColor];
    self.noFrame.layer.borderColor = [UIColor greenColor].CGColor;
    self.noFrame.layer.borderWidth = 1.0f;
    self.noFrame.panGesture.delegate = self;
    [self.view addSubview:self.noFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didDragView:(UIPanGestureRecognizer *)recognizer {

    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
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
