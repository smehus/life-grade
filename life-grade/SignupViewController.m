//
//  SignupViewController.m
//  life-grade
//
//  Created by scott mehus on 4/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation SignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 300, self.view.frame.size.width - 20, 50)];
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 360, self.view.frame.size.width - 20, 50)];
    
    
    
    
    
    
    
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.passwordTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
