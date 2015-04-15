//
//  OpeningViewController.m
//  life-grade
//
//  Created by scott mehus on 3/23/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "OpeningViewController.h"
#import "SWRevealViewController.h"
#import "DesiredGradeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AttributesViewController.h"
#import "PickDesiredGradeController.h"
#import "SignInView.h"
#import <Parse/Parse.h>
#import "FinalGradeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ChecklistViewController.h"
#import "MainAppDelegate.h"
#import "SDiPhoneVersion.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "FBSDKGraphRequest.h"


@interface OpeningViewController () <UIScrollViewDelegate, SignInViewDelegate>
@property (nonatomic, strong) SWRevealViewController *myRevealController;
@property (strong, nonatomic) UILabel *LifeLabel;
@property (strong, nonatomic) UILabel *GradeLabel;
@property (nonatomic, strong) UILabel *stepOne;
@property (nonatomic, strong) BFPaperButton *startButton;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) SignInView *signInView;
@property (nonatomic, strong) UIPageControl *pageControl;


@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@end



@implementation OpeningViewController {
    
    int currentPage;
    CGFloat navBarHeight;
    CGFloat viewHeight;
    CGSize viewSize;
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
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    appDelegate = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    navBarHeight = self.navigationController.navigationBar.frame.size.height + 20;
    viewHeight = self.view.frame.size.height - navBarHeight;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    viewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(self.view.frame.origin.x, 35, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bg];


    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *4, viewSize.height);
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    self.myRevealController = [self revealViewController];
    appDelegate.myRevealController = self.myRevealController;
    [self.view addGestureRecognizer:self.myRevealController.panGestureRecognizer];
    
    [self setUpPageOne];
    [self setupWelcomePage];
    [self setUpPageTwo];
    [self setUpPageThree];
    
    int sub = 0;
    if ([self isIpad] || IS_IPHONE4) {
        
        sub = 85;
    } else {
        sub = 25;
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, viewHeight - sub, self.view.frame.size.width - 40, 20)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPageIndicatorTintColor = GREEN_COLOR;
    self.pageControl.pageIndicatorTintColor = GREY_COLOR;
    self.pageControl.userInteractionEnabled = NO;
    
    [self loadshit];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:self.scrollView];
    [self.view sendSubviewToBack:bg];

}

- (void)loadFonts {
    
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

- (void)loadshit {
    
    NSString *string = @"Accountable Adaptable Adventurous Alert Ambitious Assertive Attentive Authentic Aware Brave Certain Clear Collaborative Committed Communicator Compassion Connection Conscious Consistent Cooperative Creative Curious Dedicated Determined Disciplined Efficient Empathetic Energetic Ethical Excited Expressive Flexible Generosity Gratitude HardWorking Honest Humorous Imaginative Independent Initiates Innovative Intentional Intimate Knowledgeable Listener ManagesTimeWell Networker Open-Minded Organized Patient Planner Practical Proactive Problem-Solver Productive Reliable Resourceful Self-confident Self-generating Self-reliant SenseofHumor Sincere Skillful Spiritual Stable Supportive Tactful Trusting Trustworthy Willing";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *ary = [dict objectForKey:@"attributes"];
    NSArray *attributes = [ary componentsSeparatedByString:@" "];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openGradeController {
    
    
    DesiredGradeViewController *desiredController = [[DesiredGradeViewController alloc] init];
    desiredController.managedObjectContext = self.managedObjectContext;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:desiredController];
    [self.myRevealController pushFrontViewController:navCon animated:YES];
    
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

- (void)setUpPageOne {
    
    self.title = @"Welcome";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f]};
    
    
    // unused
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.LifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 50)];
    self.LifeLabel.textColor = GREY_COLOR;
    self.LifeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat fontSize = self.LifeLabel.font.pointSize;
    self.LifeLabel.frame = CGRectMake(25, 50, 150, fontSize);
    self.LifeLabel.text = @"Life";
    
    UIImage *logo = [UIImage imageNamed:@"openingImage"];
    self.logoView = [[UIImageView alloc] initWithImage:logo];
    self.logoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.GradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.LifeLabel.frame.size.width + 50,
                                                                self.LifeLabel.frame.size.height + 60, 150, 50)];
    self.GradeLabel.textColor = GREY_COLOR
    self.GradeLabel.text = @"Grade";
    self.GradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat gradeSize = self.GradeLabel.font.pointSize;
    self.GradeLabel.frame = CGRectMake(self.LifeLabel.frame.origin.x + 25,
                                       self.LifeLabel.frame.size.height + 60, 320, gradeSize);
    
    NSString *avFont = AVENIR_BLACK;
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    int sub = 0;
    if ([self isIpad] == YES || [SDiPhoneVersion  deviceVersion] == iPhone4 || [SDiPhoneVersion deviceVersion] == iPhone4S || IS_IPHONE4)
    {
        
        sub = 150;
    } else {
        sub = 110;
    }
    [signInButton setFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - sub, self.view.frame.size.width, 30)];
    [signInButton setTitle:@"Already a member?" forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInButton.titleLabel setFont:[UIFont fontWithName:avFont size:18]];
    [signInButton addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.logoView];
    [self.scrollView addSubview:signInButton];

}

