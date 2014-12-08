//
//  AnalysisView.h
//  life-grade
//
//  Created by scott mehus on 9/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grade.h"
#import "ProgressMethods.h"

@class AnalysisView;
@protocol AnalysisViewDelegate <NSObject>

- (void)openPopUpWithGrade:(Grade *)g;
- (void)openTrackingProgressPopUp:(NSInteger)i withMethod:(ProgressMethods *)method;
- (void)openAttributes;
- (void)openRealisticPopup;
@end

@interface AnalysisView : UIView

@property (nonatomic, strong) NSString *gradeLetter;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *currentGrade;
@property (nonatomic, strong) UILabel *quoteLabel;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) id<AnalysisViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *progressMethods;


- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andGoal:(id)goal;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andQuote:(id)quote;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data attainableQuote:(id)quote;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data isRealstic:(BOOL)isRealistic;
- (id)initWithFrame:(CGRect)frame andFinalTips:(NSArray *)tips;

@end
