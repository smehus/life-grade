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

@interface QuestionAnswerViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) ChoseView *choseView;;


@end

@implementation QuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    
    [self setupScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupScreen {
    
    NSArray *items = @[@"YES", @"NO"];
    
    NSString *liteFont = LIGHT_FONT;
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
    firstLabel.text = [NSString stringWithFormat:@"I: %@", @"This is the first"];
    firstLabel.font = [UIFont fontWithName:liteFont size:30];
    [self.view addSubview:firstLabel];
    
    NYSegmentedControl *firstControl = [self getSegment];
    firstControl.frame = CGRectMake(50, CGRectGetMaxY(firstLabel.frame) + 40, 200, 50);
    [self.view addSubview:firstControl];

    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLabel.frame) + 100, self.view.frame.size.width, 30)];
    secondLabel.text = [NSString stringWithFormat:@"II: %@", @"This is the second"];
    secondLabel.font = [UIFont fontWithName:liteFont size:30];
    [self.view addSubview:secondLabel];
    
    NYSegmentedControl *secondControl = [self getSegment];
    secondControl.frame = CGRectMake(50, CGRectGetMaxY(secondLabel.frame) + 40, 200, 50);
    [self.view addSubview:secondControl];
    
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondLabel.frame) + 100, self.view.frame.size.width, 30)];
    thirdLabel.text = [NSString stringWithFormat:@"III: %@", @"This is the third"];
    thirdLabel.font = [UIFont fontWithName:liteFont size:30];
    [self.view addSubview:thirdLabel];
    
    NYSegmentedControl *thirdControl = [self getSegment];
    thirdControl.frame = CGRectMake(50, CGRectGetMaxY(thirdLabel.frame) + 40, 200, 50);
    [self.view addSubview:thirdControl];
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thirdControl.frame) + 20, self.view.frame.size.width, 50)];
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
    
    self.choseView = [[ChoseView alloc] initWithFrame:CGRectMake(30, -300, self.view.frame.size.width-60, self.view.frame.size.height-60)];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:self.choseView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup show];
    

    
    
}



@end
