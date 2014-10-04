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


    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *2, viewSize.height);
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    self.myRevealController = [self revealViewController];
    appDelegate.myRevealController = self.myRevealController;
    [self.view addGestureRecognizer:self.myRevealController.panGestureRecognizer];
    
    [self setUpPageOne];
    [self setUpPageTwo];

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, viewHeight - 50, self.view.frame.size.width - 40, 20)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPageIndicatorTintColor = GREEN_COLOR;
    self.pageControl.pageIndicatorTintColor = GREY_COLOR;

    [self loadshit];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.scrollView];
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
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    
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

    self.title = @"Life+Grade";
    
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    
    self.stepOne = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, view.frame.size.width, 50)];
    self.stepOne.text = @"3 Life Grade Steps";
    self.stepOne.textColor = GREY_COLOR;
    self.stepOne.textAlignment = NSTextAlignmentCenter;
    self.stepOne.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:35];
    [view addSubview:self.stepOne];
    
    UIImageView *firstCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.stepOne.frame) + 20, 75, 75)];
    firstCheck.image = checkBox;
    [view addSubview:firstCheck];
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(100, firstCheck.frame.origin.y + 10, 150, 50)];
    current.text = @"Current Grade";
    current.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [view addSubview:current];
    
    UIImageView *secondCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(current.frame) + 40, 75, 75)];
    secondCheck.image = checkBox;
    [view addSubview:secondCheck];
    
    UILabel *desired = [[UILabel alloc]  initWithFrame:CGRectMake(100, CGRectGetMaxY(current.frame) + 50, 150, 50)];
    desired.text = @"Desired Grade";
    desired.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [view addSubview:desired];
    
    UIImageView *thirdCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(desired.frame) + 40, 75, 75)];
    thirdCheck.image = checkBox;
    [view addSubview:thirdCheck];

    UILabel *action = [[UILabel alloc]  initWithFrame:CGRectMake(100, CGRectGetMaxY(desired.frame) + 50, 150, 50)];
    action.text = @"Action Plan";
    action.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [view addSubview:action];
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(action.frame) + 40, self.view.frame.size.width, 50)];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.startButton addTarget:self action:@selector(openGradeController) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Start Grading" forState:UIControlStateNormal];
    [view addSubview:self.startButton];

    
    [self.scrollView addSubview:view];
}



- (void)setUpPageThree {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width * 2, 0, viewSize.width, viewHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
    title.text = @"Step One: Things to think about";
    title.textColor = GREY_COLOR;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    UIImage *arrowImg = [UIImage imageNamed:@"blue-arrow--"];
    UIImageView *firstArrow = [[UIImageView alloc] initWithImage:arrowImg];
    firstArrow.frame = CGRectMake(20, 25, arrowImg.size.width+20, arrowImg.size.height+20);
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(100, 50, 150, 50)];
    current.text = @"Current Grade";
    current.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    
    UIButton *instructs = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [instructs setTitle:@"Instructions" forState:UIControlStateNormal];
    [instructs setFrame:CGRectMake(10, CGRectGetMaxY(current.frame), self.view.frame.size.width - 20, 50)];
    [[instructs rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"click instructions");
        
        
    }];
  
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 50)];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.startButton addTarget:self action:@selector(openGradeController) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Start Grading" forState:UIControlStateNormal];
    
    [view addSubview:title];
    [view addSubview:firstArrow];
    [view addSubview:current];
    [view addSubview:instructs];
    
     [view addSubview:self.startButton];
    [self.scrollView addSubview:view];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width = self.scrollView.bounds.size.width;
    currentPage = (self.scrollView.contentOffset.x + width/2.0f) / width;
    self.pageControl.currentPage = currentPage;
}

- (void)dealloc {
    NSLog(@"Opening dealloc");
}

@end
