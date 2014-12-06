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
typedef void (^RealisticBlock) (NSString *specificGoal);

@interface GoodBadResponseView : UIView <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CloseBlock closeBlock;
@property (nonatomic, strong) RealisticBlock realisticBlock;
@property (nonatomic, strong) Grade *thisGrade;
@property (nonatomic, strong) UITextField *specificLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

- (id)initWithFrame:(CGRect)frame andGrade:(Grade *)g andCloseBlock:(CloseBlock)doneBlock;
- (id)initForRealisticwithFrame:(CGRect)frame andRealisticGoal:(RealisticBlock)doneBlock;
- (id)initForConfidenceAndFrame:(CGRect)frame andRealisticGoal:(CloseBlock)doneBlock;
- (id)initForQuestionsAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock;
- (id)initForTrackingAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock;
- (id)initForAttributesAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock;

@end
