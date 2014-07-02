//
//  SignInView.m
//  life-grade
//
//  Created by scott mehus on 7/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SignInView.h"

@implementation SignInView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withBlock:(FinishedBlock)FinishedBlock {
    
    self = [super initWithFrame:frame];
    if (self) {

        self.thisBlock = FinishedBlock;
        [self setupView];
        
        
    }
    return self;
}

- (void)setupView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8f;
    [self addSubview:bgView];
    
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/4, self.frame.size.width, self.frame.size.height*.5)];
    theView.backgroundColor = [UIColor whiteColor];
    [self addSubview:theView];
}



@end
