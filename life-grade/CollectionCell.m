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
            NSLog(@"SETUP CELL");
        [self setupView];
        
    }
    return self;
}



- (void)setupView {
    
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    self.checkmark.image = checkMark;

}


@end
