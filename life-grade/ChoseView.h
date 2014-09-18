//
//  ChoseView.h
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChoseView;
@protocol ChoseViewDelegate <NSObject>

- (void)startPlan;

@end

typedef void (^StartPlan)(void);

@interface ChoseView : UIView

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) id<ChoseViewDelegate>delegate;
@property (nonatomic, strong) StartPlan planBlock;

- (id)initWithFrame:(CGRect)frame completion:(StartPlan)startPlan;

@end
