//
//  ChecklistViewController.m
//  life-grade
//
//  Created by scott mehus on 9/10/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "ChecklistViewController.h"

@interface ChecklistViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UILabel *stepOne;


@end

@implementation ChecklistViewController {
    int checkedIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithChecklist:(int)index andCompletionBlock:(CompletionBlock)doneBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = doneBlock;
        checkedIndex = index;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Checklist";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpView];

}

- (void)setUpView {
    
    self.title = @"Life+Grade";
    
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    
    self.stepOne = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 50)];
    self.stepOne.text = @"3 Life Grade Steps";
    self.stepOne.textColor = GREY_COLOR;
    self.stepOne.textAlignment = NSTextAlignmentCenter;
    self.stepOne.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:35];
    [self.view addSubview:self.stepOne];
    
    // ***** FIRST CHECK *****\\
    
    UIImageView *firstCheck = [[UIImageView alloc] initWithImage:checkBox];
    firstCheck.frame = CGRectMake(20, CGRectGetMaxY(self.stepOne.frame) + 40, 75, 75);
    [self.view addSubview:firstCheck];
    
    UIImageView *firstMark = [[UIImageView alloc] initWithImage:checkMark];
    firstMark.frame = CGRectMake(20, firstCheck.center.y - 60, 75, 75);
    if (checkedIndex == 0) {
        [self.view addSubview:firstMark];
    }
    
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(100, firstCheck.frame.origin.y + 10, 150, 50)];
    current.text = @"Current Grade";
    current.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [self.view addSubview:current];

    
    // ***** SECOND CHECK ******\\
    
    UIImageView *secondCheck = [[UIImageView alloc] initWithImage:checkBox];
    secondCheck.frame = CGRectMake(20, CGRectGetMaxY(current.frame) + 40, 75, 75);
    [self.view addSubview:secondCheck];
    
    UIImageView *secondMark = [[UIImageView alloc] initWithImage:checkMark];
    secondMark.frame = CGRectMake(20, secondCheck.center.y - 60, 75, 75);
    if (checkedIndex == 1) {
        [self.view addSubview:firstMark];
        [self.view addSubview:secondMark];
    }

    
    UILabel *desired = [[UILabel alloc]  initWithFrame:CGRectMake(100, CGRectGetMaxY(current.frame) + 50, 150, 50)];
    desired.text = @"Desired Grade";
    desired.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [self.view addSubview:desired];
    
    
    
    // ***** THIRD CHECK *****\
    
    UIImageView *thirdCheck = [[UIImageView alloc] initWithImage:checkBox];
    thirdCheck.frame = CGRectMake(20, CGRectGetMaxY(desired.frame) + 40, 75, 75);
    [self.view addSubview:thirdCheck];
    
    UIImageView *thirdMark = [[UIImageView alloc] initWithImage:checkMark];
    thirdMark.frame = CGRectMake(20, thirdCheck.center.y - 60, 75, 75);
    if (checkedIndex == 1) {
        [self.view addSubview:firstMark];
        [self.view addSubview:secondMark];
        [self.view addSubview:thirdMark];
    }

    UILabel *action = [[UILabel alloc]  initWithFrame:CGRectMake(100, CGRectGetMaxY(desired.frame) + 50, 150, 50)];
    action.text = @"Action Plan";
    action.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [self.view addSubview:action];
    
    
    
    
    // ****** NEXT BUTTON ***** \\
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(action.frame) + 40, self.view.frame.size.width, 50)];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.startButton addTarget:self action:@selector(openNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.view addSubview:self.startButton];

}

- (void)openNextView {
    
    self.completionBlock();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