// maybe all the grades and final numb aren't set?

#pragma mark - SignInView Delegato


- (void)signedUpWithFb:(PFUser *)user {
    NSLog(@"SIGNED IN WTIH FB YO");    
    [self loadUserData];
}

- (void)loadUserData {
    // ...
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
        }
    }];
}

- (void)loggedInWithFB:(PFUser *)user {
    NSLog(@"SIGNED IN WTIH FB YO");
    
        PFQuery *query = [PFQuery queryWithClassName:@"Grade"];
        [query whereKey:@"user" equalTo:user];
        NSArray *userGrades = [query findObjects];
        PFObject *grades = [userGrades firstObject];
        
        
        NSNumber* qOne = [grades objectForKey:@"questionOne"];
        NSNumber* qTwo = [grades objectForKey:@"questionTwo"];
        NSNumber* qThree = [grades objectForKey:@"questionThree"];
        NSNumber* qFour = [grades objectForKey:@"questionFour"];
        NSNumber* qFive = [grades objectForKey:@"questionFive"];
        NSNumber* qSix = [grades objectForKey:@"questionSix"];
        NSNumber* qSeven = [grades objectForKey:@"questionSeven"];
        NSNumber* qEight = [grades objectForKey:@"questionEight"];
        NSNumber* qNine = [grades objectForKey:@"questionNine"];
        NSNumber* qTen = [grades objectForKey:@"questionTen"];
        NSNumber *finalNum = [grades objectForKey:@"finalGrade"];
        NSString *trackOne = [grades objectForKey:@"trackingProgressOne"];
        NSString *trackTwo = [grades objectForKey:@"trackingProgressTwo"];
        NSString *trackThree = [grades objectForKey:@"trackingProgressThree"];
        NSDate *startDate = [grades objectForKey:@"startDate"];
        NSDate *endDate = [grades objectForKey:@"endDate"];
        NSString *firstSupport = [grades objectForKey:@"firstSupport"];
        NSString *secondSupport = [grades objectForKey:@"secondSupport"];
        NSString *thirdSupport = [grades objectForKey:@"thirdSupport"];
        NSString *specificFocus = [grades objectForKey:@"specificFocus"];
        
        // NEED TO SAVE TO CORE DATA
        
        MainAppDelegate *dela = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        Answers *answers = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:dela.managedObjectContext];
        
        answers.questionOne = qOne;
        answers.questionTwo = qTwo;
        answers.questionThree = qThree;
        answers.questionFour = qFour;
        answers.questionFive = qFive;
        answers.questionSix = qSix;
        answers.questionSeven = qSeven;
        answers.questionEight = qEight;
        answers.questionNine = qNine;
        answers.questionTen = qTen;
        answers.finalGrade = finalNum;
        answers.trackingProgressOne = trackOne;
        answers.trackingProgressTwo = trackTwo;
        answers.trackingProgressThree = trackThree;
        answers.firstSupport = firstSupport;
        answers.secondSupport = secondSupport;
        answers.thirdSupport = thirdSupport;
        answers.startDate = startDate;
        answers.endDate = endDate;
        answers.specificFocus = specificFocus;
        
        
        NSError *error;
        if (![dela.managedObjectContext save:&error]) {
            NSLog(@"Error: %@", error);
            abort();
        }
        
        FinalAnalysisViewController *final = [[FinalAnalysisViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:final];
        [self.revealViewController setFrontViewController:nav];
        
        NSLog(@"SIGNIN SUCCESS %@", [userGrades firstObject]);
        
        // Need to set fetched grades from parse


}

