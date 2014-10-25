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
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 75)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    currentGrade.text = @"Desired Life+Grade";
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    self.firstSupport = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.gradeLabel.frame) + 40, 100, 40)];
    self.firstSupport.text = @"Doug";
    self.firstSupport.layer.borderWidth = 1.0f;
    self.firstSupport.layer.borderColor = greens.CGColor;
    [self addSubview:self.firstSupport];
    
    self.secondSupport = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.firstSupport.frame) + 20, 100, 40)];
    self.secondSupport.text = @"Ralph";
    self.secondSupport.layer.borderWidth = 1.0f;
    self.secondSupport.layer.borderColor = greens.CGColor;
    [self addSubview:self.secondSupport];
    
    self.thirdSupport = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.secondSupport.frame) + 20, 100, 40)];
    self.thirdSupport.text = @"Ralph";
    self.thirdSupport.layer.borderWidth = 1.0f;
    self.thirdSupport.layer.borderColor = greens.CGColor;
    [self addSubview:self.thirdSupport];
    
    UIImage *arrowImg = [UIImage imageNamed:@"Red-arrow-2-"];
    
    UIImageView *firstArrow = [[UIImageView alloc] initWithImage:arrowImg];
    firstArrow.frame = CGRectMake(CGRectGetMaxX(self.firstSupport.frame), self.firstSupport.frame.origin.y, arrowImg.size.width, arrowImg.size.height);
    [self addSubview:firstArrow];
    
    UILabel *supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.secondSupport.frame) + 40, CGRectGetMaxY(self.firstSupport.frame), 100, 100)];
    supportLabel.text = @"Support Team";
    supportLabel.font = FONT_AMATIC_REG(30);
    supportLabel.numberOfLines = 0;
    supportLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:supportLabel];
    
    CGRect whyFrame = CGRectMake(200, CGRectGetMaxY(self.thirdSupport.frame), 100, 100);
    self.whySupportButton = [[BFPaperButton alloc] initWithFrame:whyFrame raised:NO];
    [self.whySupportButton setTitle:@"Why Do I Need Support" forState:UIControlStateNormal];
    [self.whySupportButton setTitleFont:[UIFont fontWithName:avFont size:16]];
    [self.whySupportButton setBackgroundColor:blueC];
    [[self.whySupportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [self addSubview:self.whySupportButton];
    
    CGRect nextRect = CGRectMake(60, CGRectGetMaxY(self.whySupportButton.frame) + 20, self.frame.size.width - 120, 50);
    self.nextButton = [[BFPaperButton alloc] initWithFrame:nextRect raised:NO];
    [self.nextButton setBackgroundColor:greens];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
    }];
    
    [self addSubview:self.nextButton];
    
}

@end
