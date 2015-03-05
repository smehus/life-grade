//
//  BeginGoalViewController.m
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "BeginGoalViewController.h"
#import "MainAppDelegate.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QuartzCore/QuartzCore.h"
#import "TrackingProgressViewController.h"
#import "Answers.h"

@interface BeginGoalViewController ()

@property (nonatomic, strong) UIView *goalView;
@property (nonatomic, strong) UIView *specificView;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) UITextField *typeLabel;


@end

@implementation BeginGoalViewController {
    MainAppDelegate *del;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    [self performFetch];
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;

    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    [self setTitleView];

//    [self setupGoalView];
    [self setupSpecificView];
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
    
    NSLog(@"question bitch %@", self.fetchedAnswers);
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupGoalView {
    NSString *font = LIGHT_FONT;
    UIColor *gC = GREEN_COLOR;
    UIColor *blueC = BLUE_COLOR;
    
    self.goalView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, self.view.frame.size.width-40, 400)];
    self.goalView.clipsToBounds = YES;
    self.goalView.backgroundColor = [UIColor whiteColor];
    self.goalView.layer.shadowOffset = CGSizeMake(-5, 5);
    self.goalView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.goalView.layer.shadowRadius = 1.5f;
    self.goalView.layer.shadowOpacity = 0.6f;
    self.goalView.layer.masksToBounds = NO;
    self.goalView.layer.borderColor = blueC.CGColor;
    self.goalView.layer.borderWidth = 3.0f;
    self.goalView.layer.cornerRadius = 5.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.goalView.bounds.origin.x, 0, self.goalView.bounds.size.width, 50)];
    label.font = [UIFont fontWithName:font size:24];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"First Lets Work On That Goal!";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.goalView addSubview:label];
    
    
    UIButton *goalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goalButton setBackgroundColor:gC];
    [goalButton setFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 30, self.goalView.bounds.size.width - 20, 150)];
    [goalButton setTitle:@"Begin Goal Design" forState:UIControlStateNormal];
    [[goalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        self.goalView.spring.frame = CGRectMake(20, 600, self.view.frame.size.width-40, 300);
        self.goalView.springSpeed = 20.0f;
        self.goalView.springBounciness = 20.0f;

        [self setupSpecificView];
        
    }];
    [self.goalView addSubview:goalButton];
    
    [self.view addSubview:self.goalView];
    
}

- (void)setupSpecificView {
    
    UIColor *greenCol = GREEN_COLOR;
    NSString *font = LIGHT_FONT;
    UIColor *blueC = BLUE_COLOR;
    
    self.specificView = [[UIView alloc] initWithFrame:CGRectMake(20, -300, self.view.frame.size.width-40, 400)];
    self.specificView.clipsToBounds = YES;
    self.specificView.backgroundColor = [UIColor whiteColor];
    self.specificView.layer.shadowOffset = CGSizeMake(-5, 5);
    self.specificView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.specificView.layer.shadowRadius = 1.5f;
    self.specificView.layer.shadowOpacity = 0.6f;
    self.specificView.layer.masksToBounds = NO;
    self.specificView.layer.borderColor = blueC.CGColor;
    self.specificView.layer.borderWidth = 3.0f;
    self.specificView.layer.cornerRadius = 5.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.specificView.bounds.origin.x, 0, self.specificView.bounds.size.width, 50)];
    label.font = FONT_AVENIR_BLACK(18);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Lets Be Specific...";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.specificView addSubview:label];
    
    UILabel *someText = [[UILabel alloc] initWithFrame:CGRectMake(self.specificView.bounds.origin.x + 10, CGRectGetMaxY(label.frame) + 10, self.specificView.bounds.size.width - 20, 150)];
    someText.font = FONT_AMATIC_BOLD(26);
    someText.textAlignment = NSTextAlignmentCenter;
    someText.text = @"In order to know exactly what you want to accomplish with this goal, we need you to be more specific.\n\n Type in your specific goal below:";
    someText.numberOfLines = 0;
    someText.lineBreakMode = NSLineBreakByWordWrapping;
    [self.specificView addSubview:someText];
    
    self.typeLabel = [[UITextField alloc] initWithFrame:CGRectMake(self.specificView.bounds.origin.x + 10, CGRectGetMaxY(someText.frame) + 10, self.specificView.bounds.size.width - 20, 50)];
    self.typeLabel.font = FONT_AMATIC_BOLD(24);
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.placeholder = @" Example: Lose 10 Pounds";
    self.typeLabel.layer.borderWidth = 1.0f;
    self.typeLabel.layer.borderColor = greenCol.CGColor;
    [self.specificView addSubview:self.typeLabel];
    
    if (self.fetchedAnswers.specificFocus != nil) {
        
        self.typeLabel.text = self.fetchedAnswers.specificFocus;
        
    }
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setFrame:CGRectMake(10, CGRectGetMaxY(self.typeLabel.frame) + 25, self.specificView.bounds.size.width - 20, 50)];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:greenCol];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.typeLabel.text.length > 0) {
            [self save];
            TrackingProgressViewController *trackController = [[TrackingProgressViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:trackController];
            [self.revealViewController pushFrontViewController:nav animated:YES];
        } else {
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Please enter a specific goal"
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
            [a show];
        }

//        [self.navigationController pushViewController:trackController animated:YES];
    }];
    [self.specificView addSubview:nextButton];
    
    [self.view addSubview:self.specificView];
    self.specificView.springSpeed = 5.0f;
    self.specificView.springBounciness = 20.0f;
    self.specificView.spring.frame = CGRectMake(20, 20, self.view.frame.size.width-40, 400);

}

- (void)save {
    
    NSString *theString = self.typeLabel.text;
    
    self.fetchedAnswers.specificFocus = theString;
    
    
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
}



@end
