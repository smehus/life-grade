//
//  DesiredCell.m
//  life-grade
//
//  Created by scott mehus on 7/16/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "DesiredCell.h"

@implementation DesiredCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50)];
        self.gradeLabel.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:self.gradeLabel];
        
        
    }
    return self;
}



@end
