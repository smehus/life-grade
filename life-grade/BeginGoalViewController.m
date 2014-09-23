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

@interface BeginGoalViewController ()

@property (nonatomic, strong) UIView *goalView;
@property (nonatomic, strong) UIView *specificView;

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
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;

//    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
//    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
//    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
//    [self.view addSubview:bg];
//    [self.view sendSubviewToBack:bg];

    
    [self setupGoalView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupGoalView {
    NSString *font = LIGHT_FONT;
    
    self.goalView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, self.view.frame.size.width-40, 300)];
    self.goalView.clipsToBounds = YES;
    self.goalView.backgroundColor = [UIColor whiteColor];
    self.goalView.layer.shadowOffset = CGSizeMake(-15, 15);
    self.goalView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.goalView.layer.shadowRadius = 5.0f;
    self.goalView.layer.shadowOpacity = 1.0f;
    self.goalView.layer.borderWidth = 1.0f;
    self.goalView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.goalView.bounds.origin.x, 0, self.goalView.bounds.size.width, 50)];
    label.font = [UIFont fontWithName:font size:24];
    label.text = @"First Lets Work On That Goal!";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.goalView addSubview:label];
    
    
    UIButton *goalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goalButton setBackgroundColor:[UIColor blueColor]];
    [goalButton setFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 30, self.goalView.bounds.size.width, 50)];
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
    self.specificView = [[UIView alloc] initWithFrame:CGRectMake(20, -300, self.view.frame.size.width-40, 500)];
    self.specificView.clipsToBounds = YES;
    self.specificView.backgroundColor = [UIColor whiteColor];
    self.specificView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.specificView.layer.borderWidth = 1.0f;
    self.specificView.layer.shadowOffset = CGSizeMake(-15, 15);
    self.specificView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.specificView.layer.shadowRadius = 5.0f;
    self.specificView.layer.shadowOpacity = 1.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.specificView.bounds.origin.x, 0, self.specificView.bounds.size.width, 50)];
    label.font = [UIFont fontWithName:font size:24];
    label.text = @"Specific";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.specificView addSubview:label];
    
    
    [self.view addSubview:self.specificView];
    self.specificView.springSpeed = 5.0f;
    self.specificView.springBounciness = 20.0f;
    self.specificView.spring.frame = CGRectMake(20, 20, self.view.frame.size.width-40, 300);

    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 50, self.specificView.frame.size.width - 20, 25)];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:greenCol];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // present new controller
    }];
    [self.specificView addSubview:nextButton];
    
}



@end