- (void)signIn {
    
    
    NSLog(@"SIGNIN");
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.signInView = [[SignInView alloc] initWithFrame:rect withBlock:^(NSString *email, NSString *password) {
        [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
            if (user) {
                
                
                PFQuery *query = [PFQuery queryWithClassName:@"Grade"];
                [query whereKey:@"user" equalTo:user];
                NSArray *userGrades = [query findObjects];
                PFObject *grades = [userGrades firstObject];
                
                
                NSNumber* qOne = [grades objectForKey:@"questionOne"];
                NSNumber* qTwo = [grades objectForKey:@"questionTwo"];
                NSNumber* qThree = [grades objectForKey:@"questionThree"];
                NSNumber* qFour = [grades objectForKey:@"questionFour"];
                NSNumber* qFive = [grades objectForKey:@"questionFive"];
                NSNumber* qSix = [grades objectForKey:@"questionSix"];
                NSNumber* qSeven = [grades objectForKey:@"questionSeven"];
                NSNumber* qEight = [grades objectForKey:@"questionEight"];
                NSNumber* qNine = [grades objectForKey:@"questionNine"];
                NSNumber* qTen = [grades objectForKey:@"questionTen"];
                NSNumber *finalNum = [grades objectForKey:@"finalGrade"];
                NSString *trackOne = [grades objectForKey:@"trackingProgressOne"];
                NSString *trackTwo = [grades objectForKey:@"trackingProgressTwo"];
                NSString *trackThree = [grades objectForKey:@"trackingProgressThree"];
                NSDate *startDate = [grades objectForKey:@"startDate"];
                NSDate *endDate = [grades objectForKey:@"endDate"];
                NSString *firstSupport = [grades objectForKey:@"firstSupport"];
                NSString *secondSupport = [grades objectForKey:@"secondSupport"];
                NSString *thirdSupport = [grades objectForKey:@"thirdSupport"];
                NSString *specificFocus = [grades objectForKey:@"specificFocus"];
                
                // NEED TO SAVE TO CORE DATA
                
                MainAppDelegate *dela = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                Answers *answers = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:dela.managedObjectContext];
                
                answers.questionOne = qOne;
                answers.questionTwo = qTwo;
                answers.questionThree = qThree;
                answers.questionFour = qFour;
                answers.questionFive = qFive;
                answers.questionSix = qSix;
                answers.questionSeven = qSeven;
                answers.questionEight = qEight;
                answers.questionNine = qNine;
                answers.questionTen = qTen;
                answers.finalGrade = finalNum;
                answers.trackingProgressOne = trackOne;
                answers.trackingProgressTwo = trackTwo;
                answers.trackingProgressThree = trackThree;
                answers.firstSupport = firstSupport;
                answers.secondSupport = secondSupport;
                answers.thirdSupport = thirdSupport;
                answers.startDate = startDate;
                answers.endDate = endDate;
                answers.specificFocus = specificFocus;

                
                NSError *error;
                if (![dela.managedObjectContext save:&error]) {
                    NSLog(@"Error: %@", error);
                    abort();
                }
                
                FinalAnalysisViewController *final = [[FinalAnalysisViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:final];
                [self.revealViewController setFrontViewController:nav];
                
                NSLog(@"SIGNIN SUCCESS %@", [userGrades firstObject]);
                
                // Need to set fetched grades from parse
                
                
            } else {
                
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
        
        
    }];
    
    self.signInView.theDelegate = self;
    self.signInView.alpha = 0.0f;
    [self.view addSubview:self.signInView];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.signInView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)setupWelcomePage {
    
    NSString *avFont = AVENIR_BLACK;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width, 0, viewSize.width, viewHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    self.title = @"Life+Grade";
    
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    
    self.stepOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, view.frame.size.width, 50)];
    self.stepOne.text = @"3 Life Grade Steps";
    self.stepOne.textColor = GREY_COLOR;
    self.stepOne.backgroundColor = GREEN_COLOR;
    self.stepOne.textAlignment = NSTextAlignmentCenter;
    self.stepOne.font = [UIFont fontWithName:avFont size:35];
    [view addSubview:self.stepOne];
    
    // FIRST LINE
    
    
    UILabel *romanUno = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.stepOne.frame) + 12, self.view.frame.size.width-40, 300)];
    romanUno.text = @"Welcome to the Life+Grade! \n\nCongratulations on making a healthy decision for yourself today. During the Life+Grade you will work through 3 steps that will help you get to your higher grade in life. Let’s start by checking those steps out.";
    romanUno.font = FONT_AMATIC_BOLD(30);
    romanUno.lineBreakMode = NSLineBreakByWordWrapping;
    romanUno.numberOfLines = 0;
    romanUno.textAlignment = NSTextAlignmentCenter;
    [view addSubview:romanUno];

    int sub = 0;
    if ([self isIpad] || IS_IPHONE4) {
        sub = 0;
    } else {
        sub = 40;
    }
    
    self.startButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(romanUno.frame) + sub, self.view.frame.size.width - 40, 50) raised:NO];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    self.startButton.rippleFromTapLocation = YES;
    self.startButton.rippleBeyondBounds = YES;
    [self.startButton addTarget:self action:@selector(scrollToNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.startButton.titleLabel setFont:[UIFont fontWithName:avFont size:16]];
    [view addSubview:self.startButton];
    
    
    [self.scrollView addSubview:view];
}

