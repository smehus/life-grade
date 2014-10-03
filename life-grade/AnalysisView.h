//
//  AnalysisView.h
//  life-grade
//
//  Created by scott mehus on 9/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisView : UIView

@property (nonatomic, strong) NSString *gradeLetter;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *currentGrade;
@property (nonatomic, strong) UILabel *quoteLabel;

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data;
- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andGoal:(id)goal;



@end
