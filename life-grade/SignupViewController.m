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
#import "SWRevealViewController.h"
#import "MONActivityIndicatorView.h"
#import "FinalAnalysisViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "MainAppDelegate.h"
#import "Answers.h"
#import "SCLAlertView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface SignupViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordConfirmation;
@property (nonatomic, strong) UIButton *signUp;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;

@end

@implementation SignupViewController {
    MONActivityIndicatorView *indicatorView;
    MainAppDelegate *appDelegate;
}

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
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    [self setTitleView];
    
    appDelegate = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    


    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    
    
    UILabel *greeting = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 50)];
    greeting.textColor = GREY_COLOR;
    greeting.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22];
    greeting.text = @"Sign up to get your Final analysis!";
    
    UIColor *greyC = GREY_COLOR;
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(greeting.frame) + 20, self.view.frame.size.width - 20, 50)];
    self.userNameField.layer.borderColor = greyC.CGColor;
    self.userNameField.placeholder = @"Email Address";
    self.userNameField.layer.borderWidth = 1.0f;
    self.userNameField.delegate = self;
    self.userNameField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userNameField.frame) + 20, self.view.frame.size.width - 20, 50)];
    self.passwordTextField.layer.borderColor = greyC.CGColor;
    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    self.passwordConfirmation = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.passwordTextField.frame) + 20, self.view.frame.size.width - 20, 50)];
    self.passwordConfirmation.layer.borderColor = greyC.CGColor;
    self.passwordConfirmation.placeholder = @"Confirm Password";
    self.passwordConfirmation.layer.borderWidth = 1.0f;
    self.passwordConfirmation.delegate = self;
    self.passwordConfirmation.secureTextEntry = YES;
    self.passwordConfirmation.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);

    
    self.signUp = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordConfirmation.frame) + 50, self.view.frame.size.width, 50)];
    [self.signUp setBackgroundColor:[UIColor grayColor]];
    [self.signUp setUserInteractionEnabled:NO];
    [self.signUp addTarget:self action:@selector(signMeUp) forControlEvents:UIControlEventTouchUpInside];
    [self.signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    
    
    UIColor* clr = [UIColor colorWithRed:0x3B/255.0f
                                   green:0x59/255.0f
                                    blue:0x98/255.0f alpha:1];
    
    UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fbButton setTitle:@"Facebook" forState:UIControlStateNormal];
    [fbButton setBackgroundColor:clr];
    [fbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(facebookLogin:) forControlEvents:UIControlEventTouchUpInside];
    [fbButton setFrame:CGRectMake(10, CGRectGetMaxY(self.signUp.frame) + 10, self.view.frame.size.width- 20, 44)];
//    [fbButton setCenter: CGPointMake(self.center.x, CGRectGetMaxY(exit.frame) + 25)];

    

    UIButton *signIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signIn setFrame:CGRectMake(0, CGRectGetMaxY(fbButton.frame) + 20, self.view.frame.size.width, 20)];
    [signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signIn.titleLabel setTintColor:[UIColor blackColor]];
    [signIn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    [self.view addSubview:indicatorView];
    
    
    [self.view addSubview:greeting];
    [self.view addSubview:signIn];
    [self.view addSubview:self.signUp];
    [self.view addSubview:fbButton];
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.passwordConfirmation];
    
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0];
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = SlideInToCenter;
    [alert showSuccess:self title:@"Congratulations!" subTitle:@"ONE STEP AWAY FROM YOUR FINAL ANALYSIS" closeButtonTitle:@"Okay" duration:0.0f];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signMeUp {
    

    NSLog(@"***SIGNUP");
    if (self.userNameField.text.length > 0 && self.passwordTextField.text.length > 0 && self.passwordConfirmation.text > 0) {
        [indicatorView startAnimating];
        
        //1
        PFUser *user = [PFUser user];
        //2
        user.username = self.userNameField.text;
        user.email = self.userNameField.text;
        user.password = self.passwordTextField.text;
        
        //3
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [indicatorView stopAnimating];
            
            
            if (!error) {
                
                [PFCloud callFunctionInBackground:@"hello"
                                   withParameters:@{@"email" : self.userNameField.text}
                                            block:^(NSString *result, NSError *error) {
                                                if (!error) {
                                                    NSLog(@"Email Success: %@", result);
                                                } else {
                                                    NSLog(@"ERROR %@ %@", result, error);
                                                }
                                            }];
                
                
                //The registration was successful, go to the wall
                NSLog(@"***SIGNUP SUCCESS");
                
                appDelegate.currentUser = user;
                
                NSString *email = self.userNameField.text;
                NSString *pw = self.passwordTextField.text;
                
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] setObject:pw forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                FinalAnalysisViewController *finalController = [[FinalAnalysisViewController alloc] initWithSave:YES];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalController];
                [self.revealViewController setFrontViewController:nav];
                
                
                
            } else {
                //Something bad has occurred
                
                /*
                 NSString *errorString = [[error userInfo] objectForKey:@"error"];
                 UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [errorAlertView show];
                 */
                
                NSString *email = self.userNameField.text;
                NSString *pw = self.passwordTextField.text;
                
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] setObject:pw forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"signUpFail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                FinalAnalysisViewController *finalController = [[FinalAnalysisViewController alloc] initWithSave:NO];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalController];
                [self.revealViewController setFrontViewController:nav];
                
                
            }
        }];
    } else {
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                    message:@"Please fill out all fields" delegate:nil
                                          cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
        
        [v show];
    }
    

    
    
}