- (void)setUpPageTwo {
    
    NSString *avFont = AVENIR_BLACK;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width*2, 0, viewSize.width, viewHeight)];
    view.backgroundColor = [UIColor clearColor];

    self.title = @"Life+Grade";
    
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    
    self.stepOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, view.frame.size.width, 50)];
    self.stepOne.text = @"3 Life Grade Steps";
    self.stepOne.textColor = GREY_COLOR;
    self.stepOne.backgroundColor = GREEN_COLOR;
    self.stepOne.textAlignment = NSTextAlignmentCenter;
    self.stepOne.font = [UIFont fontWithName:avFont size:35];
    [view addSubview:self.stepOne];
    
    // FIRST LINE
    

    UIImageView *firstCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.stepOne.frame) + 20, 75, 75)];
    firstCheck.image = checkBox;
    firstCheck.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:firstCheck];
    
    UILabel *romanUno = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, CGRectGetMaxY(self.stepOne.frame) + 12, 40, 75)];
    romanUno.text = @"I:";
    romanUno.font = FONT_AMATIC_BOLD(40);
    [view addSubview:romanUno];
    
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(romanUno.frame), romanUno.frame.origin.y, 150, 75)];
    current.text = @"Current Grade";
    current.font = FONT_AMATIC_BOLD(40);
    [view addSubview:current];
    
    
    
    // SECOND LINE
    
    UIImageView *secondCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(current.frame) + 40, 75, 75)];
    secondCheck.image = checkBox;
    secondCheck.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:secondCheck];
    
    UILabel *romanDos = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondCheck.frame) + 5, secondCheck.frame.origin.y -8, 40, 75)];
    romanDos.text = @"II:";
    romanDos.font = FONT_AMATIC_BOLD(40);
    [view addSubview:romanDos];
    
    UILabel *desired = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(romanDos.frame) + 5, romanDos.frame.origin.y, 150, 75)];
    desired.text = @"Desired Grade";
    desired.font = FONT_AMATIC_BOLD(40);
    [view addSubview:desired];
    
    
    // THIRD LINE

    
    UIImageView *thirdCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(desired.frame) + 40, 75, 75)];
    thirdCheck.image = checkBox;
    thirdCheck.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:thirdCheck];
    
    
    UILabel *romanTres = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdCheck.frame) + 5, thirdCheck.frame.origin.y - 8, 40, 75)];
    romanTres.text = @"III:";
    romanTres.font = FONT_AMATIC_BOLD(40);
    [view addSubview:romanTres];

    UILabel *action = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(romanTres.frame) + 5, romanTres.frame.origin.y, 150, 75)];
    action.text = @"Action Plan";
    action.font = FONT_AMATIC_BOLD(40);
    [view addSubview:action];
    
    int sub = 0;
    if ([self isIpad] || IS_IPHONE4) {
        
    } else {
        sub = 40;
    }
    
    self.startButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(action.frame) + sub, self.view.frame.size.width - 40, 50) raised:NO];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    self.startButton.rippleFromTapLocation = YES;
    self.startButton.rippleBeyondBounds = YES;
    [self.startButton addTarget:self action:@selector(scrollToFinals) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.startButton.titleLabel setFont:[UIFont fontWithName:avFont size:16]];
    [view addSubview:self.startButton];

    
    [self.scrollView addSubview:view];
}



