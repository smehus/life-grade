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
#import "NYSegmentedControl.h"
#import <EventKit/EventKit.h>
#import "JMMarkSlider.h"
#import "KLCPopup.h"
#import "IQKeyboardManager.h"
#import "GoodBadResponseView.h"
#import "ECEventStore.h"


@import EventKitUI;


@interface RealisticViewController () <THDatePickerDelegate,
                                        ASValueTrackingSliderDataSource,
                                        ASValueTrackingSliderDelegate,
                                        EKEventEditViewDelegate>

@property (nonatomic, strong) UITextField *firstSupport;
@property (nonatomic, strong) UITextField *secondSupport;
@property (nonatomic, strong) UITextField *thirdSupport;
@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, strong) THDatePickerViewController *datePicker1;
@property (nonatomic, strong) NSDate *calDate;
@property (nonatomic, strong) NSDate *endCalDate;
@property (nonatomic, strong) Answers *fetchedAnswers;

@property (nonatomic, strong) NYSegmentedControl *switchThing;

@property (nonatomic, strong) UILabel *firstSliderLabel;
@property (nonatomic, strong) UILabel *secondSliderLabel;
@property (nonatomic, strong)  JMMarkSlider *sliderOne;
@property (nonatomic, strong) GoodBadResponseView *goodBadView;
@property (nonatomic, strong) EKEventStore *eventStore;

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
    
    UILabel *secondCal;
    UIButton *nButton;
    UIButton *calNextButton;
    KLCPopup *popup;
    BOOL popUpHasOpened;
    id calendarButton;
   
}

- (void)viewDidLoad {
    popUpHasOpened = NO;
    [super viewDidLoad];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Ball"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];

    avFont = AVENIR_BLACK;
    blueColor = BLUE_COLOR;
    screenWidth = self.view.frame.size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    [self performFetch];
    
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
    
    int sub = 0;
    if ([self isIpad] || IS_IPHONE4) {
        sub = 40;
    } else {
        sub = 60;
    }
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, sub)];
    titleLabel.text = self.fetchedAnswers.specificFocus;
    titleLabel.font = [UIFont fontWithName:avFont size:20];
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
//    [self.view addSubview:descLabel];

    
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
- (BOOL)isIpad {
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"] || [deviceType isEqualToString:@"iPhone Simulator"])
    {
        return NO;
    } else {
        return YES;
    }
}

- (void)setupScreen {
    
    UIColor *coldBlue = [UIColor colorWithHue:0.6 saturation:0.7 brightness:1.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithHue:0.55 saturation:0.75 brightness:1.0 alpha:1.0];
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *yellow = [UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];
    
    int ret = 0;
    int sub = 0;
    int btnY = 0;
    if ([self isIpad] || IS_IPHONE4) {
        ret = 0;
        sub = 30;
        btnY = 10;
    } else {
        ret = 10;
        sub = 40;
        btnY = 30;
    }
    
    firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + ret, screenWidth, sub)];
    firstLabel.text = @"How Confident Are You?";
    firstLabel.font = [UIFont fontWithName:avFont size:20];
    firstLabel.numberOfLines = 0;
    firstLabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:firstLabel];
    
    self.firstSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2 - 100, CGRectGetMaxY(firstLabel.frame), 200, 30)];
    self.firstSliderLabel.font = FONT_AMATIC_REG(28);
    self.firstSliderLabel.text = @"Slide to your confidence level";
    self.firstSliderLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.firstSliderLabel];
    
    
    self.sliderOne = [[JMMarkSlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.firstSliderLabel.frame)+ 30, screenWidth-20, sub)];
    self.sliderOne.markColor = [UIColor blackColor];
    self.sliderOne.markPositions = @[@1,@25,@50,@75,@99];
    self.sliderOne.markWidth = 4.0;
    [self.sliderOne addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
    [self.sliderOne addTarget:self action:@selector(sliderStopped:) forControlEvents:UIControlEventTouchUpInside];
    self.sliderOne.selectedBarColor = BLUE_COLOR;
    self.sliderOne.unselectedBarColor = [UIColor darkGrayColor];
    self.sliderOne.value = 0.50;
    
    
    [self.view addSubview:self.sliderOne];
    
    secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sliderOne.frame) + 25, screenWidth, sub)];
    secondLabel.text = @"Is this goal realistic?";
    secondLabel.font = [UIFont fontWithName:avFont size:24];
    secondLabel.numberOfLines = 0;
    secondLabel.lineBreakMode = NSLineBreakByWordWrapping;
    secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:secondLabel];
    
    self.secondSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondLabel.frame), self.view.frame.size.width/2-20, 30)];
    self.secondSliderLabel.font = FONT_AMATIC_REG(18);
    self.secondSliderLabel.textAlignment = NSTextAlignmentCenter;
    self.secondSliderLabel.text = @"Second Slider";
