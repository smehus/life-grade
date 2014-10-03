//
//  AnalysisView.m
//  life-grade
//
//  Created by scott mehus on 9/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AnalysisView.h"
#import "MainAppDelegate.h"
#import <MGBoxKit/MGBoxKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Answers.h"
#import "AnalysisBlock.h"
#import "Grade.h"

@implementation AnalysisView {
    
    MainAppDelegate *del;
    float finalGradeNum;
    NSString *fontName;
    UIView *firstView;
    UIView *secondView;
    UIColor *barColour;
    MGBox *container;
    NSArray *dataArray;
    NSString *goalString;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data {
    if (self = [super initWithFrame:frame]) {
        dataArray = data;
        barColour = GREEN_COLOR;
        [self drawFirstTemplate];

        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andGoal:(id)goal {
    if (self = [super initWithFrame:frame]) {
        
        dataArray = data;
        barColour = GREEN_COLOR;
        goalString = goal;
        [self drawSecondTemplate];
        
    }
    return self;
}

- (void)drawFirstTemplate {
    NSString *avFont = AVENIR_BLACK;
    
    
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
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width - 40, 44)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.text = @"STRENGTHS";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = barColour;
    [self addSubview:self.titleLabel];
    
    container = [MGBox boxWithSize:CGSizeMake(self.size.width, 200)];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width, 150);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self addSubview:container];
    
    for (int i = 0; i < 3; i++) {
        
        Grade *g = dataArray[i];
        NSString *question = g.question;
        
        AnalysisBlock *box = [AnalysisBlock boxWithSize:CGSizeMake(96, 150)];
        box.leftMargin = 5.0f;
        box.rightMargin = 5.0f;
        box.topMargin = 5.0f;
        box.bottomMargin = 5.0f;
        box.backgroundColor = blueC;
        box.layer.borderWidth = 0.0f;
        box.layer.borderColor = barColour.CGColor;
        box.layer.masksToBounds = NO;
        box.layer.shadowOffset = CGSizeMake(-5, 5);
        box.layer.shadowRadius = 5;
        box.layer.shadowOpacity = 0.5;
        box.titleLabel.text = question;
        box.onTap = ^{
            NSLog(@"Box Tapped");
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
}

- (void)drawSecondTemplate {
    NSString *avFont = AVENIR_BLACK;
    
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 75)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width/3, 66)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.text = @"STRENGTHS";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = barColour;
    [self addSubview:self.titleLabel];
    
    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5,
                                                                   self.titleLabel.frame.origin.y,
                                                                   self.frame.size.width - CGRectGetMaxX(self.titleLabel.frame), 66)];
    goalLabel.text = goalString;
    NSString *thefont = AVENIR_BLACK;
    goalLabel.textAlignment = NSTextAlignmentCenter;
    goalLabel.numberOfLines = 0;
    goalLabel.lineBreakMode = NSLineBreakByWordWrapping;
    goalLabel.font = [UIFont fontWithName:thefont size:24];
    [self addSubview:goalLabel];
    
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width - 20, 150)];
    self.quoteLabel.font = [UIFont fontWithName:liteFont size:16];
    self.quoteLabel.text = @"STRENGTHS";
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    self.quoteLabel.backgroundColor = barColour;
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.quoteLabel];
    
    UILabel *explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.quoteLabel.frame) + 5, self.frame.size.width - 20, 100)];
    explanationLabel.text = @"Having specific goals will help you establish direction & identify exactly what you are trying to accomplish";
    explanationLabel.textAlignment = NSTextAlignmentCenter;
    explanationLabel.backgroundColor = [UIColor clearColor];
    explanationLabel.numberOfLines = 0;
    explanationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    explanationLabel.font = [UIFont fontWithName:liteFont size:16];
    [self addSubview:explanationLabel];
    
}


@end
