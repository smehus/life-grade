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

        self.userInteractionEnabled = YES;
        self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 25, self.frame.size.width, 50)];
        self.gradeLabel.backgroundColor = [UIColor clearColor];
        self.gradeLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
        self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:48];
        self.gradeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.gradeLabel];
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.nextButton setBackgroundColor:[UIColor greenColor]];
        [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.cellDelegate didPickGrade:self.gradeLabel.text andIndex:self.theIndex];
            
        }];
        [self.nextButton setFrame:CGRectMake(0, CGRectGetMaxY(self.gradeLabel.frame) + 300, 200, 50)];
        [self addSubview:self.nextButton];
        
    }
    return self;
}



@end
