//
//  RealisticViewController.m
//  life-grade
//
//  Created by scott mehus on 9/25/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "RealisticViewController.h"
#import "MainAppDelegate.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "THDatePickerViewController.h"
#import "SignupViewController.h"
#import "ASValueTrackingSlider.h"
#import "Answers.h"

@interface RealisticViewController () <THDatePickerDelegate, ASValueTrackingSliderDataSource, ASValueTrackingSliderDelegate>

@property (nonatomic, strong) UITextField *firstSupport;
@property (nonatomic, strong) UITextField *secondSupport;
@property (nonatomic, strong) UITextField *thirdSupport;
@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, strong) THDatePickerViewController *datePicker1;
@property (nonatomic, strong) NSDate *calDate;
@property (nonatomic, strong) NSDate *endCalDate;
@property (nonatomic, strong) Answers *fetchedAnswers;

@end

@implementation RealisticViewController {
    
    MainAppDelegate *del;
    UIImageView *bg;
    NSString *avFont;
    CGRect originalFrame;
    UIColor *blueColor;
    UILabel *titleLabel;
    CGFloat screenWidth;
    NSString *liteFont;
    UILabel *firstLabel;
    UILabel *secondLabel;
    UIButton *calBut;
    UIButton *calBut1;
    
    UITextField *firstField;
    UITextField *secondField;
    UITextField *thirdField;
    UIButton *nextButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    avFont = AVENIR_BLACK;
    blueColor = BLUE_COLOR;
    screenWidth = self.view.frame.size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    [self setTitleView];
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIColor *grey = GREY_COLOR;
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    [barBtnItem setTintColor:grey];
    self.navigationItem.backBarButtonItem = barBtnItem;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    titleLabel.text = @"Attitude Adjustment";
    titleLabel.font = [UIFont fontWithName:avFont size:24];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
    
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width, 60)];
    descLabel.text = @"Attitude Adjustment";
    descLabel.font = [UIFont fontWithName:avFont size:24];
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:descLabel];

    
    [self setupScreen];
}

- (void)performFetch {

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
    NSLog(@"question bitch %@", self.fetchedAnswers.questionEight);
    
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

- (void)setupScreen {
    
    UIColor *coldBlue = [UIColor colorWithHue:0.6 saturation:0.7 brightness:1.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithHue:0.55 saturation:0.75 brightness:1.0 alpha:1.0];
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *yellow = [UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];
    
    
    firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, screenWidth, 100)];
    firstLabel.text = @"How Confident Are You?";
    firstLabel.font = [UIFont fontWithName:avFont size:24];
    firstLabel.numberOfLines = 0;
    firstLabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:firstLabel];
    
    ASValueTrackingSlider *sliderOne = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstLabel.frame)+ 10, screenWidth-20, 25)];
//    sliderOne.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    sliderOne.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    sliderOne.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    sliderOne.dataSource = self;
    [self.view addSubview:sliderOne];
    
    secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLabel.frame) + 50, screenWidth, 100)];
    secondLabel.text = @"How Confident Are You?";
    secondLabel.font = [UIFont fontWithName:avFont size:24];
    secondLabel.numberOfLines = 0;
    secondLabel.lineBreakMode = NSLineBreakByWordWrapping;
    secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:secondLabel];
    
    

    [sliderOne setPopUpViewAnimatedColors:@[coldBlue, blue, green, yellow, red]
                               withPositions:@[@-20, @0, @5, @25, @60]];
    
    
    ASValueTrackingSlider *sliderTwo = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondLabel.frame)+ 10, screenWidth-20, 25)];
    sliderTwo.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    sliderTwo.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    sliderTwo.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    sliderTwo.dataSource = self;
    [self.view addSubview:sliderTwo];
    
    UIColor *gC = GREEN_COLOR;
    
    UIButton *nButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sliderTwo.frame) + 10, self.view.frame.size.width - 20, 50)];
    [nButton setTitle:@"Next" forState:UIControlStateNormal];
    [nButton setBackgroundColor:gC];
    [[nButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self RemoveAllViews];
        [self setupSecondScreen];
        
    }];
    [self.view addSubview:nButton];
}

- (void)RemoveAllViews {
    
    for (UIView *v in self.view.subviews) {
        if (v == bg || v == titleLabel) {
            
        } else {
            [v removeFromSuperview];
            
            [secondLabel removeFromSuperview];
            
        }
    }
}

- (void)setupSecondScreen {
    titleLabel.text = @"Timely";
    firstField.text = @" Set a date";
    
    // Use reactive cocoa here to watch teh self.caldate object and update label
    
    UILabel *firstCal = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, self.view.frame.size.width-20, 30)];
    firstCal.textAlignment = NSTextAlignmentCenter;
    firstCal.text = @"Start Date";
    firstCal.font = FONT_AVENIR_BLACK(24);
    [self.view addSubview:firstCal];
    
    NSString *da = [NSString stringWithFormat:@"%@", self.calDate];
