//
//  SupportTeamView.h
//  life-grade
//
//  Created by scott mehus on 10/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SupportTeamView;
@protocol SupportTeamDelegate <NSObject>

- (void)whyDoINeedSupport;

@end

@interface SupportTeamView : UIView


@property (nonatomic, weak) id<SupportTeamDelegate>delegate;


@property (nonatomic, strong) NSString *gradeLetter;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *currentGrade;
@property (nonatomic, strong) UILabel *firstSupport;
@property (nonatomic, strong) UILabel *secondSupport;
@property (nonatomic, strong) UILabel *thirdSupport;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) BFPaperButton *whySupportButton;




@end
