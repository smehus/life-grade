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
#import "Answers.h"
#import "AttributeSwipeView.h"
#import "Attributes.h"

@interface AttainableViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *yesFrame;
@property (nonatomic, strong) UIView *noFrame;
@property (nonatomic, strong) NSArray *attributes;

@property (nonatomic, strong) NSMutableArray *yesFactors;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSArray *fetchedAttributes;

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
    
    self.yesFactors = [[NSMutableArray alloc] initWithCapacity:10];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    [self performFetch];
    
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    titleLabel.text = @"Hold & Drag which traits you need to accomplish your goal";
    titleLabel.font = [UIFont fontWithName:avFont size:16];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
    
    int sub = 0;
    if ([self isIpad]) {
        sub = 5;
    } else {
        sub = 20;
    }

    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame) + sub, self.view.frame.size.width/2 - 5, 100)];
    goalLabel.text = [NSString stringWithFormat:@"Goal: %@", self.fetchedAnswers.specificFocus];

    goalLabel.textAlignment = NSTextAlignmentCenter;
    goalLabel.font = FONT_AMATIC_BOLD(28);
    goalLabel.numberOfLines = 0;
    goalLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:goalLabel];
    
    
    [self addAnswerFrames];
    [self addViews];
    [self addButton];

}

- (BOOL)isIpad {
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"] || [deviceType isEqualToString:@"iPhone Simulator"])
    {
        return NO;
    } else {
        return YES;
    }
}


- (void)performFetch {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Answers"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answers" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"***CORE_DATA_ERROR*** %@", error);
        
        
        return;
    }
    
    self.fetchedAnswers = [foundObjects lastObject];
    NSLog(@"atttts %@", self.fetchedAnswers.attributes);
    
    /*
    if (self.fetchedAnswers.attributes.count > 0) {
//        [self fetchAttributes];
        [self deleteAllObjects:@"Attributes"];
    }
    */
    
    [self deleteAllObjects:@"Attributes"];
    NSLog(@"question bitch %@", self.fetchedAnswers);
    
}

- (void)fetchAttributes {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Answers"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Attributes" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSError *error;
    NSArray *foundObjects = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"***CORE_DATA_ERROR*** %@", error);
        
        return;
    }
    
    self.fetchedAttributes = foundObjects;
    
    [self.fetchedAttributes enumerateObjectsUsingBlock:^(Attributes *obj, NSUInteger idx, BOOL *stop) {
     
        NSString *a = obj.attribute;
        
    }];
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    
    for (NSManagedObject *managedObject in items) {
        [self.managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
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
    
    int sub = 0;
    int ret = 0;
    if ([self isIpad]) {
        sub = 125;
        ret = 120;
    } else {
        sub = 175;
        ret = 160;
    }
    
    for (int i = 0; i < 10; i++) {
       
        originalFrame = CGRectMake(25, sub, 100, ret);
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
        
        // Make custom view
        AttributeSwipeView *thing = [[AttributeSwipeView alloc] initWithFrame:originalFrame];
        thing.layer.cornerRadius = 8.0f;
        thing.layer.borderColor = [UIColor blackColor].CGColor;
        thing.layer.borderWidth = 1.0f;

        
        UILabel *at = [[UILabel alloc] initWithFrame:CGRectMake(0, thing.frame.size.height/2-25, originalFrame.size.width, 50)];
        at.textAlignment = NSTextAlignmentCenter;
        at.font = FONT_AMATIC_REG(24);
        at.lineBreakMode = NSLineBreakByWordWrapping;
        at.numberOfLines = 0;
        
        
        NSDictionary *d = self.attributes[i];
        thing.attribute = d;
        at.text =  d[@"attribute"];
        [thing addSubview:at];
        
        thing.backgroundColor = blueColor;
        [thing addGestureRecognizer:panGest];
        [self.view addSubview:thing];
    }
}

- (void)addAnswerFrames {
    
    int sub = 0;
    int ret = 0;
    int hgh = 0;
    if ([self isIpad]) {
        sub = 50;
        ret = 0;
        hgh = 120;
    } else {
        sub = 75;
        ret = 25;
        hgh = 150;
    }
    
    UILabel *yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, sub, 110, 25)];
    yesLabel.text = @"Yes";
    yesLabel.font = FONT_AVENIR_BLACK(22);
    yesLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:yesLabel];
    
    self.yesFrame = [[UIView alloc] initWithFrame:CGRectMake(175, CGRectGetMaxY(yesLabel.frame) + ret, 110, hgh)];
    self.yesFrame.backgroundColor = [UIColor clearColor];
    self.yesFrame.layer.borderColor = [UIColor greenColor].CGColor;
    self.yesFrame.backgroundColor = GREEN_COLOR;
    self.yesFrame.layer.cornerRadius = 8.0f;
    [self.view addSubview:self.yesFrame];
    
    
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, CGRectGetMaxY(self.yesFrame.frame) + 10, 110, 25)];
    noLabel.text = @"NO";
    noLabel.font = FONT_AVENIR_BLACK(22);
    noLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noLabel];
    
    self.noFrame = [[UIView alloc] initWithFrame:CGRectMake(175, CGRectGetMaxY(self.yesFrame.frame) + 35, 110, hgh)];
    self.noFrame.backgroundColor = [UIColor clearColor];
    self.noFrame.backgroundColor = [UIColor redColor];
    self.noFrame.alpha = 1.0f;
    self.noFrame.panGesture.delegate = self;
    self.noFrame.layer.cornerRadius = 8.0f;
    [self.view addSubview:self.noFrame];
}

- (void)addButton {
    
    UIColor *gC = GREEN_COLOR;
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.noFrame.frame) + 10, self.view.frame.size.width - 20, 50)];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:gC];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (self.yesFactors.count < 3) {
            
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Please select three yes factors" delegate:nil
                                              cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [a show];
            
        } else {
        
       
        [self doneButton];
        RealisticViewController *controller = [[RealisticViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        }
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
    
    AttributeSwipeView *swipeView = (AttributeSwipeView *)recognizer.view;
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
                [self.yesFactors addObject:swipeView];

                
            } else if (distanceToNo < 100) {
                
                recognizer.view.springBounciness = 15.0f;
                recognizer.view.spring.frame = self.noFrame.frame;
                if ([self.yesFactors containsObject:swipeView]) {
                    
                    [self.yesFactors removeObject:swipeView];
                }
                
                
            } else {
                // back to orig frame
                recognizer.view.springBounciness = 15.0f;
                recognizer.view.spring.frame = originalFrame;
            }
            
        }];
    }
}

- (void)doneButton {
    //    FinalGradeViewController *finalController = [[FinalGradeViewController alloc] init];
    
    [self.yesFactors enumerateObjectsUsingBlock:^(AttributeSwipeView *obj, NSUInteger idx, BOOL *stop) {
        
        Attributes *at = [NSEntityDescription insertNewObjectForEntityForName:@"Attributes"
                                                       inManagedObjectContext:self.managedObjectContext];
        
        AttributeSwipeView *d = obj;
        
        at.attribute = d.attribute[@"attribute"];
        
    }];
    
    [self save];
    

    
}

- (void)save {
    

    /*
    for (int i = 0; i < 4; i++) {
        
        if (i == 0) {
            self.fetchedAnswers.trackingProgressOne = self.yesFactors[0];
        } else if (i == 1) {
            self.fetchedAnswers.trackingProgressTwo = self.yesFactors[1];
        } else if (i == 2) {
            self.fetchedAnswers.trackingProgressThree = self.yesFactors[2];
        }
    }
    
    */
    
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
}




@end
