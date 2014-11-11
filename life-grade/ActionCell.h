//
//  ActionCell.h
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grade.h"

@class ActionCell;
@protocol ActionCellDelegate <NSObject>

- (void)didPickFactor:(Grade *)grade andIndex:(NSIndexPath *)idx;

@end

@interface ActionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *factorLabel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, weak) id<ActionCellDelegate> cellDelegate;
@property (nonatomic, strong) NSIndexPath *theIndex;
@property (nonatomic, strong) Grade *grade;

- (void)drawSmallLayout;
- (void)drawLargeLayout;

@end
