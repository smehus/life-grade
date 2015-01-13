//
//  GoodBadResponseView.m
//  life-grade
//
//  Created by scott mehus on 12/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "GoodBadResponseView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AttainCell.h"
#import "Attributes.h"


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

- (id)initForTrackingAndFrame:(CGRect)frame withMethod:(ProgressMethods *)mehtod andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.progressMethod = mehtod;
        self.closeBlock = doneBlock;
        [self trackingProgressView];
        
    }
    return self;
}

- (id)initForAttributesAndFrame:(CGRect)frame withAttributes:(NSArray *)ats andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        
        self.attributes = ats;
        self.closeBlock = doneBlock;
        [self constructAttributesView];
    }
    return self;
}

- (id)initForAnalysisRealisticAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.closeBlock= doneBlock;
        [self setupAnalysisRealisticView];
    }
    return self;
}

- (id)initForDatesAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.closeBlock = doneBlock;
        [self drawCompletionDateView];
    }
    return self;
}

- (id)initForSupportAndFrame:(CGRect)frame andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.closeBlock = doneBlock;
        [self drawSupportView];
    }
    return self;
}

- (id)initForFinalTipsAndFrame:(CGRect)frame withTip:(NSString *)tip andBlock:(CloseBlock)doneBlock {
    if (self = [super initWithFrame:frame]) {
        self.closeBlock = doneBlock;
        [self drawFinalTipsView:tip];
    }
    return self;
}

- (void)constructAttributesView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 100)];
    [planLabel setFont:FONT_AMATIC_BOLD(24)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Here are the positive traits you chose to give you your mindset for success";
    [self addSubview:planLabel];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(planLabel.frame), self.frame.size.width, 100) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[AttainCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    
    int sub = 0;
    int ret = 0;
    if ([self isIpad]) {
        sub = 5;
        ret = 30;
    } else {
        sub = 20;
        ret = 44;
    }
    
    UIColor *c = GREEN_COLOR;
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextbutton setFrame:CGRectMake(10, CGRectGetMaxY(self.collectionView.frame) + sub, self.frame.size.width-20, ret)];
    [nextbutton setTitle:@"Cool!" forState:UIControlStateNormal];
    [nextbutton setBackgroundColor:c];
    [nextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[nextbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.closeBlock();
    }];
    [self addSubview:nextbutton];
}
- (CGSize)getSizeOfString:(NSString *)txt withWidth:(CGFloat)w {
    NSString *text = txt;
    CGFloat width = w;
    UIFont *font = FONT_AVENIR_BLACK(16);
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@
     {
     NSFontAttributeName: font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    return size;
}

- (void)trackingProgressView {
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    int sub = 0;
    int ret = 0;
    int fnt = 0;
    if ([self isIpad]) {
        sub = 0;
        ret = 175;
        fnt = 14;
    } else {
        sub = 10;
        ret = 250;
        fnt = 16;
    }
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  sub, self.frame.size.width - 20, ret)];
    [planLabel setFont:FONT_AVENIR_BLACK(fnt)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = self.progressMethod.methodDescription;
//    [planLabel sizeToFit];
    
    
    [self addSubview:planLabel];
    
    
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [linkButton setFrame:CGRectMake(10, CGRectGetMaxY(planLabel.frame) + sub, self.frame.size.width-20, 44)];
    [linkButton setTitle:@"Download the Worksheet" forState:UIControlStateNormal];
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
    [nextbutton setFont:FONT_AVENIR_BLACK(18)];
    [[nextbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.closeBlock();
    }];
    [self addSubview:nextbutton];
    
}

- (BOOL)isIpad {
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"] || [deviceType isEqualToString:@"iPhone Simulator"])
    {
        return NO;
    } else {
        return YES;
    }
}

- (void)setupQuestionView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    int ret = 0;
    if ([self isIpad]) {
        ret = 40;
    } else {
        ret = 20;
    }
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - ret, 200)];
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
    planLabel.text = @"Setting manageable and proper goals will build confidence. Although you may not be incredibly confident right now, the Life+Grade process can potentially increase your confidence by making your goals more manageable. Stick with it and if you feel that you are still stuck look into seeing a Life Coach.";
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

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 60)];
    [titleLabel setFont:FONT_AVENIR_BLACK(18)];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = [NSString stringWithFormat:@"%@ : %@", self.thisGrade.question, self.thisGrade.gradeNum];
    [self addSubview:titleLabel];
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 300)];
    [planLabel setFont:FONT_AVENIR_BLACK(12)];
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
    [planLabel setFont:FONT_AMATIC_BOLD(22)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Let’s re-frame your goal by stating it in a more manageable and realistic way. Are you asking too much, too soon? If so, scale back and start with smaller goals.\n\n Enter a more manageable goal below:";
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

- (void)setupAnalysisRealisticView {
    self.backgroundColor = [UIColor whiteColor];
    
    
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 250)];
    [planLabel setFont:FONT_AVENIR_BLACK(16)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Being practical isn’t always our strong suit, but we are in the business making some positive change so reality is our friend! Realistic goals will boost your confidence, create direction, and make the journey much more manageable. Stay flexible, the specifics of your goal may change along the way.";
    [self addSubview:planLabel];
    
}

- (void)drawCompletionDateView {
    
    int ret = 0;
    if ([self isIpad]) {
        ret = 22;
    } else {
        ret = 24;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, self.frame.size.height - 20)];
    [planLabel setFont:FONT_AMATIC_BOLD(ret)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Isaac Newton got it right, bodies in rest tend to stay in rest. So here are some tips to getting in motion and staying there; break the task down into smaller less overwhelming steps, ask one of your support team members to help you, go public and share your intentions with other people, and make a “to do list” with only items you have been avoiding.";
    [self addSubview:planLabel];
    
}

- (void)drawSupportView {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, 250)];
    [planLabel setFont:FONT_AMATIC_BOLD(24)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = @"Support and helping relationships are critical to your success and change! The support team you have assembled here will help you by;\n•Listening to your needs\n•Keeping you accountable\n•Maintaining positivity\n•Sharing new perspectives";
    [self addSubview:planLabel];
    
    
}

- (void)drawFinalTipsView:(NSString *)tip {
    
    self.backgroundColor = [UIColor whiteColor];
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  10, self.frame.size.width - 20, self.frame.size.height - 20)];
    [planLabel setFont:FONT_AMATIC_BOLD(22)];
    planLabel.numberOfLines = 0;
    planLabel.textAlignment = NSTextAlignmentCenter;
    planLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planLabel.text = tip;
    [self addSubview:planLabel];
    
}

#pragma mark - CollectionView Datasaur



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.attributes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AttainCell *cell = (AttainCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = BLUE_COLOR;
    
    Attributes *d = self.attributes[indexPath.row];
    cell.attributeLabel.text = d.attribute;
    cell.layer.shadowOffset = CGSizeMake(-5, 5);
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = 0.5;
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 100);
}


@end
