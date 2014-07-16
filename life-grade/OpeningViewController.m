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
    
    
    
//    AttributesViewController *balls = [[AttributesViewController alloc] init];
//    
//    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:balls];
//    [self.myRevealController setFrontViewController:navCon];
}

- (void)setUpPageOne {
    
    
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.LifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 50)];
    self.LifeLabel.textColor = GREY_COLOR;
    self.LifeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat fontSize = self.LifeLabel.font.pointSize;
    self.LifeLabel.frame = CGRectMake(25, 50, 150, fontSize);
    self.LifeLabel.text = @"Life";
    
    self.GradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.LifeLabel.frame.size.width + 50,
                                                                self.LifeLabel.frame.size.height + 60, 150, 50)];
    self.GradeLabel.textColor = GREY_COLOR
    self.GradeLabel.text = @"Grade";
    self.GradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat gradeSize = self.GradeLabel.font.pointSize;
    self.GradeLabel.frame = CGRectMake(self.LifeLabel.frame.origin.x + 25,
                                       self.LifeLabel.frame.size.height + 60, 320, gradeSize);
    
    
    [self.scrollView addSubview:self.LifeLabel];
    [self.scrollView addSubview:self.GradeLabel];
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
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
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