//    [self.view addSubview:self.secondSliderLabel];

//    [sliderOne setPopUpViewAnimatedColors:@[coldBlue, blue, green, yellow, red]
//                               withPositions:@[@-20, @0, @5, @25, @60]];
    
    
    /*
    ASValueTrackingSlider *sliderTwo = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.secondSliderLabel.frame)+ 10, screenWidth-20, 25)];
    sliderTwo.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    sliderTwo.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    sliderTwo.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    sliderTwo.dataSource = self;
    [self.view addSubview:sliderTwo];
    */
    
    CGFloat halfScreen = screenWidth/4;
    
    self.switchThing = [self getSegment];
    self.switchThing.frame = CGRectMake(screenWidth/2 - halfScreen, CGRectGetMaxY(self.secondSliderLabel.frame)+ 10, screenWidth/2, sub + 10);
    [self.view addSubview:self.switchThing];
    
    
    UIColor *gC = GREEN_COLOR;
    
    nButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.switchThing.frame) + btnY, self.view.frame.size.width - 20, 50)];
    [nButton setTitle:@"Next" forState:UIControlStateNormal];
    [nButton setBackgroundColor:gC];
    [nButton setUserInteractionEnabled:YES];
    [[nButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (self.switchThing.selectedSegmentIndex == 0) {
            
            [self RemoveAllViews];
            [self generalSave];
            [self setupSecondScreen];
        } else {
            [self showNotRealistic];
        }

        
    }];
    [self.view addSubview:nButton];
}

- (void)sliderStopped:(JMMarkSlider *)slider {
    
    float newStep = roundf((slider.value) / 0.25f);
    
    NSLog(@"newStep %f", newStep);
    [UIView animateWithDuration:0.3 animations:^{
        slider.value = newStep * 0.25;
    } completion:^(BOOL finished) {
        [self setSliderLabel:slider.value];
        
    }];
}

- (void)setSliderLabel:(CGFloat)val {
    
    if (val < .50 && popUpHasOpened == NO) {
        
        popUpHasOpened = YES;
        [self openShitConfidencePopup];
        
    }
    
    NSLog(@"FINAL VAL %f", val);
    int v = val * 100;
    switch (v) {
        case 0:
            self.firstSliderLabel.text = @"Not at all Confident";
            break;
        case 25:
            self.firstSliderLabel.text = @"Not Very Confident ";
            break;
        case 50:
            self.firstSliderLabel.text = @"Moderate Confidence";
            break;
        case 75:
            self.firstSliderLabel.text = @"Somewhat Confident";
            break;
        case 100:
            self.firstSliderLabel.text = @"Very Confident";
            break;
        default:
            self.firstSliderLabel.text = @"Error!";
            break;
    }
    
}

- (void)openShitConfidencePopup {
    
    self.goodBadView = [[GoodBadResponseView alloc] initForConfidenceAndFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*.6) andRealisticGoal:^{
        
        [popup dismiss:YES];
        
    }];
    
    self.goodBadView.clipsToBounds = YES;
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup show];

    
}

