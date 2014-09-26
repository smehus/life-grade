//
//  RealisticViewController.m
//  life-grade
//
//  Created by scott mehus on 9/25/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "RealisticViewController.h"
#import "MainAppDelegate.h"

@interface RealisticViewController ()

@end

@implementation RealisticViewController {
    
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 100)];
    titleLabel.text = @"Tracking Progress";
    titleLabel.font = [UIFont fontWithName:avFont size:24];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
