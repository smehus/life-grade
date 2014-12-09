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
    
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.frame.size.width - 20, 100)];
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
            NSLog(@"Tracking Progress Box Tapped");
          
            // loop through self.progress methods and find the right method
            
            
            // i need the text of the description here
            
            [self.progressMethods enumerateObjectsUsingBlock:^(ProgressMethods * obj, NSUInteger idx, BOOL *stop) {
               
                
                
                if ([obj.method isEqualToString:g]) {
                    
                    [self.delegate openTrackingProgressPopUp:i withMethod:obj];
                }
            }];
        
        
            
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
        box.titleLabel.text = [NSString stringWithFormat:@"Tip# %i", i+1];
        box.onTap = ^{
            NSLog(@"Box Tapped");
            [self.delegate finalTipsSelectedAtIndex:i];
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
    
    
}


- (void)addMethods {
    
    self.progressMethods = [[NSMutableArray alloc] initWithCapacity:10];
    
    
    ProgressMethods *m1 = [[ProgressMethods alloc] initWithMethod:@"Track My Patterns" andKey:@"general"];
    m1.methodDescription = @"Grab a pen and paper, use your computer, or just grab your phone and start your detective work! Use this method of tracking progress by recording your troublesome behaviors, your feelings and thoughts associated with them, and the results of all this! Good detective work will illuminate problem areas and potential places to focus on.";
    [self.progressMethods addObject:m1];
    
    ProgressMethods *m2 = [[ProgressMethods alloc] initWithMethod:@"Make 'Task' and 'To Do' Lists" andKey:@"general"];
    m2.methodDescription = @"Keeping lists can save lives! Seriously, just as your doctor, they survive on keeping well organized lists. When making your list make sure to organize, prioritize, and keep the items manageable and specific. This technique will keep you on task and";
    [self.progressMethods addObject:m2];
    
    ProgressMethods *m3 = [[ProgressMethods alloc] initWithMethod:@"Post reminders in Workplace" andKey:@"general"];
    m3.methodDescription = @"Whether you like to admit or not, we all need reminders here and there. Use post-its, color coded paper, or whatever you can get your hands on to remind you that big things need to be happening! A reminder doesn’t mean you have a bad memory or that you are a bad person, it simply means you care about getting your stuff done.";
    [self.progressMethods addObject:m3];
    
    ProgressMethods *m4 = [[ProgressMethods alloc] initWithMethod:@"Journal or blog about it" andKey:@"general"];
    m4.methodDescription = @"Sometimes emotions can get the best of us, so writing or blogging about your change can not only be therapeutic but can actually help you track your own thoughts and behaviors. Open up that notebook or computer of yours and starting getting those thoughts down!";
    [self.progressMethods addObject:m4];
    
    ProgressMethods *m5 = [[ProgressMethods alloc] initWithMethod:@"Utilize a Calendar" andKey:@"general"];
    m5.methodDescription = @"There’s a reason why when you were growing up there was always a calendar in the kitchen. It was your parent’s way to remember weekly plans, food shopping, birthdays, and soccer practice. Now it is your turn to use that fancy cell phone calendar or the old fashion one. Right in important dates, deadlines, events, and reminders each week to keep your change moving forward and from a different perspective. Use this for both long-term and short term goals.";
    [self.progressMethods addObject:m5];
    
    ProgressMethods *m6 = [[ProgressMethods alloc] initWithMethod:@"Make Mini Goals" andKey:@"general"];
    m6.methodDescription = @"Sometimes we bite off more than we can chew, and trust me that isn’t always a good thing. Look at your goal and ask yourself if you can break it down into smaller chunks that are more manageable and less time consuming. This will provide you with the smaller process goals that lead you up that staircase to success!";
    [self.progressMethods addObject:m6];
    
    ProgressMethods *m7 = [[ProgressMethods alloc] initWithMethod:@"Use An App On Your Phone" andKey:@"general"];
    m7.methodDescription = @"Grab that mighty iPhone of yours and get searching! Use your absurdly capable phones to help you with your change. There are great apps out there that help you move towards your goal by sending reminders, helping you organize your “to do” lists, or even sending some motivation over your way. Also, there are many free options out there. Okay, what are you waiting for? Start downloading!";
    [self.progressMethods addObject:m7];
    
    ProgressMethods *m8 = [[ProgressMethods alloc] initWithMethod:@"Find a Professional" andKey:@"general"];
    m8.methodDescription = @"Nothing replaces help directly from another human. There are so many resources out there on your computer, phone, or in the bookstore that may help but are not for everybody. Working with a professional on your goals is a great way to get the support, feedback, and direction you need. You have already made a positive step towards your goal, keep the momentum moving.";
    [self.progressMethods addObject:m8];
    
    ProgressMethods *m9 = [[ProgressMethods alloc] initWithMethod:@"One Week Summary Worksheet" andKey:@"general"];
    m9.methodDescription = @"Life is a roller coaster and sometimes we need to sit down and see what our week actually provided us. It may be tough at first to see the progress you desire, don’t get discouraged this is normal. Make genuine efforts by jotting what you did from each week in this worksheet. Trust me, you may see more progress than you would think. Alway remember, that success whether big or small breeds more confidence and success.";
    [self.progressMethods addObject:m9];
    
    ProgressMethods *m10 = [[ProgressMethods alloc] initWithMethod:@"Track My Behaviors" andKey:@"Emotional Well-Being"];
    m10.methodDescription = @"Now it is time to be a detective. Are you a fan of CSI, Law and Order, or Chicago PD? If so, you have the first step down, but if not no worries! Grab a pen and paper or your computer and track your trouble behaviors relevant to your goal. Jot down what the behavior is (be specific), when did it happen, what were the triggers, and what were the consequences. Play detective and track this for 5 days for a greater understanding of your troubling behaviors.";
    [self.progressMethods addObject:m10];
    
    ProgressMethods *m11 = [[ProgressMethods alloc] initWithMethod:@"Try One New Thing Hobby Journal" andKey:@"Hobbies & Interests"];
    m11.methodDescription = @"Life is driven by emotions and experiences. Whether it is with a group, one other person, or by yourself try to expand those healthy experiences by trying new things. Use this worksheet as a way to keep experiencing new hobbies and interests.";
    [self.progressMethods addObject:m11];
    
    ProgressMethods *m12 = [[ProgressMethods alloc] initWithMethod:@"Food and/or Exercise Diary" andKey:@"Physical Health"];
    m12.methodDescription = @"Are you a midnight cereal eater, a fantasy football couch potato, or both? Fear not, you are making positive steps to change. Use these worksheets to organize your thoughts and actions to keep things manageable for yourself. Awareness is the first step and tracking your food and exercise will help guide you to a healthier you!";
    [self.progressMethods addObject:m12];
    
    ProgressMethods *m13 = [[ProgressMethods alloc] initWithMethod:@"“My Needs” Worksheet" andKey:@"Genuine, Intimate, and Deep Relationships"];
    m13.methodDescription = @"Humans are needy people! Whether we are meeting our own needs or another persons we are constantly trying to fulfill them. Sometimes we do this in healthy ways and sometimes not so healthy. One thing is for sure, it drives many of the decisions we make and for that we should take a closer look. Use this worksheet to examine your own needs and how you meet them around your goal.";
    [self.progressMethods addObject:m13];
    
    ProgressMethods *m14 = [[ProgressMethods alloc] initWithMethod:@"Who’s Got My Back Worksheet" andKey:@"Social Support & Social Networks"];
    m14.methodDescription = @"Social support is undeniably one of the most important factors in accomplishing your goals. You have already identified three people to be on your support team, now let’s figure out how they can support you. Use this worksheet to understand how your support team will help you on your road to change.";
    [self.progressMethods addObject:m14];
    
    ProgressMethods *m15 = [[ProgressMethods alloc] initWithMethod:@"Contribution Bucket List Activity" andKey:@"Contribution & Giving Back"];
    m15.methodDescription = @"Research shows that giving back outside of yourself and contributing is one sure fire way to experience fulfillment in life. A bucket list will gather the things you have always wanted to do, which will help add to your life’s fulfillment. Enjoy using this worksheet and adding serious value to your life";
    [self.progressMethods addObject:m15];
    
    ProgressMethods *m16 = [[ProgressMethods alloc] initWithMethod:@"Thought Countering Worksheet" andKey:@"Positive Thinking"];
    m16.methodDescription = @"Turn that frown upside down, well something like that. Positive thinking has a major impact on your happiness and the outcome of your goal. Let’s be honest, you can’t be positive all the time but you can try a counter some of that negative thinking with this handy worksheet. ";
    [self.progressMethods addObject:m16];
    
    
}

@end
