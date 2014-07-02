//
//  SignInView.h
//  life-grade
//
//  Created by scott mehus on 7/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishedBlock) (NSString *email, NSString *password);

@interface SignInView : UIView

@property (nonatomic, strong) FinishedBlock thisBlock;

- (id)initWithFrame:(CGRect)frame withBlock:(FinishedBlock)FinishedBlock;

@end
