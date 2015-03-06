//
//  CompletionDateView.m
//  life-grade
//
//  Created by scott mehus on 10/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "CompletionDateView.h"
#import "MainAppDelegate.h"
#import "BFPaperButton.h"

@implementation CompletionDateView {
    
    MainAppDelegate *del;
    float finalGradeNum;
    NSString *fontName;
    UIView *firstView;
    UIColor *barColour;
    NSString *avFont;

}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        barColour = GREEN_COLOR;
        [self constructScreen];
        
        
    }
    return self;
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

- (void)constructScreen {
    
    avFont = AVENIR_BLACK;
    int firstViewHeight = 0;
    int ttlY = 0;
    int ret = 0;
    if ([self isIpad] || IS_IPHONE4) {
        firstViewHeight = 130;
        ttlY = 0;
        ret = 5;
    } else {
        firstViewHeight = 150;
        ttlY = 10;
        ret = 20;
    }
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(10, ttlY, self.frame.size.width-20, 50)];
    currentGrade.text = @"Desired Life+Grade";
    currentGrade.textAlignment = NSTextAlignmentCenter;
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, CGRectGetMaxY(currentGrade.frame), 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.layer.borderWidth = 2.0f;
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.cornerRadius = 50.0f;
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);


    [firstView addSubview:self.gradeLabel];
    
    UIColor *greens = GREEN_COLOR;
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.gradeLabel.frame) + ttlY, self.frame.size.width - 40, 44)];
//    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.font = FONT_AMATIC_BOLD(24);
    self.titleLabel.text = @"My Important Dates";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = blueC;
    [self addSubview:self.titleLabel];
    
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 30,
                                                                    120, 50)];
    startLabel.font = FONT_AVENIR_BLACK(18);
    startLabel.text = @"Start Date";
    [self addSubview:startLabel];
    
    self.startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame) + 20, startLabel.frame.origin.y,
                                                                    120, 50)];
    self.startDateLabel.font = [UIFont fontWithName:avFont size:20];
    self.startDateLabel.text = @"";
    self.startDateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.startDateLabel.layer.borderWidth = 1.0f;
    self.startDateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.startDateLabel];


    
    UILabel *completionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startLabel.frame),
                                                                    120, 50)];
    completionLabel.font = FONT_AVENIR_BLACK(18);
    completionLabel.text = @"Completion Date";
    completionLabel.numberOfLines = 0;
    completionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:completionLabel];
    
    self.completionDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(completionLabel.frame) + 20, completionLabel.frame.origin.y,
                                                                   120, 50)];
    self.completionDateLabel.font = [UIFont fontWithName:avFont size:20];
    self.completionDateLabel.text = @"";
    self.completionDateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.completionDateLabel.layer.borderWidth = 1.0f;
    self.completionDateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.completionDateLabel];
    
    CGRect buttonRect = CGRectMake(20, CGRectGetMaxY(self.completionDateLabel.frame) + ret, self.frame.size.width - 40, 50);
    self.havingTroubleButton = [[BFPaperButton alloc] initWithFrame:buttonRect raised:NO];
    [self.havingTroubleButton setBackgroundColor:blueC];
    [self.havingTroubleButton setTitle:@"Having Trouble Starting?" forState:UIControlStateNormal];
    [[self.havingTroubleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.delegate havingTroubleSelected];
    }];

    [self addSubview:self.havingTroubleButton];
    
    /*
    CGRect nextRect = CGRectMake(20, CGRectGetMaxY(self.havingTroubleButton.frame) + 20, self.frame.size.width - 40, 50);
    self.nextButton = [[BFPaperButton alloc] initWithFrame:nextRect raised:NO];
    [self.nextButton setBackgroundColor:greens];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.delegate completionNext];
    }];
    
    [self addSubview:self.nextButton];
    */
}


@end
