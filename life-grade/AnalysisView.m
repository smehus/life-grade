//
//  AnalysisView.m
//  life-grade
//
//  Created by scott mehus on 9/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AnalysisView.h"
#import "MainAppDelegate.h"
#import <MGBoxKit/MGBoxKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Answers.h"
#import "AnalysisBlock.h"
#import "Grade.h"

@implementation AnalysisView {
    
    MainAppDelegate *del;
    float finalGradeNum;
    NSString *fontName;
    UIView *firstView;
    UIView *secondView;
    UIColor *barColour;
    MGBox *container;
    NSArray *dataArray;
    NSString *goalString;
    BOOL imRealistic;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data {
    if (self = [super initWithFrame:frame]) {
        dataArray = data;
        barColour = GREEN_COLOR;
        [self drawFirstTemplate];

        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andGoal:(id)goal {
    if (self = [super initWithFrame:frame]) {
        
        dataArray = data;
        barColour = GREEN_COLOR;
        goalString = goal;
        [self drawSecondTemplate];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data andQuote:(id)quote {
    if (self = [super initWithFrame:frame]) {
        
        dataArray = data;
        barColour = GREEN_COLOR;
        goalString = quote;
        [self drawThirdTemplate];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data attainableQuote:(id)quote {
    if (self = [super initWithFrame:frame]) {
        
        dataArray = data;
        barColour = GREEN_COLOR;
        goalString = quote;
        [self drawAttainable];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)i andData:(NSArray *)data isRealstic:(BOOL)isRealistic {
    if (self = [super initWithFrame:frame]) {
        
        dataArray = data;
        barColour = GREEN_COLOR;
        imRealistic = isRealistic;
        
        [self drawFifthTemplate];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andFinalTips:(NSArray *)tips {
    if (self = [super initWithFrame:frame]) {
        dataArray = tips;
        barColour = GREEN_COLOR;
        [self drawFinalTips];
        
    }
    return self;
}

- (void)drawFirstTemplate {
    NSString *avFont = AVENIR_BLACK;
    
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 175)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 50)];
    currentGrade.text = @"Final Life+Grade";
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    currentGrade.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, CGRectGetMaxY(currentGrade.frame) + 10, 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = FONT_AMATIC_BOLD(48);
    self.gradeLabel.layer.borderWidth = 2.0;
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.cornerRadius = 45;
    self.gradeLabel.clipsToBounds = YES;
    [firstView addSubview:self.gradeLabel];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 20, self.frame.size.width - 40, 44)];
    self.titleLabel.font = FONT_AVENIR_BLACK(16);
    self.titleLabel.text = @"STRENGTHS";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = barColour;
    [self addSubview:self.titleLabel];
    
    container = [MGBox boxWithSize:CGSizeMake(self.size.width, 200)];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width, 150);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self addSubview:container];
    
    for (int i = 0; i < 3; i++) {
        
        Grade *g = dataArray[i];
        NSString *question = g.question;
        
        AnalysisBlock *box = [AnalysisBlock boxWithSize:CGSizeMake(96, 150)];
        box.leftMargin = 5.0f;
        box.rightMargin = 5.0f;
        box.topMargin = 5.0f;
        box.bottomMargin = 5.0f;
        box.backgroundColor = blueC;
        box.layer.borderWidth = 0.0f;
        box.layer.borderColor = barColour.CGColor;
        box.layer.masksToBounds = NO;
        box.layer.shadowOffset = CGSizeMake(-5, 5);
        box.layer.shadowRadius = 5;
        box.layer.shadowOpacity = 0.5;
        box.titleLabel.text = question;
        box.titleLabel.font = FONT_AMATIC_BOLD(24);
        box.onTap = ^{
            NSLog(@"Box Tapped");
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
}

- (void)drawSecondTemplate {
    NSString *avFont = AVENIR_BLACK;
    
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width-40, 40)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    self.currentGrade.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, CGRectGetMaxY(self.currentGrade.frame), 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.borderWidth = 2.0f;
    self.gradeLabel.layer.cornerRadius = 50.0f;
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);
    [firstView addSubview:self.gradeLabel];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width/3, 66)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.text = @"STRENGTHS";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = barColour;
    [self addSubview:self.titleLabel];
    
    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5,
                                                                   self.titleLabel.frame.origin.y,
                                                                   self.frame.size.width - CGRectGetMaxX(self.titleLabel.frame), 66)];
    goalLabel.text = goalString;
    NSString *thefont = AVENIR_BLACK;
    goalLabel.textAlignment = NSTextAlignmentCenter;
    goalLabel.numberOfLines = 0;
    goalLabel.lineBreakMode = NSLineBreakByWordWrapping;
    goalLabel.font = [UIFont fontWithName:thefont size:24];
    [self addSubview:goalLabel];
    
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width - 20, 150)];
    self.quoteLabel.font = [UIFont fontWithName:liteFont size:16];
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    self.quoteLabel.backgroundColor = barColour;
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.quoteLabel];
    
    UILabel *explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.quoteLabel.frame) + 5, self.frame.size.width - 20, 100)];
    explanationLabel.text = @"Having specific goals will help you establish direction & identify exactly what you are trying to accomplish";
    explanationLabel.textAlignment = NSTextAlignmentCenter;
    explanationLabel.backgroundColor = [UIColor clearColor];
    explanationLabel.numberOfLines = 0;
    explanationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    explanationLabel.font = [UIFont fontWithName:liteFont size:16];
    [self addSubview:explanationLabel];
    
}

