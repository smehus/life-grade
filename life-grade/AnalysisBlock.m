//
//  AnalysisBlock.m
//  life-grade
//
//  Created by Paddy on 10/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AnalysisBlock.h"

@implementation AnalysisBlock

- (void)setup {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.5, CGRectGetMaxY(self.frame)/2 - 100, self.frame.size.width - 2.5, 150)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    
    UILabel *clickLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.frame) - 40, self.frame.size.width-10, 30)];
    clickLabel.textAlignment = NSTextAlignmentCenter;
    clickLabel.text = @"CLICK";
    clickLabel.font = FONT_AMATIC_BOLD(16);
    clickLabel.textColor = [UIColor whiteColor];
    [self addSubview:clickLabel];
    
}

/*
- (void)drawRect:(CGRect)rect {
}
*/

@end
