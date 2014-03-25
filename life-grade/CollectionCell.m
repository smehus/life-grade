//
//  CollectionCell.m
//  SWReveal
//
//  Created by scott mehus on 7/19/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shouldRasterize = YES;
    }
    return self;
}
/*
- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
