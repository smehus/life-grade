//
//  TrackingProgressViewController.m
//  life-grade
//
//  Created by scott mehus on 9/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "TrackingProgressViewController.h"
#import "MainAppDelegate.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QuartzCore/QuartzCore.h"
#import <MGBoxKit/MGBoxKit.h>
#import "AttainableViewController.h"


@interface TrackingProgressViewController ()

@end

@implementation TrackingProgressViewController {
    MainAppDelegate *del;
    MGBox *container;
    NSString *avFont;
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

    [self setupGrid];
    [self addNextButton];
    
}

- (void)pop {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupGrid {
    UIColor *greenColor = GREEN_COLOR;
    
    container = [MGBox boxWithSize:CGSizeMake(self.view.size.width, 200)];
    container.frame = CGRectMake(0, 150, self.view.frame.size.width, 200);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self.view addSubview:container];
    
    for (int i = 0; i < 6; i++) {
        MGBox *box = [MGBox boxWithSize:CGSizeMake(96, 96)];
        box.leftMargin = 5.0f;
        box.rightMargin = 5.0f;
        box.topMargin = 5.0f;
        box.bottomMargin = 5.0f;
        box.backgroundColor = [UIColor whiteColor];
        box.layer.borderWidth = 1.0f;
        box.layer.borderColor = greenColor.CGColor;
        box.onTap = ^{
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
}

- (void)addNextButton {
    UIColor *green = GREEN_COLOR;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(container.frame) + 20, self.view.frame.size.width-20, 40)];
    [button setBackgroundColor:green];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        AttainableViewController *controller = [[AttainableViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.view addSubview:button];
    
}

@end
