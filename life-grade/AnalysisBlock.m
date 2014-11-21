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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.5, CGRectGetMaxY(self.frame)/2 - 75, self.frame.size.width - 2.5, 150)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    
}

/*
- (void)drawRect:(CGRect)rect {
}
*/

@end
