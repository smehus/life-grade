//
//  QuestionView.h
//  life-grade
//
//  Created by scott mehus on 3/25/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionView;
@protocol QuestionViewDelegate <NSObject>


- (void)didPickAnswer:(NSIndexPath *)idx;

@end

@interface QuestionView : UIView

@property (nonatomic, strong) id<QuestionViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *theIndexPath;


@end
