//
//  GoodBadResponseView.h
//  life-grade
//
//  Created by scott mehus on 12/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grade.h"

typedef void (^CloseBlock) (void);

@interface GoodBadResponseView : UIView

@property (nonatomic, strong) CloseBlock closeBlock;
@property (nonatomic, strong) Grade *thisGrade;

- (id)initWithFrame:(CGRect)frame andGrade:(Grade *)g andCloseBlock:(CloseBlock)doneBlock;

@end
