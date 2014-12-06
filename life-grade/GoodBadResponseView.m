//
//  GoodBadResponseView.m
//  life-grade
//
//  Created by scott mehus on 12/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "GoodBadResponseView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

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

- (id)initForConfidenceAndFrame:(CGRect)frame andRealisticGoal:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.closeBlock = doneBlock;
        [self setupBasicView];
        
    }
    return self;
}

- (id)initForRealisticwithFrame:(CGRect)frame andRealisticGoal:(RealisticBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        
        self.realisticBlock = doneBlock;
        [self setupRealisticResponse];
    }
    return self;
}

- (id)initForQuestionsAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.closeBlock = doneBlock;
        [self setupQuestionView];
        
    }
    return self;
}

- (id)initForTrackingAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.closeBlock = doneBlock;
        [self trackingProgressView];
        
    }
    return self;
}

- (void)trackingProgressView {
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 100)];
    [planLabel setFont:FONT_AMATIC_BOLD(18)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Works";
    [self addSubview:planLabel];
    
    
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [linkButton setFrame:CGRectMake(10, CGRectGetMaxY(planLabel.frame) + 10, self.frame.size.width-20, 44)];
    [linkButton setTitle:@"Go To PDF" forState:UIControlStateNormal];
    [linkButton setBackgroundColor:[UIColor clearColor]];
    [linkButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[linkButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtimecoach.com/#!resources/c1tjx"]];
        
    }];
    
    [self addSubview:linkButton];
    
    
    UIColor *c = GREEN_COLOR;
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextbutton setFrame:CGRectMake(10, CGRectGetMaxY(linkButton.frame) + 10, self.frame.size.width-20, 44)];
    [nextbutton setTitle:@"Got It!" forState:UIControlStateNormal];
    [nextbutton setBackgroundColor:c];
    [nextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[nextbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.closeBlock();
    }];
    [self addSubview:nextbutton];
    
}

- (void)setupQuestionView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 200)];
    [planLabel setFont:FONT_AMATIC_BOLD(18)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Based on your answers, it looks like the challenge you have selected to work on isn't the best for right now. We're going to take you back and let you select a more appropriate challenge";
    [self addSubview:planLabel];
    
    
    UIColor *c = GREEN_COLOR;
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextbutton setFrame:CGRectMake(10, CGRectGetMaxY(planLabel.frame) + 10, self.frame.size.width-20, 44)];
    [nextbutton setTitle:@"Got It!" forState:UIControlStateNormal];
    [nextbutton setBackgroundColor:c];
    [nextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[nextbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.closeBlock();
    }];
    [self addSubview:nextbutton];
}

- (void)setupBasicView {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 200)];
    [planLabel setFont:FONT_AMATIC_BOLD(18)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Works";
    [self addSubview:planLabel];
    
    
    UIColor *c = GREEN_COLOR;
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextbutton setFrame:CGRectMake(10, CGRectGetMaxY(planLabel.frame) + 10, self.frame.size.width-20, 44)];
    [nextbutton setTitle:@"Got It!" forState:UIControlStateNormal];
    [nextbutton setBackgroundColor:c];
    [nextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[nextbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.closeBlock();
    }];
    [self addSubview:nextbutton];
}

- (void)setupScreen {
    self.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 40)];
    [titleLabel setFont:FONT_AVENIR_BLACK(18)];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = [NSString stringWithFormat:@"%@ : %@", self.thisGrade.question, self.thisGrade.gradeNum];
    [self addSubview:titleLabel];
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 300)];
    [planLabel setFont:FONT_AMATIC_BOLD(18)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = [self getResponse];
    [self addSubview:planLabel];
    
}

- (void)setupRealisticResponse {
    NSLog(@"GOOD BAD REALISTIC");
    self.backgroundColor = [UIColor whiteColor];
    UIColor *greenCol = GREEN_COLOR;
    NSString *font = LIGHT_FONT;
    UIColor *blueC = BLUE_COLOR;
    
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 150)];
    [planLabel setFont:FONT_AMATIC_BOLD(18)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"This Works";
    [self addSubview:planLabel];
    
    
    self.specificLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(planLabel.frame) + 10, self.bounds.size.width - 20, 50)];
    self.specificLabel.font = FONT_AMATIC_BOLD(24);
    self.specificLabel.textAlignment = NSTextAlignmentCenter;
    self.specificLabel.placeholder = @" Example: Lose 10 Pounds";
    self.specificLabel.layer.borderWidth = 1.0f;
    self.specificLabel.layer.borderColor = greenCol.CGColor;
    self.specificLabel.delegate = self;
    [self addSubview:self.specificLabel];
    
    UIColor *c = GREEN_COLOR;
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextbutton setFrame:CGRectMake(10, CGRectGetMaxY(self.specificLabel.frame) + 10, self.frame.size.width-20, 44)];
    [nextbutton setTitle:@"Done" forState:UIControlStateNormal];
    [nextbutton setBackgroundColor:c];
    [nextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[nextbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
        if (self.specificLabel.text.length > 0) {
            self.realisticBlock(self.specificLabel.text);
        } else {
            
        }
    }];
    [self addSubview:nextbutton];
}

- (NSString *)getResponse {
  
    
    if ([self.thisGrade.gradeNum floatValue] < 7.6) {
        return self.thisGrade.badResponse;
    } else {
        return self.thisGrade.goodResponse;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField *)textField up: (BOOL) up
{
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.frame = CGRectOffset(self.frame, 0, movement);
    [UIView commitAnimations];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.specificLabel resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.specificLabel resignFirstResponder];
    return YES;
}





@end