- (void)showNotRealistic {
    
    self.goodBadView = [[GoodBadResponseView alloc] initForRealisticwithFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*.6) andRealisticGoal:^(NSString *specificGoal) {
        
        
        self.fetchedAnswers.specificFocus = specificGoal;
        [self generalSave];
        [popup dismiss:YES];
        [self RemoveAllViews];
        [self setupSecondScreen];
    }];
    
    self.goodBadView.clipsToBounds = YES;
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup show];
}

- (void)sliderMoved:(JMMarkSlider *)slider {
    
    NSLog(@"slider: %f", slider.value);
    self.firstSliderLabel.text = @"...";
}

- (UIView *)createNotchWithXOrigin:(CGFloat)xOrig {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(xOrig, self.sliderOne.frame.origin.y, 1.0, 25)];
    v.backgroundColor = [UIColor darkGrayColor];
    v.layer.cornerRadius = 5.0f;
    return v;
}

- (NYSegmentedControl *)getSegment {
    
    NYSegmentedControl *segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Yes", @"No"]];
    // Customize and size the control
    segmentedControl.borderWidth = 1.0f;
    segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    segmentedControl.drawsGradientBackground = YES;
    segmentedControl.segmentIndicatorInset = 2.0f;
    segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];;
    segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
    segmentedControl.segmentIndicatorAnimationDuration = 0.3f;
    segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    [segmentedControl sizeToFit];
    
    return segmentedControl;
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

#pragma mark - Calendar Screen

- (NSString *)formattedStringForDate:(NSDate *)date {
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterShortStyle];
    return [f stringFromDate:date];
}

- (void)setupSecondScreen {
    
    [self accessEventStore];
    
    titleLabel.text = @"SET A TIME FRAME";
    firstField.text = @" Set a date";
    
    // Use reactive cocoa here to watch teh self.caldate object and update label
    
    UILabel *firstCal = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, self.view.frame.size.width-20, 30)];
    firstCal.textAlignment = NSTextAlignmentCenter;
    firstCal.text = @"Start Date";
    firstCal.font = FONT_AMATIC_BOLD(28);
    [self.view addSubview:firstCal];
    
    NSString *da = [NSString stringWithFormat:@"%@", self.calDate];
