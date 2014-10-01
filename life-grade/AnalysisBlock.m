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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 50)];
    [self addSubview:self.titleLabel];
    
}

/*
- (void)drawRect:(CGRect)rect {
}
*/

@end
