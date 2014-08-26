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



@interface OpeningViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) SWRevealViewController *myRevealController;
@property (strong, nonatomic) UILabel *LifeLabel;
@property (strong, nonatomic) UILabel *GradeLabel;
@property (nonatomic, strong) UILabel *stepOne;
@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIPageControl *pageControl;


@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@end

@implementation OpeningViewController {
    
    int currentPage;
    CGFloat navBarHeight;
    CGFloat viewHeight;
    CGSize viewSize;
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
    

    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    navBarHeight = self.navigationController.navigationBar.frame.size.height + 20;
    viewHeight = self.view.frame.size.height - navBarHeight;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    viewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - navBarHeight);
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bg];
    
//    UIView *fuckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    fuckView.backgroundColor  = GREEN_COLOR;
//    [self.view addSubview:fuckView];
//   
      self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *3, viewSize.height);
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    self.myRevealController = [self revealViewController];
    [self.view addGestureRecognizer:self.myRevealController.panGestureRecognizer];
    
    [self setUpPageOne];
    [self setUpPageTwo];
    [self setUpPageThree];
    
 
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, viewHeight - 50, self.view.frame.size.width - 40, 20)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPageIndicatorTintColor = GREEN_COLOR;
    self.pageControl.pageIndicatorTintColor = GREY_COLOR;

    
   
   

    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.scrollView];
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
    [self.myRevealController setFrontViewController:navCon];
    
    
//    
//     PickDesiredGradeController *balls = [[PickDesiredGradeController alloc] init];
//    
//    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:balls];
////    [self.myRevealController setFrontViewController:navCon];
//    [self presentViewController:navCon animated:YES completion:nil];
}

- (void)setUpPageOne {
    
    
    // unused
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.LifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 50)];
    self.LifeLabel.textColor = GREY_COLOR;
    self.LifeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat fontSize = self.LifeLabel.font.pointSize;
    self.LifeLabel.frame = CGRectMake(25, 50, 150, fontSize);
    self.LifeLabel.text = @"Life";
    
    UIImage *logo = [UIImage imageNamed:@"life_grade_logo.png"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(0, 75, self.view.frame.size.width, 100);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.GradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.LifeLabel.frame.size.width + 50,
                                                                self.LifeLabel.frame.size.height + 60, 150, 50)];
    self.GradeLabel.textColor = GREY_COLOR
    self.GradeLabel.text = @"Grade";
    self.GradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat gradeSize = self.GradeLabel.font.pointSize;
    self.GradeLabel.frame = CGRectMake(self.LifeLabel.frame.origin.x + 25,
                                       self.LifeLabel.frame.size.height + 60, 320, gradeSize);
    
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signInButton setFrame:CGRectMake(0, CGRectGetMaxY(self.GradeLabel.frame) + 110, self.view.frame.size.width, 30)];
    [signInButton setTitle:@"Already a member?" forState:UIControlStateNormal];
    [signInButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [signInButton addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.scrollView addSubview:signInButton];
//    [self.scrollView addSubview:self.LifeLabel];
//    [self.scrollView addSubview:self.GradeLabel];
    [self.scrollView addSubview:logoView];
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
                [self.revealViewController setFrontViewController:nav];
                
                NSLog(@"SIGNIN SUCCESS");
                
                // Need to set fetched grades from parse
                
                
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

- (void)setUpPageTwo {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width, 0, viewSize.width, viewHeight)];
    view.backgroundColor = [UIColor clearColor];

    
    
    self.stepOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, view.frame.size.width, 50)];
    self.stepOne.text = @"3 Life Grade Steps";
    self.stepOne.textColor = GREY_COLOR;
    self.stepOne.textAlignment = NSTextAlignmentCenter;
    self.stepOne.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:35];
    
    
    UIImage *arrowImg = [UIImage imageNamed:@"blue-arrow--"];
    UIImageView *firstArrow = [[UIImageView alloc] initWithImage:arrowImg];
    firstArrow.frame = CGRectMake(20, 100, arrowImg.size.width, arrowImg.size.height);
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(100, 120, 150, 50)];
    current.text = @"Current Grade";
    current.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    
    UIImageView *secondArrow = [[UIImageView alloc] initWithImage:arrowImg];
    secondArrow.frame = CGRectMake(20, 200, arrowImg.size.width, arrowImg.size.height);

    UILabel *desired = [[UILabel alloc]  initWithFrame:CGRectMake(100, 220, 150, 50)];
    desired.text = @"Desired Grade";
    desired.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
   
   UIImageView *threeArrow = [[UIImageView alloc] initWithImage:arrowImg];
   threeArrow.frame = CGRectMake(20, 300, arrowImg.size.width, arrowImg.size.height);
    
    UILabel *action = [[UILabel alloc]  initWithFrame:CGRectMake(100, 320, 150, 50)];
    action.text = @"Action Plan";
    action.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    
    
    
    
    [view addSubview:firstArrow];
    [view addSubview:current];
    
    [view addSubview:secondArrow];
    [view addSubview:desired];
    
    [view addSubview:threeArrow];
    [view addSubview:action];
    
    [view addSubview:self.stepOne];
    [self.scrollView addSubview:view];
}

- (void)setUpPageThree {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width * 2, 0, viewSize.width, viewHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
    title.text = @"Step One: Things to think about";
    title.textColor = GREY_COLOR;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:35];
    
    UIImage *arrowImg = [UIImage imageNamed:@"blue-arrow--"];
    UIImageView *firstArrow = [[UIImageView alloc] initWithImage:arrowImg];
    firstArrow.frame = CGRectMake(20, 50, arrowImg.size.width, arrowImg.size.height);
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(100, 70, 150, 50)];
    current.text = @"Current Grade";
    current.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    
    UIImageView *secondArrow = [[UIImageView alloc] initWithImage:arrowImg];
    secondArrow.frame = CGRectMake(20, 100, arrowImg.size.width, arrowImg.size.height);
    
    UILabel *desired = [[UILabel alloc]  initWithFrame:CGRectMake(100, 120, 150, 50)];
    desired.text = @"Desired Grade";
    desired.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    
    UIImageView *threeArrow = [[UIImageView alloc] initWithImage:arrowImg];
    threeArrow.frame = CGRectMake(20, 200, arrowImg.size.width, arrowImg.size.height);
    
    UILabel *action = [[UILabel alloc]  initWithFrame:CGRectMake(100, 220, 150, 50)];
    action.text = @"Action Plan";
    action.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 50)];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.startButton addTarget:self action:@selector(openGradeController) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Start Grading" forState:UIControlStateNormal];
    

    
    
    [view addSubview:title];
    
    [view addSubview:firstArrow];
    [view addSubview:current];
    
    [view addSubview:secondArrow];
    [view addSubview:desired];
    
    [view addSubview:threeArrow];
    [view addSubview:action];
    
     [view addSubview:self.startButton];
    [self.scrollView addSubview:view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width = self.scrollView.bounds.size.width;
    currentPage = (self.scrollView.contentOffset.x + width/2.0f) / width;
    self.pageControl.currentPage = currentPage;
}

@end