- (void)drawThirdTemplate {
    
    // GOALS
    NSString *avFont = AVENIR_BLACK;

    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 40, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    self.currentGrade.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, CGRectGetMaxY(self.currentGrade.frame), 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.layer.borderWidth = 2.0f;
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.cornerRadius = 50.0f;
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);
    [firstView addSubview:self.gradeLabel];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.gradeLabel.frame) + 10, self.frame.size.width - 40, 44)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = barColour;
    [self addSubview:self.titleLabel];
    
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width - 20, 100)];
    self.quoteLabel.font = [UIFont fontWithName:liteFont size:16];
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.quoteLabel];
    
    container = [MGBox boxWithSize:CGSizeMake(self.size.width, 200)];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.quoteLabel.frame) + 10, self.frame.size.width, 150);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self addSubview:container];
    
    for (int i = 0; i < 3; i++) {
        
        Grade *g = dataArray[i];
        NSString *question = g.question;
        
        AnalysisBlock *box = [AnalysisBlock boxWithSize:CGSizeMake(96, 150)];
        box.leftMargin = 5.0f;
        box.rightMargin = 5.0f;
        box.topMargin = 5.0f;
        box.bottomMargin = 5.0f;
        box.backgroundColor = blueC;
        box.layer.borderWidth = 0.0f;
        box.layer.borderColor = barColour.CGColor;
        box.layer.masksToBounds = NO;
        box.layer.shadowOffset = CGSizeMake(-5, 5);
        box.layer.shadowRadius = 5;
        box.layer.shadowOpacity = 0.5;
        box.titleLabel.text = question;
        box.onTap = ^{
            NSLog(@"Box Tapped");
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
}

- (void)drawFourthTemplate {
    // TRACKING
    
    NSString *avFont = AVENIR_BLACK;
    
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 75)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width - 40, 44)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = barColour;
    [self addSubview:self.titleLabel];
    
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width - 20, 100)];
    self.quoteLabel.font = [UIFont fontWithName:liteFont size:16];
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.quoteLabel];
    
    self.bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.quoteLabel.frame) + 20, self.frame.size.width - 20, 66)];
    [self.bottomButton setBackgroundColor:blueC];
    
    
    [self addSubview:self.bottomButton];
}

- (void)drawAttainable {
    
    //ATTAINABLEL PAGE
    
    NSString *avFont = AVENIR_BLACK;
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 75)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width - 40, 44)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = barColour;
    [self addSubview:self.titleLabel];
    
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width - 20, 100)];
    self.quoteLabel.font = [UIFont fontWithName:liteFont size:16];
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.quoteLabel];
    
    UIColor *blues = BLUE_COLOR;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.quoteLabel.frame) + 44, self.frame.size.width - 40, 66)];
    [button setBackgroundColor:blues];
    [button setTitle:@"Click for your positive attributes" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:avFont size:16]];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
    }];
    
    
    [self addSubview:button];
}

- (void)drawFifthTemplate {
    
    // REALISTIC PAGE
    
    NSString *avFont = AVENIR_BLACK;
    UIColor *blues = BLUE_COLOR;
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 75)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    
    UIImageView *boxImage = [[UIImageView alloc] initWithImage:checkBox highlightedImage:nil];
    boxImage.frame = CGRectMake(50, CGRectGetMaxY(self.currentGrade.frame) + 20, 50, 50);
    [self addSubview:boxImage];
    
    UIImageView *check = [[UIImageView alloc] initWithImage:checkMark];
    check.frame = CGRectMake(50, boxImage.center.y - 60, 75, 75);
    [self addSubview:check];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(check.frame) + 10, check.frame.origin.y, 200, 30)];
    label.text = @"Your Goal Is Realistic";
    label.font = FONT_AMATIC_BOLD(24);
    [self addSubview:label];
    
    int f = 200;
    
    UIButton *realisticButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - f/2, CGRectGetMaxY(boxImage.frame) + 30, f, f)];
    [realisticButton setTitle:@"Read if your goals are realistic" forState:UIControlStateNormal];
    [realisticButton.titleLabel setNumberOfLines:0];
    [realisticButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [realisticButton setBackgroundColor:blues];
    
    [self addSubview:realisticButton];
    
}

- (void)drawFinalTips {
    
    NSString *avFont = AVENIR_BLACK;
    
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 75)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:self.gradeLabel];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, 200, 50)];
    currentGrade.text = @"Final Life+Grade";
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    UIColor *blueC = BLUE_COLOR;
    NSString *liteFont = LIGHT_FONT;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstView.frame) + 10, self.frame.size.width - 40, 44)];
    self.titleLabel.font = [UIFont fontWithName:liteFont size:24];
    self.titleLabel.text = @"Final Tips";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = blueC;
    [self addSubview:self.titleLabel];
    
    container = [MGBox boxWithSize:CGSizeMake(self.size.width, 200)];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width, 150);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self addSubview:container];
    
    for (int i = 0; i < 3; i++) {
        
        Grade *g = dataArray[i];
        NSString *question = g.question;
        
        AnalysisBlock *box = [AnalysisBlock boxWithSize:CGSizeMake(96, 96)];
        box.leftMargin = 5.0f;
        box.rightMargin = 5.0f;
        box.topMargin = 5.0f;
        box.bottomMargin = 5.0f;
        box.backgroundColor = blueC;
        box.layer.borderWidth = 0.0f;
        box.layer.borderColor = barColour.CGColor;
        box.layer.masksToBounds = NO;
        box.layer.shadowOffset = CGSizeMake(-5, 5);
        box.layer.shadowRadius = 5;
        box.layer.shadowOpacity = 0.5;
        box.titleLabel.text = question;
        box.onTap = ^{
            NSLog(@"Box Tapped");
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
    
    
}


@end
