//
//  QuestionView.h
//  life-grade
//
//  Created by scott mehus on 3/25/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grade.h"

@class QuestionView;
@protocol QuestionViewDelegate <NSObject>


- (void)didPickAnswer:(NSIndexPath *)idx;

@end

@interface QuestionView : UIView

@property (nonatomic, strong) id<QuestionViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *theIndexPath;
@property (nonatomic, strong) Grade *grade;

- (id)initWithFrame:(CGRect)frame withQuestion:(Grade *)grade;
@end
