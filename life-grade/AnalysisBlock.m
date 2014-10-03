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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)/2 - 25, self.frame.size.width, 50)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *thefont = AVENIR_BLACK;
    self.titleLabel.font = [UIFont fontWithName:thefont size:12];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    
}

/*
- (void)drawRect:(CGRect)rect {
}
*/

@end
