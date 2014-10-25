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

- (void)constructScreen {
    
    avFont = AVENIR_BLACK;
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 75)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    currentGrade.text = @"Final Life+Grade";
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    UIColor *greens = GREEN_COLOR;
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width - 40, 44)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.text = @"Completion Date";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = blueC;
    [self addSubview:self.titleLabel];
    
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 30,
                                                                    120, 50)];
    startLabel.font = [UIFont fontWithName:avFont size:20];
    startLabel.text = @"Start Date";
    [self addSubview:startLabel];
    
    UILabel *startDate = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame) + 20, startLabel.frame.origin.y,
                                                                    120, 50)];
    startDate.font = [UIFont fontWithName:avFont size:20];
    startDate.text = @"Jan 10 15'";
    startDate.layer.borderColor = [UIColor blackColor].CGColor;
    startDate.layer.borderWidth = 1.0f;
    [self addSubview:startDate];


    
    UILabel *completionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startLabel.frame),
                                                                    120, 50)];
    completionLabel.font = [UIFont fontWithName:avFont size:20];
    completionLabel.text = @"Completion Date";
    [self addSubview:completionLabel];
    
    UILabel *completionDate = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(completionLabel.frame) + 20, completionLabel.frame.origin.y,
                                                                   120, 50)];
    completionDate.font = [UIFont fontWithName:avFont size:20];
    completionDate.text = @"May 10 15'";
    completionDate.layer.borderColor = [UIColor blackColor].CGColor;
    completionDate.layer.borderWidth = 1.0f;
    [self addSubview:completionDate];
    
    CGRect buttonRect = CGRectMake(20, CGRectGetMaxY(completionDate.frame) + 20, self.frame.size.width - 40, 50);
    self.havingTroubleButton = [[BFPaperButton alloc] initWithFrame:buttonRect raised:NO];
    [self.havingTroubleButton setBackgroundColor:blueC];
    [self.havingTroubleButton setTitle:@"Having Trouble Starting?" forState:UIControlStateNormal];
    [[self.havingTroubleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.delegate havingTroubleSelected];
    }];

    [self addSubview:self.havingTroubleButton];
    
    CGRect nextRect = CGRectMake(60, CGRectGetMaxY(self.havingTroubleButton.frame) + 20, self.frame.size.width - 120, 50);
    self.nextButton = [[BFPaperButton alloc] initWithFrame:nextRect raised:NO];
    [self.nextButton setBackgroundColor:greens];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.delegate completionNext];
    }];
    
    [self addSubview:self.nextButton];
    
}


@end
