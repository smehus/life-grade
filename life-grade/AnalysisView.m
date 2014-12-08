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
#import "ProgressMethods.h"

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


// dont use?
- (void)fetchQuestions {
    
    self.questions = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *ary = [dict objectForKey:@"questions"];
    [ary enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        Grade *grade = [[Grade alloc] init];
        grade.question = obj[@"question"];
        grade.goodResponse = obj[@"goodResponse"];
        
        grade.badResponse = obj[@"badResponse"];
        [self.questions addObject:grade];
        
        
        
    }];
}

- (void)drawTrackingProgress {
    
    
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
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);
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
            
            [self.delegate openPopUpWithGrade:g];
            
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
    explanationLabel.text = @"Having specific goals will help you establish direction and identify exactly what you are trying to accomplish.";
    explanationLabel.textAlignment = NSTextAlignmentCenter;
    explanationLabel.backgroundColor = [UIColor clearColor];
    explanationLabel.numberOfLines = 0;
    explanationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    explanationLabel.font = [UIFont fontWithName:liteFont size:16];
    [self addSubview:explanationLabel];
    
}

#pragma mark - Tracking Progress I Think

- (void)drawThirdTemplate {
    
    [self addMethods];
    
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
    
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width - 20, 80)];
    self.quoteLabel.font = [UIFont fontWithName:liteFont size:16];
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.quoteLabel];
    
    container = [MGBox boxWithSize:CGSizeMake(self.size.width, 200)];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.quoteLabel.frame), self.frame.size.width, 150);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self addSubview:container];
    
    for (int i = 0; i < 3; i++) {
        
        NSString *g = dataArray[i];
        
        
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
        box.titleLabel.text = g;
        box.titleLabel.font = FONT_AMATIC_BOLD(24);
        box.titleLabel.numberOfLines = 0;
        box.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        box.onTap = ^{
            NSLog(@"Box Tapped");
          
            // loop through self.progress methods and find the right method
            
            
            // i need the text of the description here
        
            [self.delegate openTrackingProgressPopUp:i];
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
}




/*
- (void)addArraything
{
    
    
    
    
    @"Track My Patterns"
    
    
    @"Make 'Task' and 'To Do' Lists"
    
    
    @"Post reminders in Workplace"
    
    
    @"Journal or blog about it"
    
    
    @"Utilize a Calendar"
    
    
    @"Make Mini Goals"
    
    
    @"Use An App On Your Phone"
    
    
    @"Find a Professional"
    
    
    @"One Week Summary Worksheet"
    
    
    @"Track My Behaviors"
    
    
    @"Try One New Thing Hobby Journal"
    
    
    @"Food and/or Exercise Diary" andKey:@"Physical Health"];
    
    
    @"“My Needs” Worksheet" andKey:@"Genuine, Intimate, and Deep Relationships"];
    
    
    @"Who’s Got My Back Worksheet" andKey:@"Social Support & Social Networks"];
    
    
    @"Contribution Bucket List Activity" andKey:@"Contribution & Giving Back"];
    
    
    @"Thought Countering Worksheet" andKey:@"Positive Thinking"];
    
    
}
*/
- (void)drawFourthTemplate {
    // TRACKING
    
    NSString *avFont = AVENIR_BLACK;
    
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 40, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, CGRectGetMaxY(self.currentGrade.frame), 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);
    [firstView addSubview:self.gradeLabel];
    
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
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width-40, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    self.currentGrade.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 -50, CGRectGetMaxY(self.currentGrade.frame), 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.borderWidth = 2.0;
    self.gradeLabel.layer.cornerRadius = 50.0f;
    self.gradeLabel.textColor = [UIColor redColor];
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
    
    UIColor *blues = BLUE_COLOR;
    
    BFPaperButton *button = [[BFPaperButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.quoteLabel.frame) + 44, self.frame.size.width - 40, 66) raised:YES];
    [button setBackgroundColor:blues];
    [button setTitle:@"Click for your positive attributes" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:avFont size:16]];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"OPEN POSITIVE ATTS");
        
        [self.delegate openAttributes];
        
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
    
    self.currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width-40, 50)];
    self.currentGrade.font = [UIFont fontWithName:avFont size:24];
    self.currentGrade.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:self.currentGrade];
    [self addSubview:firstView];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, CGRectGetMaxY(self.currentGrade.frame), 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.layer.borderWidth = 2.0f;
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.cornerRadius = 50.0f;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);
    [firstView addSubview:self.gradeLabel];
    
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    
    UIImageView *boxImage = [[UIImageView alloc] initWithImage:checkBox highlightedImage:nil];
    boxImage.frame = CGRectMake(15, CGRectGetMaxY(self.gradeLabel.frame) + 20, 75, 75);
    boxImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:boxImage];
    
    UIImageView *check = [[UIImageView alloc] initWithImage:checkMark];
    check.frame = CGRectMake(boxImage.frame.origin.x + 3, boxImage.center.y - 62, 75, 75);
    check.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:check];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(boxImage.frame) + 10, CGRectGetMaxY(self.gradeLabel.frame) + 29, 200, 40)];
    label.text = @"Your Goal Is Realistic";
    label.font = FONT_AMATIC_BOLD(36);
    [self addSubview:label];
    
    int f = 200;
    
    BFPaperButton *realisticButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - f/2, CGRectGetMaxY(label.frame) + 15, f, f) raised:YES];
    [realisticButton setTitle:@"Read if your goals are realistic" forState:UIControlStateNormal];
    [realisticButton.titleLabel setNumberOfLines:0];
    [realisticButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [realisticButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [realisticButton setBackgroundColor:blues];
    [realisticButton.titleLabel setFont:FONT_AMATIC_BOLD(36)];
    [realisticButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[realisticButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.delegate openRealisticPopup];
    }];
    [self addSubview:realisticButton];
    
}