//!!!!: save to core data

- (void)signIn {
    
    NSLog(@"SIGNIN");
    [indicatorView startAnimating];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    SignInView *view = [[SignInView alloc] initWithFrame:rect withBlock:^(NSString *email, NSString *password) {
        NSLog(@"SIGNUPDONEBALLS %@ %@", email, password);
        
        [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
            [indicatorView stopAnimating];
            if (user) {
                
                PFQuery *query = [PFQuery queryWithClassName:@"Grade"];
                [query whereKey:@"user" equalTo:user];
                NSArray *userGrades = [query findObjects];
                
                
                // NEED TO SAVE TO CORE DATA
                
                MainAppDelegate *dela = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                Answers *answers = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:dela.managedObjectContext];
             /*
              *** does this work? ***
              
                answers.questionOne = [[self.myGrades objectAtIndex:0] gradeNum];
                answers.questionTwo = [[self.myGrades objectAtIndex:1] gradeNum];
                answers.questionThree = [[self.myGrades objectAtIndex:2] gradeNum];
                answers.questionFour = [[self.myGrades objectAtIndex:3] gradeNum];
                answers.questionFive = [[self.myGrades objectAtIndex:4] gradeNum];
                answers.questionSix = [[self.myGrades objectAtIndex:5] gradeNum];
                answers.questionSeven = [[self.myGrades objectAtIndex:6] gradeNum];
                answers.questionEight = [[self.myGrades objectAtIndex:7] gradeNum];
                answers.questionNine = [[self.myGrades objectAtIndex:8] gradeNum];
                answers.questionTen = [[self.myGrades objectAtIndex:9] gradeNum];
                answers.finalGrade = [NSNumber numberWithInt:finalNum];
            */
            
            NSString *email = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"email"];
            
            NSString *password = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"password"];
            
            
            NSError *error;
            if (![dela.managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
                abort();
            }
                
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
    view.alpha = 0.0f;
    [self.view addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        
        view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        
    }];



}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.userNameField.text.length > 0 && self.passwordTextField.text.length > 0 && self.passwordConfirmation.text > 0) {
        
        [self.signUp setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
        [self.signUp setUserInteractionEnabled:YES];
    }
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
        [theTextField resignFirstResponder];
    
    return YES;
}


#pragma mark - Facebook Login

- (void)facebookLogin:(id)sender {
    
    NSArray *permissionsArray = @[@"email"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self loadUserDataWithUser:user];
        } else {
            NSLog(@"User logged in through Facebook!");
            FinalAnalysisViewController *final = [[FinalAnalysisViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:final];
            [self.revealViewController setFrontViewController:nav];
            
            
        }
    }];
}


- (void)loadUserDataWithUser:(PFUser *)user {
    // ...
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *email = userData[@"email"];
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            user.email = email;
            user.username = email;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"SAVED USER %i", succeeded);
                
                
                
                [PFCloud callFunctionInBackground:@"hello"
                                   withParameters:@{@"email" : user.email}
                                            block:^(NSString *result, NSError *error) {
                                                if (!error) {
                                                    NSLog(@"Email Success: %@", result);
                                                } else {
                                                    NSLog(@"ERROR %@ %@", result, error);
                                                }
                                            }];
                
                
                //The registration was successful, go to the wall
                NSLog(@"***SIGNUP SUCCESS");
                
                appDelegate.currentUser = user;
                
                NSString *email = user.email;
                
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                FinalAnalysisViewController *finalController = [[FinalAnalysisViewController alloc] initWithSave:YES];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalController];
                [self.revealViewController setFrontViewController:nav];
                
            }];
        }
    }];
}








@end
