//
//  GoodBadResponseView.m
//  life-grade
//
//  Created by scott mehus on 12/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "GoodBadResponseView.h"

@implementation GoodBadResponseView {
    NSString *labelString;
}


- (id)initWithFrame:(CGRect)frame andGrade:(Grade *)g andCloseBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        
        
        self.closeBlock = doneBlock;
        self.thisGrade = g;
        [self setupScreen];
    }
    return self;
}

- (void)setupScreen {
    self.backgroundColor = [UIColor whiteColor];

    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 300)];
    [planLabel setFont:FONT_AMATIC_BOLD(18)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = [self getResponse];
    [self addSubview:planLabel];
    
}

- (NSString *)getResponse {
  
    
    if ([self.thisGrade.gradeNum floatValue] < 7.6) {
        return self.thisGrade.badResponse;
    } else {
        return self.thisGrade.goodResponse;
    }
}










@end