//    UILabel *l = [self createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(firstField.frame) + 100, screenWidth, 50) andTitle:@"This is where text goes"];
//    [self.view addSubview:l];
    UIColor *green = GREEN_COLOR;
    calBut = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstCal.frame) + 20, self.view.frame.size.width-20, 75)];
    [calBut setBackgroundColor:green];
    [calBut setTitle:@"Pick Date" forState:UIControlStateNormal];
    [[calBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
//        [self openCalendar:calBut];
        
        if(!self.datePicker)
            self.datePicker = [THDatePickerViewController datePicker];
        self.datePicker.date = [NSDate date];
        self.datePicker.delegate = self;
        [self.datePicker setAllowClearDate:NO];
        [self.datePicker setAutoCloseOnSelectDate:YES];
        [self.datePicker setDisableFutureSelection:NO];
        [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
        
        [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
            int tmp = (arc4random() % 30)+1;
            if(tmp % 5 == 0)
                return YES;
            return NO;
        }];
        //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
        [self presentSemiViewController:self.datePicker withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                      KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
        
    }];
    [self.view addSubview:calBut];
    
    
    UILabel *secondCal = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calBut.frame) + 10, self.view.frame.size.width-20, 30)];
    secondCal.textAlignment = NSTextAlignmentCenter;
    secondCal.text = @"End Date";
    secondCal.font = FONT_AVENIR_BLACK(24);
    [self.view addSubview:secondCal];
    
    calBut1 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondCal.frame) + 20, self.view.frame.size.width-20, 75)];
    [calBut1 setBackgroundColor:green];
    [calBut1 setTitle:@"Pick Date" forState:UIControlStateNormal];
    [[calBut1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
//        [self openCalendar:calBut1];
        if(!self.datePicker1)
            self.datePicker1 = [THDatePickerViewController datePicker];
        self.datePicker1.date = [NSDate date];
        self.datePicker1.delegate = self;
        [self.datePicker1 setAllowClearDate:NO];
        [self.datePicker1 setAutoCloseOnSelectDate:YES];
        [self.datePicker1 setDisableFutureSelection:NO];
        [self.datePicker1 setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        [self.datePicker1 setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
        
        [self.datePicker1 setDateHasItemsCallback:^BOOL(NSDate *date) {
            int tmp = (arc4random() % 30)+1;
            if(tmp % 5 == 0)
                return YES;
            return NO;
        }];
        //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
        [self presentSemiViewController:self.datePicker1 withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                      KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
        
    }];
    [self.view addSubview:calBut1];
    

    
    UIButton *b = [self addNextButton];
    [[b rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       // go somewhere
        
        [self RemoveAllViews];
        titleLabel.text = @"Support";
        firstLabel.text = @"Support";
        [self setupThirdView];
        
    }];
}

- (UILabel *)createLabelWithFrame:(CGRect)rect andTitle:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = title;
    label.font = [UIFont fontWithName:avFont size:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
   
    
    return label;
}

- (void)openCalendar:(id)sender {
    
    
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = [NSDate date];
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        if(tmp % 5 == 0)
            return YES;
        return NO;
    }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
}


- (void)setupThirdView {
    
    titleLabel.text = @"Support";
    firstLabel.text = @"Name 3 people in your circle";
    
    // need text inset - take from priv things
    
    firstField = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, screenWidth - 20, 44)];
    firstField.layer.borderColor = blueColor.CGColor;
    firstField.layer.borderWidth = 1.0f;
    firstField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstField];
    
    secondField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstField.frame) + 10, screenWidth - 20, 44)];
    secondField.layer.borderColor = blueColor.CGColor;
    secondField.layer.borderWidth = 1.0f;
    secondField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondField];
    
    thirdField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondField.frame) + 10, screenWidth - 20, 44)];
    thirdField.layer.borderColor = blueColor.CGColor;
    thirdField.layer.borderWidth = 1.0f;
    thirdField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thirdField];
    
    UIButton *b = [self addNextButton];
    [[b rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
        [self save];
       
        SignupViewController *signUp = [[SignupViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUp];
        [self.revealViewController pushFrontViewController:nav animated:YES];
        
    }];
    
}

- (UIButton *)addNextButton {
    
    UIColor *green = GREEN_COLOR;
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.view.frame) - 150, self.view.frame.size.width-20, 66)];
    [nextButton setBackgroundColor:green];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    
    
    return nextButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    NSLog(@"realistic controller dealloc");
}

#pragma mark - thcalendar thing del

-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    NSLog(@"huh? %@", datePicker);
    
    if (datePicker == self.datePicker) {
        
        
        self.calDate = datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *stringDate = [dateFormatter stringFromDate:self.calDate];
        
        
        
        [calBut setTitle:stringDate forState:UIControlStateNormal];
        
    } else if (datePicker == self.datePicker1) {
        
        
        self.endCalDate = datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *stringDate = [dateFormatter stringFromDate:self.endCalDate];
        
        
        
        [calBut1 setTitle:stringDate forState:UIControlStateNormal];
        
    }

    
    [self.datePicker dismissSemiModalView];
    
}
-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    NSLog(@"huh?");
    
    
    [self.datePicker dismissSemiModalView];
}

- (void)save {
    
    self.fetchedAnswers.firstSupport = firstField.text;
    self.fetchedAnswers.secondSupport = secondField.text;
    self.fetchedAnswers.thirdSupport = thirdField.text;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
}

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
    
    return @"ballsack";
}


@end
