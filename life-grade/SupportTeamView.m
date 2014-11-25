//
//  SupportTeamView.m
//  life-grade
//
//  Created by scott mehus on 10/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SupportTeamView.h"
#import "MainAppDelegate.h"

@implementation SupportTeamView {
    
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
    UIColor *greens = GREEN_COLOR;
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 30)];
    currentGrade.text = @"Desired Life+Grade";
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    currentGrade.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, CGRectGetMaxY(currentGrade.frame) + 5, 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.borderWidth = 2.0f;
    self.gradeLabel.layer.cornerRadius = 50.0f;
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);
    [firstView addSubview:self.gradeLabel];
    
    self.firstSupport = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.gradeLabel.frame) + 10, 110, 40)];
    self.firstSupport.text = @"";
    self.firstSupport.layer.borderWidth = 1.0f;
    self.firstSupport.layer.borderColor = greens.CGColor;
    self.firstSupport.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.firstSupport];
    
    self.secondSupport = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.firstSupport.frame) + 30, 110, 40)];
    self.secondSupport.text = @"";
    self.secondSupport.layer.borderWidth = 1.0f;
    self.secondSupport.layer.borderColor = greens.CGColor;
    self.secondSupport.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.secondSupport];
    
    self.thirdSupport = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.secondSupport.frame) + 30, 110, 40)];
    self.thirdSupport.text = @"";
    self.thirdSupport.layer.borderWidth = 1.0f;
    self.thirdSupport.layer.borderColor = greens.CGColor;
    self.thirdSupport.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.thirdSupport];
    
    UIImage *arrowImg = [UIImage imageNamed:@"Red-arrow-2-"];
    UIImage *upArrow = [UIImage imageNamed:@"red-arrow-up"];
    
    UIImageView *firstArrow = [[UIImageView alloc] initWithImage:arrowImg];
    firstArrow.frame = CGRectMake(CGRectGetMaxX(self.firstSupport.frame), self.firstSupport.frame.origin.y, arrowImg.size.width, arrowImg.size.height);
    [self addSubview:firstArrow];
    
    UIImageView *secondArrow = [[UIImageView alloc] initWithImage:upArrow];
    secondArrow.frame = CGRectMake(CGRectGetMaxX(self.thirdSupport.frame), self.thirdSupport.frame.origin.y - 40, arrowImg.size.width, arrowImg.size.height);
    [self addSubview:secondArrow];
    
    UILabel *supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.secondSupport.frame) + 60, CGRectGetMaxY(self.firstSupport.frame), 100, 100)];
    supportLabel.text = @"Support Team";
    supportLabel.font = FONT_AMATIC_REG(30);
    supportLabel.numberOfLines = 0;
    supportLabel.lineBreakMode = NSLineBreakByWordWrapping;
    supportLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:supportLabel];
    
    CGRect whyFrame = CGRectMake(150, CGRectGetMaxY(self.thirdSupport.frame), 150, 75);
    self.whySupportButton = [[BFPaperButton alloc] initWithFrame:whyFrame raised:NO];
    [self.whySupportButton setTitle:@"Why Do I Need Support?" forState:UIControlStateNormal];
    [self.whySupportButton setTitleFont:FONT_AVENIR_BLACK(16)];
    [self.whySupportButton.titleLabel setNumberOfLines:0];
    [self.whySupportButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.whySupportButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.whySupportButton setBackgroundColor:blueC];
    [[self.whySupportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [self addSubview:self.whySupportButton];
    
    CGRect nextRect = CGRectMake(20, CGRectGetMaxY(self.whySupportButton.frame) + 20, self.frame.size.width - 40, 50);
    self.nextButton = [[BFPaperButton alloc] initWithFrame:nextRect raised:NO];
    [self.nextButton setBackgroundColor:greens];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
    }];
    
    [self addSubview:self.nextButton];
    
}

@end
