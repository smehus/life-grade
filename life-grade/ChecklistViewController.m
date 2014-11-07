//
//  ChecklistViewController.m
//  life-grade
//
//  Created by scott mehus on 9/10/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "ChecklistViewController.h"

@interface ChecklistViewController ()

@property (nonatomic, strong) BFPaperButton *startButton;
@property (nonatomic, strong) UILabel *stepOne;


@end

@implementation ChecklistViewController {
    int checkedIndex;
    CGFloat viewHeight;
    CGSize viewSize;
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
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bg];

    
//    [self setUpView];
    [self setUpView];
    
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

- (void)setUpView {
    
    [self setTitleView];
    
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    NSString *avFont = AVENIR_BLACK;
    
    self.stepOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.stepOne.text = @"3 Life Grade Steps";
    self.stepOne.textColor = GREY_COLOR;
    self.stepOne.backgroundColor = GREEN_COLOR;
    self.stepOne.textAlignment = NSTextAlignmentCenter;
    self.stepOne.font = [UIFont fontWithName:avFont size:25];
    [self.view addSubview:self.stepOne];
    
    // ***** FIRST CHECK *****\\
    
    UIImageView *firstCheck = [[UIImageView alloc] initWithImage:checkBox];
    firstCheck.frame = CGRectMake(20, CGRectGetMaxY(self.stepOne.frame) + 40, 75, 75);
    firstCheck.contentMode = UIViewContentModeScaleAspectFit;;
    [self.view addSubview:firstCheck];
    
    UIImageView *firstMark = [[UIImageView alloc] initWithImage:checkMark];
    firstMark.frame = CGRectMake(20, firstCheck.center.y - 60, 75, 75);
    if (checkedIndex == 0) {
        [self.view addSubview:firstMark];
    }
    
    UILabel *romanUno = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, firstCheck.frame.origin.y - 8, 40, 75)];
    romanUno.text = @"I:";
    romanUno.font = FONT_AMATIC_BOLD(40);
    [self.view addSubview:romanUno];
    
    
    UILabel *current = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(romanUno.frame), romanUno.frame.origin.y, 150, 75)];
    current.text = @"Current Grade";
    current.font = FONT_AMATIC_BOLD(40);
    [self.view addSubview:current];

    
    // ***** SECOND CHECK ******\\
    
    UIImageView *secondCheck = [[UIImageView alloc] initWithImage:checkBox];
    secondCheck.frame = CGRectMake(20, CGRectGetMaxY(current.frame) + 37, 75, 75);
    secondCheck.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:secondCheck];
    
    UIImageView *secondMark = [[UIImageView alloc] initWithImage:checkMark];
    secondMark.frame = CGRectMake(20, secondCheck.center.y - 60, 75, 75);
    if (checkedIndex == 1) {
        [self.view addSubview:firstMark];
        [self.view addSubview:secondMark];
    }

    UILabel *romanDos = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondCheck.frame) + 5, secondCheck.frame.origin.y -8, 40, 75)];
    romanDos.text = @"II:";
    romanDos.font = FONT_AMATIC_BOLD(40);
    [self.view addSubview:romanDos];
    
    
    UILabel *desired = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(romanDos.frame) + 10, CGRectGetMaxY(current.frame) + 50, 150, 50)];
    desired.text = @"Desired Grade";
    desired.font = FONT_AMATIC_BOLD(40);
    [self.view addSubview:desired];
    
    
    
    // ***** THIRD CHECK *****\
    
    UIImageView *thirdCheck = [[UIImageView alloc] initWithImage:checkBox];
    thirdCheck.frame = CGRectMake(20, CGRectGetMaxY(desired.frame) + 35, 75, 75);
    thirdCheck.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:thirdCheck];
    
    UIImageView *thirdMark = [[UIImageView alloc] initWithImage:checkMark];
    thirdMark.frame = CGRectMake(20, thirdCheck.center.y - 60, 75, 75);
    if (checkedIndex == 2) {
        [self.view addSubview:firstMark];
        [self.view addSubview:secondMark];
        [self.view addSubview:thirdMark];
    }
    
    UILabel *romanTres = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdCheck.frame) + 5, thirdCheck.frame.origin.y - 8, 40, 75)];
    romanTres.text = @"III:";
    romanTres.font = FONT_AMATIC_BOLD(40);
    [self.view addSubview:romanTres];


    UILabel *action = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(romanTres.frame) + 10, CGRectGetMaxY(desired.frame) + 50, 150, 50)];
    action.text = @"Action Plan";
    action.font = FONT_AMATIC_BOLD(40);
    [self.view addSubview:action];
    
    
    
    
    // ****** NEXT BUTTON ***** \\
    
    self.startButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(action.frame) + 40, self.view.frame.size.width - 40, 50)];
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
