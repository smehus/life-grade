//
//  QuestionAnswerViewController.m
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "QuestionAnswerViewController.h"
#import "NYSegmentedControl.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import "UIViewController+CWPopup.h"
#import "ChoseView.h"
#import "KLCPopup.h"
#import "BeginGoalViewController.h"
#import "SWRevealViewController.h"
#import "MainAppDelegate.h"
#import "Answers.h"
#import "MBAlertView.h"

@interface QuestionAnswerViewController () <ChoseViewDelegate>

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) ChoseView *choseView;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NYSegmentedControl *fourthControl;
@property (nonatomic, strong) NYSegmentedControl *thirdControl;
@property (nonatomic, strong) NYSegmentedControl *secondControl;
@property (nonatomic, strong) NYSegmentedControl *firstControl;


@end

@implementation QuestionAnswerViewController {
    
    KLCPopup *popup;
    MainAppDelegate *del;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performFetch];
    self.managedObjectContext = del.managedObjectContext;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    [self setTitleView];
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    
    [self setupScreen];
}

- (void)performFetch {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Answers"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answers" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"***CORE_DATA_ERROR*** %@", error);
        
        
        return;
    }
    
    self.fetchedAnswers = [foundObjects lastObject];
    
    NSLog(@"question bitch %@", self.fetchedAnswers);
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupScreen {
    
    NSArray *items = @[@"YES", @"NO"];
    
    NSString *liteFont = LIGHT_FONT;
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
    firstLabel.text = [NSString stringWithFormat:@"I: %@", @"I solved my problem 6 months ago"];
    firstLabel.font = [UIFont fontWithName:liteFont size:24];
    [self.view addSubview:firstLabel];
    
    self.firstControl = [self getSegment];
    self.firstControl.frame = CGRectMake(50, CGRectGetMaxY(firstLabel.frame) + 20, 200, 30);
    [self.view addSubview:self.firstControl];

    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.firstControl.frame) + 20, self.view.frame.size.width, 20)];
    secondLabel.text = [NSString stringWithFormat:@"II: %@", @"I have taken action on my problem within the past 6 months"];
    secondLabel.font = [UIFont fontWithName:liteFont size:24];
    [self.view addSubview:secondLabel];
    
    self.secondControl = [self getSegment];
    self.secondControl.frame = CGRectMake(50, CGRectGetMaxY(secondLabel.frame) + 20, 200, 30);
    [self.view addSubview:self.secondControl];
    
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.secondControl.frame) + 20, self.view.frame.size.width, 20)];
    thirdLabel.text = [NSString stringWithFormat:@"III: %@", @"I am intending to take action in the next month"];
    thirdLabel.font = [UIFont fontWithName:liteFont size:24];
    [self.view addSubview:thirdLabel];
    
    self.thirdControl = [self getSegment];
    self.thirdControl.frame = CGRectMake(50, CGRectGetMaxY(thirdLabel.frame) + 20, 200, 30);
    [self.view addSubview:self.thirdControl];
    
    UILabel *fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.thirdControl.frame) + 20, self.view.frame.size.width, 20)];
    fourthLabel.text = [NSString stringWithFormat:@"III: %@", @"I am intending to take action in the next month"];
    fourthLabel.font = [UIFont fontWithName:liteFont size:24];
    [self.view addSubview:fourthLabel];
    
    self.fourthControl = [self getSegment];
    self.fourthControl.frame = CGRectMake(50, CGRectGetMaxY(fourthLabel.frame) + 20, 200, 30);
    [self.view addSubview:self.fourthControl];
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.fourthControl.frame) + 20, self.view.frame.size.width, 50)];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.startButton addTarget:self action:@selector(openNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.view addSubview:self.startButton];
}

- (NYSegmentedControl *)getSegment {
    
    NYSegmentedControl *segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Yes", @"No"]];
    // Customize and size the control
    segmentedControl.borderWidth = 1.0f;
    segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    segmentedControl.drawsGradientBackground = YES;
    segmentedControl.segmentIndicatorInset = 2.0f;
    segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];;
    segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
    segmentedControl.segmentIndicatorAnimationDuration = 0.3f;
    segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    [segmentedControl sizeToFit];
    
    return segmentedControl;
}

- (void)openNextView {
    
    [self saveAnswers];
    
    if (self.firstControl.selectedSegmentIndex == 0) {
        
        
    } else if (self.firstControl.selectedSegmentIndex == 1
               && self.secondControl.selectedSegmentIndex == 1
               && self.thirdControl.selectedSegmentIndex == 1
               && self.fourthControl.selectedSegmentIndex == 1) {
        
        // do something
        
    }
    
    self.choseView = [[ChoseView alloc] initWithFrame:CGRectMake(30, -300, self.view.frame.size.width-60, self.view.frame.size.height-60) withAnswers:self.fetchedAnswers completion:^{

    }];
    
    self.choseView.clipsToBounds = YES;
    self.choseView.delegate = self;
    popup = [KLCPopup popupWithContentView:self.choseView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup show];
  
}

- (void)startPlan {
    [popup dismissPresentingPopup];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    BeginGoalViewController *controller = [[BeginGoalViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.revealViewController pushFrontViewController:nav animated:YES];

}

- (void)saveAnswers {
    
//    Example - need to edit model
//    self.fetchedAnswers.desiredGrade = [NSNumber numberWithInteger:idx.row];
    
    
    
    self.fetchedAnswers.stageQuestionOne = self.firstControl.selectedSegmentIndex;
    self.fetchedAnswers.stageQuestionTwo = self.secondControl.selectedSegmentIndex;
    self.fetchedAnswers.stageQuestionThree = self.thirdControl.selectedSegmentIndex;
    self.fetchedAnswers.stageQuestionFour = self.fourthControl.selectedSegmentIndex;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
}




@end
