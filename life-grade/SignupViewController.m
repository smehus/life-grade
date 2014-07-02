//
//  SignupViewController.m
//  life-grade
//
//  Created by scott mehus on 4/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "SignInView.h"
#import "FinalGradeViewController.h"

@interface SignupViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordConfirmation;
@property (nonatomic, strong) UIButton *signUp;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width - 20, 50)];
    self.userNameField.layer.borderColor = [UIColor blackColor].CGColor;
    self.userNameField.placeholder = @"Email Address";
    self.userNameField.layer.borderWidth = 1.0f;
    self.userNameField.delegate = self;
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userNameField.frame) + 20, self.view.frame.size.width - 20, 50)];
    self.passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.delegate = self;
    
    self.passwordConfirmation = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.passwordTextField.frame) + 20, self.view.frame.size.width - 20, 50)];
    self.passwordConfirmation.layer.borderColor = [UIColor blackColor].CGColor;
    self.passwordConfirmation.placeholder = @"Confirm Password";
    self.passwordConfirmation.layer.borderWidth = 1.0f;
    self.passwordConfirmation.delegate = self;
    
    
    UIButton *signIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signIn setFrame:CGRectMake(0, CGRectGetMaxY(self.passwordConfirmation.frame) + 20, self.view.frame.size.width, 20)];
    [signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signIn.titleLabel setTintColor:[UIColor blackColor]];
    [signIn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.signUp = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordConfirmation.frame) + 50, self.view.frame.size.width, 50)];
    [self.signUp setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.signUp addTarget:self action:@selector(signMeUp) forControlEvents:UIControlEventTouchUpInside];
    [self.signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    

    
    
    
    [self.view addSubview:signIn];
    [self.view addSubview:self.signUp];
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.passwordConfirmation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signMeUp {
    
    NSLog(@"***SIGNUP");
    
    //1
    PFUser *user = [PFUser user];
    //2
    user.username = self.userNameField.text;
    user.password = self.passwordTextField.text;
    //3
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //The registration was successful, go to the wall
            NSLog(@"***SIGNUP SUCCESS");
            
            
            
            
        } else {
            //Something bad has occurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
    
    
}

- (void)signIn {
    
    NSLog(@"SIGNIN");
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    SignInView *view = [[SignInView alloc] initWithFrame:rect withBlock:^(NSString *email, NSString *password) {
        NSLog(@"SIGNUPDONEBALLS %@ %@", email, password);
        
        [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
            if (user) {
                
                FinalGradeViewController *final = [[FinalGradeViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:final];

                NSLog(@"SIGNIN SUCCESS");
                

                
            } else {

                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
        
        
    }];

    [self.view addSubview:view];

}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
        [theTextField resignFirstResponder];
    
    return YES;
}

@end
