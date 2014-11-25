//
//  CompletionDateView.h
//  life-grade
//
//  Created by scott mehus on 10/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompletionDateView;
@protocol CompletionDateViewDelegate <NSObject>

- (void)havingTroubleSelected;
- (void)completionNext;

@end

@interface CompletionDateView : UIView

@property (nonatomic, strong) NSString *gradeLetter;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *currentGrade;
@property (nonatomic, strong) UILabel *quoteLabel;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIButton *havingTroubleButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) id<CompletionDateViewDelegate>delegate;
@property (nonatomic, strong) UILabel *completionDateLabel;
@property (nonatomic, strong) UILabel *startDateLabel;

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andGoal:(id)goal;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andQuote:(id)quote;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data attainableQuote:(id)quote;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data isRealstic:(BOOL)isRealistic;


@end
