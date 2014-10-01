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

@implementation AnalysisView {
    
    MainAppDelegate *del;
    float finalGradeNum;
    NSString *fontName;
    UIView *firstView;
    UIView *secondView;
    UIColor *barColour;
    MGBox *container;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i {
    if (self = [super initWithFrame:frame]) {
        
        barColour = GREEN_COLOR;
        
        switch (i) {
            case 0:
                [self drawFirstTemplate];
                break;
            case 1:
                //do things
                break;
            case 2:
                //do things
                break;
            case 3:
                //do things
                break;
            case 4:
                //do things
                break;
            case 5:
                //do things
                break;
            case 6:
                //do things
                break;
            case 7:
                //do things
                break;
                
            default:
                break;
        }
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
    self.gradeLabel.text = @"A";
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    currentGrade.text = @"Final Life+Grade";
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width - 40, 44)];
    titleLabel.font = [UIFont fontWithName:liteFont size:24];
    titleLabel.text = @"STRENGTHS";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = barColour;
    [self addSubview:titleLabel];
    
    container = [MGBox boxWithSize:CGSizeMake(self.size.width, 200)];
    container.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, self.frame.size.width, 150);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self addSubview:container];
    
    for (int i = 0; i < 3; i++) {
        MGBox *box = [MGBox boxWithSize:CGSizeMake(96, 150)];
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
        box.onTap = ^{
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
}


@end
