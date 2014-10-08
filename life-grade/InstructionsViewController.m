//
//  InstructionsViewController.m
//  life-grade
//
//  Created by scott mehus on 9/10/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "InstructionsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PickDesiredGradeController.h"
#import "AttributesViewController.h"
#import "ActionPlanViewController.h"
#import "MyActionViewController.h"

@interface InstructionsViewController ()

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation InstructionsViewController {
    Class localClass;
    NSString *instructionString;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithViewController:(Class)theClass andCompletionBlock:(CompletionBlock)doneBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = doneBlock;
        localClass = theClass;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Life+Grade";
    UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    NSString *blah = LIGHT_FONT;
    titelLabel.font = [UIFont fontWithName:blah size:30];

    
    if (localClass == [PickDesiredGradeController class]) {
        titelLabel.text = @"Desired Grade";
        instructionString = @"Now you are in the driver’s seat! Grade yourself on each of the 10 Life factors. Grade each factor before moving on to the next. Being honest with yourself will produce a more realistic Life+Grade to later work with.";
        
    } else if (localClass == [MyActionViewController class]) {
        titelLabel.text = @"Attributes";
        instructionString = @"Ok so maybe your current grade isn’t exactly what you were looking for or just maybe life is good right now. Either way, now is your chance to select the grade you want in life! Go ahead, reach for the stars and grab the grade you want.";
        
    } else if (localClass == [ActionPlanViewController class]) {
        titelLabel.text = @"Action Plan";
        instructionString = @"This is where your journey begins, so sit tight and enjoy the ride. Each part of the Action Plan will get you one more step closer to your desired grade. The Action Plan will give you the direction you are looking for and a clear path to your higher grade in life.";
        
    }
    
    [self.view addSubview:titelLabel];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton setFrame:CGRectMake(0, self.view.frame.size.height - 175, self.view.frame.size.width, 44)];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIColor *color = GREEN_COLOR;
    [self.nextButton setBackgroundColor:color];
    [self.nextButton setTitle:@"Get Started" forState:UIControlStateNormal];
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        self.completionBlock();
    }];
    
    [self.view addSubview:self.nextButton];
    
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)setupView {
    
    CGSize viewSize = self.view.frame.size;
    CGFloat viewHeight = self.view.frame.size.height;
    
    UIImage *header = [UIImage imageNamed:@"header_image"];
    CGFloat ratio = 1/4;
    
    NSString *avFont = AVENIR_BLACK;
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width * 2, 0, viewSize.width, viewHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66)];
    titleView.backgroundColor = BLUE_COLOR;
    // add objects here for nav bar
    
    CGFloat titleHeight = titleView.frame.size.height - 30;
    CGFloat imageWidth = titleHeight *4;
    UIImageView *headerView = [[UIImageView alloc] initWithImage:header];
    headerView.frame = CGRectMake(self.view.frame.size.width/2 - imageWidth/2, 23, imageWidth, titleHeight);
    
    [titleView addSubview:headerView];
    
    [view addSubview:titleView];
    
    
    UIImageView *firstCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleView.frame) + 10, 100, 100)];
    firstCheck.image = checkBox;
    firstCheck.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:firstCheck];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, CGRectGetMaxY(titleView.frame) + 20, 250, 40)];
    title.text = @"Step bals:";
    title.textColor = GREY_COLOR;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = FONT_AMATIC_BOLD(40);
    [view addSubview:title];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, CGRectGetMaxY(title.frame), 200, 30)];
    currentGrade.text = @"Current Grade";
    currentGrade.textColor = GREY_COLOR;
    currentGrade.textAlignment = NSTextAlignmentLeft;
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [view addSubview:currentGrade];
    
    
    UIView *instructBox = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(currentGrade.frame) + 15, 200, 200)];
    instructBox.backgroundColor = BLUE_COLOR;
    instructBox.layer.masksToBounds = NO;
    instructBox.layer.cornerRadius = 8;
    instructBox.layer.shadowOffset = CGSizeMake(-10, 15);
    instructBox.layer.shadowRadius = 4;
    instructBox.layer.shadowOpacity = 0.5;
    
    UILabel *instructTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, instructBox.frame.size.width, 50)];
    instructTitle.font = FONT_AMATIC_BOLD(40);
    instructTitle.text = @"Instructions:";
    instructTitle.textColor = [UIColor whiteColor];
    instructTitle.textAlignment = NSTextAlignmentCenter;
    [instructBox addSubview:instructTitle];
    
    
    
    self.instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(instructTitle.frame),
                                                                       instructBox.frame.size.width - 14, instructBox.frame.size.height - CGRectGetMaxY(instructTitle.frame))];
    self.instructLabel.font = [UIFont fontWithName:avFont size:16];
    self.instructLabel.textColor = [UIColor whiteColor];
    self.instructLabel.textAlignment = NSTextAlignmentCenter;
    self.instructLabel.numberOfLines = 0;
    self.instructLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.instructLabel.text = instructionString;
    [instructBox addSubview:self.instructLabel];
    [self.view addSubview:instructBox];


}


@end
