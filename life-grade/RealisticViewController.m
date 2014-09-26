//
//  RealisticViewController.m
//  life-grade
//
//  Created by scott mehus on 9/25/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "RealisticViewController.h"
#import "MainAppDelegate.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RealisticViewController ()

@property (nonatomic, strong) UITextField *firstSupport;
@property (nonatomic, strong) UITextField *secondSupport;
@property (nonatomic, strong) UITextField *thirdSupport;

@end

@implementation RealisticViewController {
    
    MainAppDelegate *del;
    UIImageView *bg;
    NSString *avFont;
    CGRect originalFrame;
    UIColor *blueColor;
    UILabel *titleLabel;
    CGFloat screenWidth;
    NSString *liteFont;
    UILabel *firstLabel;
    UILabel *secondLabel;
    
    UITextField *firstField;
    UITextField *secondField;
    UITextField *thirdField;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    avFont = AVENIR_BLACK;
    blueColor = BLUE_COLOR;
    screenWidth = self.view.frame.size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIColor *grey = GREY_COLOR;
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    [barBtnItem setTintColor:grey];
    self.navigationItem.backBarButtonItem = barBtnItem;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 100)];
    titleLabel.text = @"Realistic";
    titleLabel.font = [UIFont fontWithName:avFont size:24];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];

    
    [self setupScreen];
}

- (void)setupScreen {
    firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 20, screenWidth, 100)];
    firstLabel.text = @"How Confident Are You?";
    firstLabel.font = [UIFont fontWithName:avFont size:24];
    firstLabel.numberOfLines = 0;
    firstLabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:firstLabel];
    
    secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLabel.frame) + 100, screenWidth, 100)];
    secondLabel.text = @"How Confident Are You?";
    secondLabel.font = [UIFont fontWithName:avFont size:24];
    secondLabel.numberOfLines = 0;
    secondLabel.lineBreakMode = NSLineBreakByWordWrapping;
    secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:secondLabel];
    
    UIColor *gC = GREEN_COLOR;
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondLabel.frame) + 10, self.view.frame.size.width - 20, 50)];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:gC];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self RemoveAllViews];
        [self setupSecondScreen];
        
    }];
    [self.view addSubview:nextButton];
}

- (void)RemoveAllViews {
    
    for (UIView *v in self.view.subviews) {
        if (v == bg || v == titleLabel || v == firstLabel) {
            
        } else {
            [v removeFromSuperview];
        }
    }
}

- (void)setupSecondScreen {
    titleLabel.text = @"Timely";
    firstField.text = @" Set a date";
    

    
}

- (void)setupThirdView {
    
    titleLabel.text = @"Support";
    firstLabel.text = @"Name 3 people in your circle";
    
    // need text inset - take from priv things
    
    firstField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, screenWidth - 20, 66)];
    firstField.layer.borderColor = blueColor.CGColor;
    firstField.layer.borderWidth = 1.0f;
    firstField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstField];
    
    secondField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstField.frame) + 10, screenWidth - 20, 66)];
    secondField.layer.borderColor = blueColor.CGColor;
    secondField.layer.borderWidth = 1.0f;
    secondField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondField];
    
    thirdField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondField.frame) + 10, screenWidth - 20, 66)];
    thirdField.layer.borderColor = blueColor.CGColor;
    thirdField.layer.borderWidth = 1.0f;
    thirdField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thirdField];
    
}

- (void)addNextButton {
    
    UIColor *green = GREEN_COLOR;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(thirdField.frame) + 20, self.view.frame.size.width-20, 40)];
    [button setBackgroundColor:green];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        
        
    }];
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    NSLog(@"realistic controller dealloc");
}


@end