//    UILabel *l = [self createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(firstField.frame) + 100, screenWidth, 50) andTitle:@"This is where text goes"];
//    [self.view addSubview:l];
    UIColor *green = GREEN_COLOR;
    calBut = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstCal.frame) + 20, self.view.frame.size.width-20, 75)];
    [calBut setBackgroundColor:green];
    if (self.fetchedAnswers.startDate != nil) {
        [calBut setTitle:[self formattedStringForDate:self.fetchedAnswers.startDate] forState:UIControlStateNormal];
    } else {
        [calBut setTitle:@"Pick Date" forState:UIControlStateNormal];
    }
    [[calBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        // create event and then input into addEvent
//        [self accessEventStore];
        [self addEvent:calBut];
        
        
        
        /*
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
         
         */
        
    }];
    [self.view addSubview:calBut];
    
    
    secondCal = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calBut.frame) + 10, self.view.frame.size.width-20, 30)];
    secondCal.textAlignment = NSTextAlignmentCenter;
    secondCal.text = @"Completion Date";
    secondCal.font = FONT_AMATIC_BOLD(28);
    secondCal.hidden = YES;
    [self.view addSubview:secondCal];
    
    calBut1 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondCal.frame) + 20, self.view.frame.size.width-20, 75)];
    [calBut1 setBackgroundColor:green];
    if (self.fetchedAnswers.endDate != nil) {
        [calBut1 setTitle:[self formattedStringForDate:self.fetchedAnswers.endDate] forState:UIControlStateNormal];
        [calBut1 setHidden:NO];
    } else {
        [calBut1 setTitle:@"Pick Date" forState:UIControlStateNormal];
        [calBut1 setHidden:YES];
    }

    [[calBut1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
//        [self accessEventStore];
        [self addEvent:calBut1];
        
        
        
        /*
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
     */
    }];
    [self.view addSubview:calBut1];
    

       UIColor *gc = GREEN_COLOR;
    calNextButton = [self addNextButton];
    [calNextButton setFrame:CGRectMake(10, CGRectGetMaxY(self.view.frame) - 175, self.view.frame.size.width-20, 66)];
    if (self.fetchedAnswers.startDate != nil && self.fetchedAnswers.endDate != nil) {
        [calNextButton setUserInteractionEnabled:YES];
        [calNextButton setBackgroundColor:gc];
    } else {
        [calNextButton setUserInteractionEnabled:NO];
        [calNextButton setBackgroundColor:[UIColor grayColor]];
    }
 
    

    [[calNextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       // go somewhere
        
        [self saveDates];
        [self RemoveAllViews];
        
        
        titleLabel.text = self.fetchedAnswers.specificFocus;
        firstLabel.text = @"Support";
        [self setupThirdView];
    }];
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skipButton setFrame:CGRectMake(0, CGRectGetMaxY(calNextButton.frame) + 15, self.view.frame.size.width, 10)];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton setBackgroundColor:[UIColor clearColor]];
    [skipButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[skipButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self RemoveAllViews];
        titleLabel.text = self.fetchedAnswers.specificFocus;
        firstLabel.text = @"Support";
        [self setupThirdView];
        
    }];
    [self.view addSubview:skipButton];
}

- (IBAction)addEvent:(id)sender {
    
    calendarButton = sender;
    //[self performSegueWithIdentifier:@"AddEvent" sender:nil];
    
    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];

    event.title     = self.fetchedAnswers.specificFocus;
    if (sender == calBut1) {
        event.startDate = self.fetchedAnswers.startDate;
    } else {
        event.startDate = [NSDate date];
    }
    event.endDate = [NSDate dateWithTimeIntervalSinceNow:30];

    
    EKEventEditViewController *editViewController = [[EKEventEditViewController alloc] init];
    editViewController.eventStore = self.eventStore;
    editViewController.event = event;
    editViewController.editViewDelegate = self;
    
    [self presentViewController:editViewController animated:YES completion:nil];
    
}
- (void)accessEventStore {
    
    
    
    self.eventStore = [[ECEventStore sharedInstance] getThisEventStore];
    NSLog(@"EVENT STORE: %@", self.eventStore);
    
    [[ECEventStore sharedInstance] accessEventStore:self.eventStore WithCompletion:^(NSMutableArray *events) {
        
    }];
    
}

