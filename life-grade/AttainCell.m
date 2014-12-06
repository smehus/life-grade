//
//  AttainCell.m
//  life-grade
//
//  Created by scott mehus on 12/6/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AttainCell.h"

@implementation AttainCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self constructView];
        
    }
    return self;
}

- (void)constructView {
    
    self.attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height - 20)];
    self.attributeLabel.text = @"Losersss";
    self.attributeLabel.font = FONT_AMATIC_BOLD(20);
    self.attributeLabel.numberOfLines = 0;
    self.attributeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.attributeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.attributeLabel];
}

@end
