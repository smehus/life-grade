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
        
        int sub = 0;
        if ([self isIpad] || IS_IPHONE4) {
            sub = 225;
        } else {
            sub = 300;
        }
        
        [self.nextButton setFrame:CGRectMake(10, CGRectGetMaxY(self.gradeLabel.frame) + sub, screenWidth - 20, 50)];
        [self addSubview:self.nextButton];
        
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

- (void)setLargeFrame {
    
    self.gradeLabel.frame = CGRectMake(self.frame.size.width/2 - 100, 150, 200, 200);
    self.gradeLabel.font = FONT_AMATIC_BOLD(150);
    
    
}

- (void)setSmallFrame {
    
    self.gradeLabel.frame = CGRectMake(0, self.frame.size.height/2 - 25, self.frame.size.width, 50);
    self.gradeLabel.font = FONT_AMATIC_BOLD(48);
}


@end