- (void)drawFinalTips {
    
    NSString *avFont = AVENIR_BLACK;
    
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 0.0f;
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) + 20, 10, self.frame.size.width, 30)];
    currentGrade.text = @"Final Life+Grade";
    currentGrade.textAlignment = NSTextAlignmentCenter;
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [firstView addSubview:currentGrade];
    [self addSubview:firstView];
    
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, CGRectGetMaxY(currentGrade.frame), 100, 100)];
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.font = FONT_AMATIC_BOLD(75);
    self.gradeLabel.layer.borderWidth = 2.0f;
    self.gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.gradeLabel.layer.cornerRadius = 50.0f;
    [firstView addSubview:self.gradeLabel];
    
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


- (void)addMethods {
    
    self.progressMethods = [[NSMutableArray alloc] initWithCapacity:10];
    
    
    ProgressMethods *m1 = [[ProgressMethods alloc] initWithMethod:@"Track My Patterns" andKey:@"general"];
    [self.progressMethods addObject:m1];
    
    ProgressMethods *m2 = [[ProgressMethods alloc] initWithMethod:@"Make 'Task' and 'To Do' Lists" andKey:@"general"];
        [self.progressMethods addObject:m2];
    
    ProgressMethods *m3 = [[ProgressMethods alloc] initWithMethod:@"Post reminders in Workplace" andKey:@"general"];
        [self.progressMethods addObject:m3];
    
    ProgressMethods *m4 = [[ProgressMethods alloc] initWithMethod:@"Journal or blog about it" andKey:@"general"];
        [self.progressMethods addObject:m4];
    
    ProgressMethods *m5 = [[ProgressMethods alloc] initWithMethod:@"Utilize a Calendar" andKey:@"general"];
    [self.progressMethods addObject:m5];
    
    ProgressMethods *m6 = [[ProgressMethods alloc] initWithMethod:@"Make Mini Goals" andKey:@"general"];
    [self.progressMethods addObject:m6];
    
    ProgressMethods *m7 = [[ProgressMethods alloc] initWithMethod:@"Use An App On Your Phone" andKey:@"general"];
    [self.progressMethods addObject:m7];
    
    ProgressMethods *m8 = [[ProgressMethods alloc] initWithMethod:@"Find a Professional" andKey:@"general"];
    [self.progressMethods addObject:m8];
    
    ProgressMethods *m9 = [[ProgressMethods alloc] initWithMethod:@"One Week Summary Worksheet" andKey:@"general"];
    [self.progressMethods addObject:m9];
    
    ProgressMethods *m10 = [[ProgressMethods alloc] initWithMethod:@"Track My Behaviors" andKey:@"Emotional Well-Being"];
    [self.progressMethods addObject:m10];
    
    ProgressMethods *m11 = [[ProgressMethods alloc] initWithMethod:@"Try One New Thing Hobby Journal" andKey:@"Hobbies & Interests"];
     [self.progressMethods addObject:m11];
    
    ProgressMethods *m12 = [[ProgressMethods alloc] initWithMethod:@"Food and/or Exercise Diary" andKey:@"Physical Health"];
     [self.progressMethods addObject:m12];
    
    ProgressMethods *m13 = [[ProgressMethods alloc] initWithMethod:@"“My Needs” Worksheet" andKey:@"Genuine, Intimate, and Deep Relationships"];
    [self.progressMethods addObject:m13];
    
    ProgressMethods *m14 = [[ProgressMethods alloc] initWithMethod:@"Who’s Got My Back Worksheet" andKey:@"Social Support & Social Networks"];
    [self.progressMethods addObject:m14];
    
    ProgressMethods *m15 = [[ProgressMethods alloc] initWithMethod:@"Contribution Bucket List Activity" andKey:@"Contribution & Giving Back"];
    [self.progressMethods addObject:m15];
    
    ProgressMethods *m16 = [[ProgressMethods alloc] initWithMethod:@"Thought Countering Worksheet" andKey:@"Positive Thinking"];
    [self.progressMethods addObject:m16];
}


@end
