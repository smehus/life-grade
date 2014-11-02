//
//  ChoseView.m
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "ChoseView.h"

@implementation ChoseView {
    Answers *fetchedAnswer;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupScreen];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withAnswers:(Answers *)answer  completion:(StartPlan)startPlan {
    if (self = [super initWithFrame:frame]) {
        fetchedAnswer = answer;
        self.planBlock = startPlan;
        [self setupScreen];
    }
    return self;
}

- (void)setupScreen {
    self.backgroundColor = [UIColor whiteColor];
    NSString *font = LIGHT_FONT;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width -20, 100)];
    [titleLabel setFont:FONT_AVENIR_BLACK(14)];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"You chose to focus on: ";
    [self addSubview:titleLabel];
    
    
    UILabel *focusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, self.frame.size.width - 20, 75)];
     [focusLabel setFont:FONT_AMATIC_REG(36)];
    focusLabel.numberOfLines = 0;
    focusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    focusLabel.textAlignment = NSTextAlignmentCenter;
    focusLabel.text = fetchedAnswer.focusFactor;
    
    NSMutableAttributedString *mat = [focusLabel.attributedText mutableCopy];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    focusLabel.attributedText = mat;
    [self addSubview:focusLabel];
    
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(focusLabel.frame) + 10, self.frame.size.width - 20, 100)];
    [planLabel setFont:[UIFont fontWithName:font size:24]];
    planLabel.numberOfLines = 0;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Lets work on making a plan!";
    [self addSubview:planLabel];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(planLabel.frame) + 30 ,self.frame.size.width - 20, 50)];
    [nextButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"Start Plan" forState:UIControlStateNormal];
    
    [self addSubview:nextButton];
}

- (void)nextButtonPressed {
//    self.planBlock();
    [self.delegate startPlan];
}

@end