#pragma mark - calendar delegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    
    NSLog(@"LSDJF %@", controller.event.startDate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    if (calendarButton == calBut) {
        
        
        self.calDate = controller.event.startDate;
        self.fetchedAnswers.startDate = controller.event.startDate;
        NSString *stringDate = [dateFormatter stringFromDate:self.calDate];
        [calBut setTitle:stringDate forState:UIControlStateNormal];
        [calBut1 setHidden:NO];
        secondCal.hidden = NO;
    } else {
        
        self.endCalDate = controller.event.startDate;
        self.fetchedAnswers.endDate = controller.event.startDate;
        
        NSString *stringDate = [dateFormatter stringFromDate:self.endCalDate];
        UIColor *g = GREEN_COLOR;
        
        [calBut1 setTitle:stringDate forState:UIControlStateNormal];
        [calNextButton setUserInteractionEnabled:YES];
        [calNextButton setBackgroundColor:g];
        
        
    }
    
     [controller dismissViewControllerAnimated:YES completion:nil];
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
    
    titleLabel.text = self.fetchedAnswers.specificFocus;
    titleLabel.layer.borderWidth = 1.0f;
    titleLabel.layer.borderColor = [UIColor blueColor].CGColor;
    firstLabel.text = @"Type in 3 people that will support you in this goal.";
    firstLabel.frame = CGRectMake(5, CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width - 10, 75);
    [self.view addSubview:firstLabel];
    
    // need text inset - take from priv things
    
    firstField = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, screenWidth - 20, 50)];
    firstField.layer.borderColor = blueColor.CGColor;
    firstField.layer.borderWidth = 2.0f;
    firstField.backgroundColor = [UIColor whiteColor];
    firstField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    firstField.font = FONT_AMATIC_REG(24);
    firstField.textAlignment = NSTextAlignmentCenter;
    firstField.placeholder = @"exp: John";
    [self.view addSubview:firstField];
    
    secondField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstField.frame) + 10, screenWidth - 20, 50)];
    secondField.layer.borderColor = blueColor.CGColor;
    secondField.layer.borderWidth = 2.0f;
    secondField.backgroundColor = [UIColor whiteColor];
    secondField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    secondField.font = FONT_AMATIC_REG(24);
    secondField.textAlignment = NSTextAlignmentCenter;
    secondField.placeholder = @"exp: Kathy";
    [self.view addSubview:secondField];
    
    thirdField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondField.frame) + 10, screenWidth - 20, 50)];
    thirdField.layer.borderColor = blueColor.CGColor;
    thirdField.layer.borderWidth = 2.0f;
    thirdField.backgroundColor = [UIColor whiteColor];
    thirdField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    thirdField.font = FONT_AMATIC_REG(24);
    thirdField.textAlignment = NSTextAlignmentCenter;
    thirdField.placeholder = @"exp: Francis";
    [self.view addSubview:thirdField];
    
    UIButton *b = [self addNextButton];
    [[b rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
        [self save];
        
    
        if (del.currentUser) {
            
            FinalAnalysisViewController *finalController = [[FinalAnalysisViewController alloc] initWithSave:YES];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalController];
            [self.revealViewController setFrontViewController:nav];
            
            
        } else {
            SignupViewController *signUp = [[SignupViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUp];
            [self.revealViewController pushFrontViewController:nav animated:YES];
        };
        
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

- (void)addDatesToCalendar {
        
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = @"Life+Grade Goal";
            event.notes = self.fetchedAnswers.specificFocus;
            event.startDate = self.fetchedAnswers.startDate;
            event.endDate = self.fetchedAnswers.endDate;
            
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            NSLog(@"CALENDAR ERROR: %@",err);
            
        }];
}

#pragma mark - thcalendar thing del

-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    NSLog(@"huh? %@", datePicker);
    
    if (datePicker == self.datePicker) {
        
        
        self.calDate = datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString *stringDate = [dateFormatter stringFromDate:self.calDate];
        
        [calBut setTitle:stringDate forState:UIControlStateNormal];
        [calBut1 setHidden:NO];
        secondCal.hidden = NO;
    } else if (datePicker == self.datePicker1) {
        
        
        self.endCalDate = datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString *stringDate = [dateFormatter stringFromDate:self.endCalDate];
        
        UIColor *g = GREEN_COLOR;
        
        [calBut1 setTitle:stringDate forState:UIControlStateNormal];
        [calNextButton setUserInteractionEnabled:YES];
        [calNextButton setBackgroundColor:g];
        
    }

    
    [self.datePicker dismissSemiModalView];
    
}
-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    NSLog(@"huh?");
    
    
    [self.datePicker dismissSemiModalView];
}

- (void)saveDates {
    
    self.fetchedAnswers.startDate = self.calDate;
    self.fetchedAnswers.endDate = self.endCalDate;
    [self addDatesToCalendar];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
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

- (void)generalSave {
    
    self.fetchedAnswers.isRealistic = self.switchThing.selectedSegmentIndex;
    self.fetchedAnswers.confidentValue = [NSNumber numberWithFloat:self.sliderOne.value];
    
    
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
