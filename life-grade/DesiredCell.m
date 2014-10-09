//
//  DesiredCell.m
//  life-grade
//
//  Created by scott mehus on 7/16/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "DesiredCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation DesiredCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        self.userInteractionEnabled = YES;
        self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 25, self.frame.size.width, 50)];
        self.gradeLabel.backgroundColor = [UIColor clearColor];
        self.gradeLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
        self.gradeLabel.font = FONT_AMATIC_BOLD(48);
        self.gradeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.gradeLabel];
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIColor *c = GREEN_COLOR;
        [self.nextButton setBackgroundColor:c];
        [self.nextButton setTitle:@"Select Grade" forState:UIControlStateNormal];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.cellDelegate didPickGrade:self.gradeLabel.text andIndex:self.theIndex];
            
        }];
        [self.nextButton setFrame:CGRectMake(10, CGRectGetMaxY(self.gradeLabel.frame) + 300, screenWidth - 20, 50)];
        [self addSubview:self.nextButton];
        
    }
    return self;
}



@end
