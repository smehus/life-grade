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
        [self setupView];
        
    }
    return self;
}

- (void)setupView {
    
    NSLog(@"SETUPVIEW collection cell");
    

}


@end
