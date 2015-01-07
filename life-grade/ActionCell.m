//
//  ActionCell.m
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "ActionCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ActionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIColor *g = GREEN_COLOR;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        self.userInteractionEnabled = YES;
        self.factorLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 80, self.frame.size.width - 10, 150)];
        self.factorLabel.backgroundColor = [UIColor clearColor];
        self.factorLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
        self.factorLabel.font = FONT_AMATIC_REG(30);
        self.factorLabel.textAlignment = NSTextAlignmentCenter;
        self.factorLabel.numberOfLines = 0;
        self.factorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.factorLabel];
        
        int sub = 0;
        if ([self isIpad]) {
            sub = 175;
        } else {
            sub = 250;
        }
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.nextButton setBackgroundColor:g];
        [self.nextButton setTitle:@"Select Grade" forState:UIControlStateNormal];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.cellDelegate didPickFactor:self.grade andIndex:self.theIndex];
            
        }];
        [self.nextButton setFrame:CGRectMake(10, CGRectGetMaxY(self.factorLabel.frame) + sub, screenWidth - 20, 50)];
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

- (void)drawSmallLayout {
    
    self.factorLabel.frame = CGRectMake(5, self.frame.size.height/2 - 25, self.frame.size.width - 10, 100);
    self.factorLabel.font = FONT_AMATIC_REG(30);
    
}

- (void)drawLargeLayout {
    
    
    self.factorLabel.frame = CGRectMake(5, self.frame.size.height/3, self.frame.size.width - 10, 100);
    self.factorLabel.font = FONT_AMATIC_BOLD(45);
}









@end
