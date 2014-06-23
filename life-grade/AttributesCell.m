//
//  AttributesCell.m
//  life-grade
//
//  Created by scott mehus on 6/22/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AttributesCell.h"

@implementation AttributesCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,44)];
        [self addSubview:self.headerLabel];
        
        
    }
    return self;
}



@end
