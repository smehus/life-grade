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

@implementation ChecklistViewController

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
    
    
    self.stepOne = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 50)];
    self.stepOne.text = @"3 Life Grade Steps";
    self.stepOne.textColor = GREY_COLOR;
    self.stepOne.textAlignment = NSTextAlignmentCenter;
    self.stepOne.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:35];
    [self.view addSubview:self.stepOne];
    
    UIView *firstCheck = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.stepOne.frame) + 40, 50, 50)];
    firstCheck.layer.borderColor = [UIColor lightGrayColor].CGColor;
    firstCheck.layer.borderWidth = 3.0f;
    [self.view addSubview:firstCheck];
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(100, firstCheck.frame.origin.y, 150, 50)];
    current.text = @"Current Grade";
    current.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [self.view addSubview:current];
    
    UIView *secondCheck = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(current.frame) + 40, 50, 50)];
    secondCheck.layer.borderColor = [UIColor lightGrayColor].CGColor;
    secondCheck.layer.borderWidth = 3.0f;
    [self.view addSubview:secondCheck];
    
    UILabel *desired = [[UILabel alloc]  initWithFrame:CGRectMake(100, CGRectGetMaxY(current.frame) + 40, 150, 50)];
    desired.text = @"Desired Grade";
    desired.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [self.view addSubview:desired];
    
    UIView *thirdCheck = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(desired.frame) + 40, 50, 50)];
    thirdCheck.layer.borderColor = [UIColor lightGrayColor].CGColor;
    thirdCheck.layer.borderWidth = 3.0f;
    [self.view addSubview:thirdCheck];
    
    UILabel *action = [[UILabel alloc]  initWithFrame:CGRectMake(100, CGRectGetMaxY(desired.frame) + 40, 150, 50)];
    action.text = @"Action Plan";
    action.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    [self.view addSubview:action];
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(action.frame) + 40, self.view.frame.size.width, 50)];
    [self.startButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.startButton addTarget:self action:@selector(openNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Start Grading" forState:UIControlStateNormal];
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
