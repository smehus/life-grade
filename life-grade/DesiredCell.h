//
//  DesiredCell.h
//  life-grade
//
//  Created by scott mehus on 7/16/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesiredCell;
@protocol DesiredCellDelegate <NSObject>

- (void)didPickGrade:(NSString *)grade andIndex:(NSIndexPath *)idx;

@end

@interface DesiredCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, weak) id<DesiredCellDelegate> cellDelegate;
@property (nonatomic, strong) NSIndexPath *theIndex;

@end
