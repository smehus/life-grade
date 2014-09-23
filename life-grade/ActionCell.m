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
        self.factorLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 25, self.frame.size.width - 10, 75)];
        self.factorLabel.backgroundColor = [UIColor clearColor];
        self.factorLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
        self.factorLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
        self.factorLabel.textAlignment = NSTextAlignmentCenter;
        self.factorLabel.numberOfLines = 0;
        self.factorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.factorLabel];
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.nextButton setBackgroundColor:g];
        [self.nextButton setTitle:@"Select Grade" forState:UIControlStateNormal];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.cellDelegate didPickFactor:self.grade andIndex:self.theIndex];
            
        }];
        [self.nextButton setFrame:CGRectMake(10, CGRectGetMaxY(self.factorLabel.frame) + 300, screenWidth - 20, 50)];
        [self addSubview:self.nextButton];
        
    }
    return self;
}

@end
