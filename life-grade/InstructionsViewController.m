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
#import "Answers.h"
#import "MainAppDelegate.h"

@interface InstructionsViewController ()
@property (nonatomic, strong) Answers *fetchedAnswers;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation InstructionsViewController {
    Class localClass;
    NSString *instructionString;
    NSString *titleString;
    NSString *subTitleString;
    MainAppDelegate *del;
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
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    [self performFetch];

    [self setTitleView];
    
    UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    NSString *blah = LIGHT_FONT;
    titelLabel.font = [UIFont fontWithName:blah size:30];
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bg];
    


    
    if (localClass == [PickDesiredGradeController class]) {
        
        NSLog(@"%@", self.fetchedAnswers.finalGrade);
        
//        titelLabel.text = @"Desired Grade";
        titleString = @"Step Two";
        subTitleString = @"Desired Grade";
        if ([self.fetchedAnswers.finalGrade floatValue] < 80) {
            instructionString = @"Ok so maybe your current grade isn’t exactly what you were looking for or just maybe life is good right now. Either way, now is your chance to select the grade you want in life! Go ahead, reach for the stars and grab the grade you want.";
        } else {
            instructionString = @"Well aren't you perfect. Either way, now is your chance to select the grade you want in life! Go ahead, reach for the stars and grab the grade you want";
        }
        
    } else if (localClass == [MyActionViewController class]) {
//        titelLabel.text = @"Attributes";
        titleString = @"Step Three";
        subTitleString = @"Action Plan";
        instructionString = @"This is where your journey begins, so sit tight and enjoy the ride. Each part of the Action Plan will get you one more step closer to your desired grade. The Action Plan will give you the direction you are looking for and a clear path to your higher grade in life.";
        
    } else if (localClass == [ActionPlanViewController class]) {
//        titelLabel.text = @"Action Plan";
        titleString = @"Step Three";
        instructionString = @"This is where your journey begins, so sit tight and enjoy the ride. Each part of the Action Plan will get you one more step closer to your desired grade. The Action Plan will give you the direction you are looking for and a clear path to your higher grade in life.";
        
    }
    
    [self.view addSubview:titelLabel];
    
    int sub = 0;
    if ([self isIpad] || IS_IPHONE4) {
        sub = 125;
    } else {
        sub = 175;
    }
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton setFrame:CGRectMake(0, self.view.frame.size.height - sub, self.view.frame.size.width, 44)];
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

- (BOOL)isIpad {
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"] || [deviceType isEqualToString:@"iPhone Simulator"])
    {
        return NO;
    } else {
        return YES;
    }
}

- (void)performFetch {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Answers"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answers" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"***CORE_DATA_ERROR*** %@", error);
        
        
        return;
    }
    
    self.fetchedAnswers = [foundObjects lastObject];
    NSLog(@"question bitch %@", self.fetchedAnswers);
    
}

- (void)setTitleView {
    
    // TITLE VIEW SET
    
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,44*4,44)];
    [iv setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = iv;
    UIImage *titleImage = [UIImage imageNamed:@"header_image.png"];
    
    CGFloat imageHeight = 35.0f;
    CGFloat imageWidth = imageHeight * 4;
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    titleImageView.frame = CGRectMake(iv.frame.size.width/2 - imageWidth/2, 3, imageHeight * 4, imageHeight);
    [iv addSubview:titleImageView];
    self.navigationItem.titleView = iv;
    
    
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
    
    
    UIImageView *firstCheck = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 100, 100)];
    firstCheck.image = checkBox;
    firstCheck.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:firstCheck];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, firstCheck.frame.origin.y, 250, 40)];
    title.text = titleString;
    title.textColor = GREY_COLOR;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = FONT_AMATIC_BOLD(40);
    [self.view addSubview:title];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstCheck.frame) + 5, CGRectGetMaxY(title.frame), 200, 30)];
    currentGrade.text = subTitleString;
    currentGrade.textColor = GREY_COLOR;
    currentGrade.textAlignment = NSTextAlignmentLeft;
    currentGrade.font = [UIFont fontWithName:avFont size:24];
    [self.view addSubview:currentGrade];
    
    CGFloat boxWidth = self.view.frame.size.width;
    
    UIView *instructBox = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(currentGrade.frame) + 15, boxWidth - 30, boxWidth - 80)];
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