- (void)setUpPageThree {
    
    UIImage *header = [UIImage imageNamed:@"header_image"];
    CGFloat ratio = 1/4;
    
    NSString *avFont = AVENIR_BLACK;
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width * 3, 0, viewSize.width, viewHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66)];
    titleView.backgroundColor = BLUE_COLOR;
    // add objects here for nav bar
    
    CGFloat titleHeight = titleView.frame.size.height - 30;
    CGFloat imageWidth = titleHeight *4;
    UIImageView *headerView = [[UIImageView alloc] initWithImage:header];
    headerView.frame = CGRectMake(self.view.frame.size.width/2 - imageWidth/2, 23, imageWidth, titleHeight);

    [titleView addSubview:headerView];
    
    [view addSubview:titleView];
    
    
    UIImageView *firstCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleView.frame) + 10, 100, 100)];
    firstCheck.image = checkBox;
    firstCheck.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:firstCheck];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, CGRectGetMaxY(titleView.frame) + 20, 250, 40)];
    title.text = @"Step One:";
    title.textColor = GREY_COLOR;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = FONT_AMATIC_BOLD(40);
    [view addSubview:title];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, CGRectGetMaxY(title.frame), 200, 30)];
    currentGrade.text = @"Current Grade";
    currentGrade.textColor = GREY_COLOR;
    currentGrade.textAlignment = NSTextAlignmentLeft;
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [view addSubview:currentGrade];
    
    CGFloat boxWidth = self.view.frame.size.width;

    int sub = 0;
    if ([self isIpad] || IS_IPHONE4) {
        
    } else {
        sub = 15;
    }
    
    UIView *instructBox = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(currentGrade.frame) + sub, boxWidth - 30, boxWidth - 80)];
    instructBox.backgroundColor = BLUE_COLOR;
    instructBox.layer.masksToBounds = NO;
    instructBox.layer.cornerRadius = 8;
    instructBox.layer.shadowOffset = CGSizeMake(-10, 15);
    instructBox.layer.shadowRadius = 4;
    instructBox.layer.shadowOpacity = 0.5;
    
    UILabel *instructTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, instructBox.frame.size.width, 50)];
    instructTitle.font = FONT_AMATIC_BOLD(40);
    instructTitle.text = @"Instructions:";
    instructTitle.textColor = [UIColor whiteColor];
    instructTitle.textAlignment = NSTextAlignmentCenter;
    [instructBox addSubview:instructTitle];
    
    
    
    UILabel *instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(instructTitle.frame),
                                                                       instructBox.frame.size.width - 14, instructBox.frame.size.height - CGRectGetMaxY(instructTitle.frame))];
    instructLabel.font = [UIFont fontWithName:avFont size:16];
    instructLabel.textColor = [UIColor whiteColor];
    instructLabel.textAlignment = NSTextAlignmentCenter;
    instructLabel.numberOfLines = 0;
    instructLabel.lineBreakMode = NSLineBreakByWordWrapping;
    instructLabel.text = @"Now you are in the driver’s seat! Grade yourself on each of the 10 life factors. Grade each factor before moving on to the next. Being honest with yourself will produce a more realistic Life+Grade to later work with.";
    [instructBox addSubview:instructLabel];
    [view addSubview:instructBox];

    int ret;
    if ([self isIpad] || IS_IPHONE4) {
        ret = 10;
    } else {
        ret = 40;
    }
  
    self.startButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(instructBox.frame) + ret, self.view.frame.size.width, 50) raised:NO];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.startButton addTarget:self action:@selector(openGradeController) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Start Grading" forState:UIControlStateNormal];
    



     [view addSubview:self.startButton];
    [self.scrollView addSubview:view];
}

- (void)scrollToNextPage {
    
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*2, self.view.frame.origin.y) animated:YES];
    
}


- (void)scrollToFinals {
    
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*3, self.view.frame.origin.y) animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > 321) {
        self.scrollView.scrollEnabled = NO;
    }
    
    CGFloat width = self.scrollView.bounds.size.width;
    currentPage = (self.scrollView.contentOffset.x + width/2.0f) / width;
    self.pageControl.currentPage = currentPage;
}

- (void)dealloc {
    NSLog(@"Opening dealloc");
}

@end
