//
//  SimpleCoverFlowLayout.m
//  life-grade
//
//  Created by scott mehus on 3/27/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SimpleCoverFlowLayout.h"

@implementation SimpleCoverFlowLayout

- (id)init {
    if ((self = [super init])) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 10.0f;
    }
    return self;
}

@end
