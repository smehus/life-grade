
//
//  FinalAnalysisViewController.m
//  life-grade
//
//  Created by scott mehus on 9/4/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "FinalAnalysisViewController.h"
#import "SWRevealViewController.h"
#import "Answers.h"
#import "Grade.h"
#import "MainAppDelegate.h"
#import "Attributes.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FinalGradeViewController.h"
#import <MGBoxKit/MGBoxKit.h>
#import "AnalysisView.h"
#import "MDCScrollBarViewController.h"
#import "MDCScrollBarLabel.h"
#import "CompletionDateView.h"
#import "SupportTeamView.h"
#import "ChoseView.h"
#import "KLCPopup.h"
#import "GoodBadResponseView.h"
#import "ProgressMethods.h";

@interface FinalAnalysisViewController () <UIScrollViewDelegate, AnalysisViewDelegate, CompletionDateViewDelegate, SupportTeamDelegate>
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSArray *fetchedAttributes;
@property (nonatomic, strong) NSString *gradeLetter;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *lowestFactors;
@property (nonatomic, strong) NSMutableArray *highestFactors;
@property (nonatomic, strong) NSMutableArray *grades;
@property (nonatomic, assign) BOOL shouldSave;
@property (nonatomic, strong) ChoseView *choseView;
@property (nonatomic, strong) GoodBadResponseView *goodBadView;
@property (nonatomic, strong) NSMutableArray *progressMethods;

@end

@implementation FinalAnalysisViewController {
    
    MainAppDelegate *del;
    float finalGradeNum;
    NSString *fontName;
    UIView *firstView;
    UIView *secondView;
    UIColor *barColour;
    MGBox *container;
    CGFloat screenWidth;
    CGFloat screenHeight;
    UIButton *scrollButton;
    KLCPopup *popup;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        
    }
    return self;
}

- (id)initWithSave:(BOOL)save {
    if (self = [super init]) {
        
        self.shouldSave = save;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.progressMethods = [[NSMutableArray alloc] initWithCapacity:10];
    
    //**** SCREEN GLOBALS ****\\
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    fontName = LIGHT_FONT;
    
    self.title = @"Analysis";
    
    self.questions = [[NSMutableArray alloc] initWithCapacity:10];
    self.lowestFactors = [[NSMutableArray alloc] initWithCapacity:3];
    
    self.view.backgroundColor = [UIColor whiteColor];
    del = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    [self setTitleView];
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    
    
    
    
    //**** GET & SET INFORMATION ****\\
    
    self.questions = [[NSMutableArray alloc] initWithCapacity:10];
    self.lowestFactors = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Questions - Good & Bad Answeres
    [self fetchGrades];
    // Answer Object
    [self fetchAnswers];
    // Get saved attributes
    [self fetchAttributes];
    // Get array of grade to each question
    [self setAnswersArray];
    // get three lowest grades
    [self getLowestGrade];
    
    
    
    
    
    //**** SETUP SCROLLVIEW ****\\
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight *10);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.layer.masksToBounds = NO;
    self.scrollView.layer.shouldRasterize = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    CGRect screenRct = [[UIScreen mainScreen] bounds];
    
    
    scrollButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scrollButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [scrollButton setBackgroundColor:[UIColor clearColor]];
    [scrollButton.titleLabel setFont:FONT_AMATIC_BOLD(36)];
    [scrollButton setFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.frame.size.width, 30)];
    [[scrollButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
         [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.origin.x, self.scrollView.contentOffset.y + screenRct.size.height) animated:YES];
        
    }];
    [self.view addSubview: scrollButton];
    
    [self constructAllViews];
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

- (void)getLowestGrade {
    
    NSArray *sortedArray;
    sortedArray = [self.grades sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(Grade*)a gradeNum];
        NSNumber *second = [(Grade*)b gradeNum];
        return [first compare:second];
    }];
    
    
    self.lowestFactors = [NSMutableArray arrayWithArray:sortedArray];
    
    
}


- (void)setAnswersArray {
    
    self.grades = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        int index = (int)idx;
        Grade *g = [[Grade alloc] init];
        g.gradeNum = [self getGradeForIndex:index];
        g.question = [[self.questions objectAtIndex:idx] question];
        g.goodResponse = [[self.questions objectAtIndex:idx] goodResponse];
        g.badResponse = [[self.questions objectAtIndex:idx] badResponse];
        [self.grades addObject:g];
        
    }];
}

#pragma mark - Questions & Good & Bad Answeres


- (void)fetchGrades {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *ary = [dict objectForKey:@"questions"];
    [ary enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        Grade *grade = [[Grade alloc] init];
        grade.question = obj[@"question"];
        grade.goodResponse = obj[@"goodResponse"];
        grade.badResponse = obj[@"badResponse"];
        // questions and good & bad answers
        [self.questions addObject:grade];
        
    }];
    
}

#pragma mark - Get the Saved ' Answer '

// also need to save - but not every time we load answers!
//!!!!: when logging out - i delete core data - so when log in it fetches data from parse, but doesnt' save to coredata
// so it looks for data in core data that isn't there and then tries to save it to parse - crash
- (void)fetchAnswers {
    
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
    // One instance of Answer
    self.fetchedAnswers = [foundObjects lastObject];
    NSLog(@"FETCHED ANS %@", self.fetchedAnswers.endDate);
    
    if (self.shouldSave == NO) {

        
        
    } else {
        
        
        [self saveToParse];
    }
    
    
    NSNumber *num = self.fetchedAnswers.finalGrade;
    float balls = [num floatValue];
    NSLog(@"FINAL GRADE %f", balls);
    finalGradeNum = balls/100;
    
    [self calculateGrade];
    
}

#pragma mark - fetch all saved Attributes

- (void)fetchAttributes {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Answers"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Attributes" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"***CORE_DATA_ERROR*** %@", error);
        
        return;
    }
    
    self.fetchedAttributes = foundObjects;
    
    
    [self.fetchedAttributes enumerateObjectsUsingBlock:^(Attributes *obj, NSUInteger idx, BOOL *stop) {
        
        NSLog(@"ATT %@", obj.attribute);
        
    }];
}

- (NSNumber *)getGradeForIndex:(int)idx {
    
    switch (idx) {
        case 0:
            return self.fetchedAnswers.questionOne;
            break;
        case 1:
            return self.fetchedAnswers.questionTwo;
            break;
        case 2:
            return self.fetchedAnswers.questionThree;
            break;
        case 3:
            return self.fetchedAnswers.questionFour;
            break;
        case 4:
            return self.fetchedAnswers.questionFive;
            break;
        case 5:
            return self.fetchedAnswers.questionSix;
            break;
        case 6:
            return self.fetchedAnswers.questionSeven;
            break;
        case 7:
            return self.fetchedAnswers.questionEight;
            break;
        case 8:
            return self.fetchedAnswers.questionNine;
            break;
        case 9:
            return self.fetchedAnswers.questionTen;
            break;
        default:
            return [NSNumber numberWithInt:10];
            break;
    }
}

- (void)calculateGrade {
    
    if (finalGradeNum <= 1.0 && finalGradeNum >= 0.97) {
        self.gradeLetter = @"A+";
    } else if (finalGradeNum < 0.97 && finalGradeNum > 0.93) {
        self.gradeLetter = @"A";
    } else if (finalGradeNum < 0.94 && finalGradeNum > 0.89) {
        self.gradeLetter = @"A-";
    } else if (finalGradeNum < 0.90 && finalGradeNum > 0.86) {
        self.gradeLetter = @"B+";
    } else if (finalGradeNum < 0.87 && finalGradeNum > 0.83) {
        self.gradeLetter = @"B";
    } else if (finalGradeNum < 0.84 && finalGradeNum > 0.79) {
        self.gradeLetter = @"B-";
    } else if (finalGradeNum < 0.80 && finalGradeNum > 0.76) {
        self.gradeLetter = @"C+";
    } else if (finalGradeNum < 0.77 && finalGradeNum > 0.73) {
        self.gradeLetter = @"C";
    } else if (finalGradeNum < 0.74 && finalGradeNum > 0.69) {
        self.gradeLetter = @"C-";
    } else if (finalGradeNum < 0.70 && finalGradeNum >= 0.66) {
        self.gradeLetter = @"D+";
    } else if (finalGradeNum < 0.67 && finalGradeNum > 0.63) {
        self.gradeLetter = @"D";
    } else if (finalGradeNum < 0.64 && finalGradeNum > 0.59) {
        self.gradeLetter = @"D-";
    } else {
        self.gradeLetter = @"F";
    }
}




- (NSString *)getDesiredGradeString:(int)i {
    switch (i) {
        case 0:
            return @"A+";
            break;
        case 1:
            return @"A";
            break;
        case 2:
            return @"A-";
            break;
        case 3:
            return @"B+";
            break;
        case 4:
            return @"B";
            break;
        case 5:
            return @"B-";
            break;
        case 6:
            return @"C+";
            break;
        case 7:
            return @"C";
            break;
        case 8:
            return @"C-";
            break;
        case 9:
            return @"D+";
            break;
        case 10:
            return @"D";
            break;
        case 11:
            return @"D-";
            break;
        case 12:
            return @"F";
            break;
        default:
            return @"N/A";
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Add Views

- (void)constructAllViews {
    
    for (int i = 0; i <= 9; i++) {
        
        switch (i) {
            case 0:
                [self strengthsView:i];
                break;
            case 1:
                [self challengesView:i];
                break;
            case 2:
                [self goalView:i];
                break;
            case 3:
                [self trackingProgress:i];
                break;
            case 4:
                [self attainableView:i];
                break;
            case 5:
                [self realisticView:i];
                break;
            case 6:
                [self completionDateView:i];
                break;
            case 7:
                [self supportTeamView:i];
                break;
            case 8:
                [self finalTipsView:i];
                break;
            case 9:
                [self drawClosingMessageView:i];
                break;
            default:
                break;
        }
    }
}

- (void)drawClosingMessageView:(int)i {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight * i, self.view.frame.size.width, self.view.frame.size.height)];
    v.backgroundColor = [UIColor clearColor];
    

    UIImage *cm = [UIImage imageNamed:@"check_mark_2"];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 20, 100, 100)];
    iv.image = cm;
    [v addSubview:iv];
    
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(iv.frame), self.view.frame.size.width-20, self.view.frame.size.height-260)];
    l.text = @"Congratulations on making such a positive first step with completing the Life+Grade. The journey you are embarking on is such a valuable one with wonderful potential payoffs. In many cases, going on this journey with an effective coach can improve your rate of progress. Click below to learn more about Life Coaching.";
    l.font = FONT_AMATIC_BOLD(26);
    l.numberOfLines = 0;
    l.textAlignment = NSTextAlignmentCenter;
    l.lineBreakMode = NSLineBreakByWordWrapping;
//    l.layer.borderWidth = 1.0f;
//    l.layer.borderColor = [UIColor redColor].CGColor;
    [v addSubview:l];
    
    
    UIColor *g = GREEN_COLOR;
    
    UIButton *checkBut = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(l.frame) + 5, self.view.frame.size.width - 20, 44)];
    [checkBut setBackgroundColor:g];
    [checkBut setTitle:@"Check It Out" forState:UIControlStateNormal];
    [[checkBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.youtimecoach.com"]];
        
    }];
    [v addSubview:checkBut];
    
    
    [self.scrollView addSubview:v];
}

- (void)strengthsView:(int)i {
    
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                       andIndex:i andData:a];
    v.delegate = self;
    v.currentGrade.text = @"Current Grade";
    v.titleLabel.text = @"Highest Grade Factors";
    v.gradeLabel.text = self.gradeLetter;
    [self.scrollView addSubview:v];
}
- (void)challengesView:(int)i {
    NSArray *a = self.lowestFactors;
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a];
    v.delegate = self;
    v.titleLabel.text = @"Lowest Graded Factors";
    v.currentGrade.text = @"Current Grade";
    v.gradeLabel.text = self.gradeLetter;
    [self.scrollView addSubview:v];
}   


- (void)goalView:(int)i  {
    

    
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a andGoal:self.fetchedAnswers.specificFocus];
    v.titleLabel.text = @"Goal";
    v.titleLabel.font = FONT_AMATIC_BOLD(34);
    v.currentGrade.text = @"Desired Grade";
    NSString *dG = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    
    v.gradeLabel.text = dG;
    
    v.quoteLabel.text = @"If you don't know where you are going, you might wind up someplace else. ~Yogi Berra";
    [self.scrollView addSubview:v];
}

- (void)trackingProgress:(int)i {
    
    NSArray *a = @[self.fetchedAnswers.trackingProgressOne, self.fetchedAnswers.trackingProgressTwo, self.fetchedAnswers.trackingProgressThree];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a andQuote:@"Balls"];
    v.currentGrade.text = @"Desired Grade";
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.titleLabel.text = @"Tracking Progress";
    v.titleLabel.font = FONT_AMATIC_BOLD(28);
    v.delegate = self;
    v.quoteLabel.text = @"Be not afraid of going slowly, be afraid of standing still. ~Chinese Proverb";
    v.quoteLabel.font = FONT_AVENIR_BLACK(14);
    [self.scrollView addSubview:v];
    
}
- (void)attainableView:(int)i {
    NSArray *a = self.fetchedAttributes;
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a attainableQuote:@"Dicks"];
    v.titleLabel.text = @"Mindset for Success";
    v.titleLabel.font = FONT_AMATIC_REG(24);
    v.quoteLabel.text =  @"In order to attain your goal you must channel your most powerful positive behaviors to make them come true. You must develop an attitude for success to keep the positive momentum going. Remember, you are worthy of this goal so start developing that those positive behaviors.";
    v.quoteLabel.font = FONT_AVENIR_BLACK(14);
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    v.delegate = self;
    [v.bottomButton setTitle:@"Click For Your Positive Attributes" forState:UIControlStateNormal];
    [self.scrollView addSubview:v];
}
- (void)realisticView:(int)i {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a isRealstic:YES];
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    v.delegate = self;
    [self.scrollView addSubview:v];
}
- (void)completionDateView:(int)i {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    CompletionDateView *v = [[CompletionDateView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)];
    NSString *g = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    
    v.gradeLabel.text = g;
    v.delegate = self;
    v.currentGrade.text = @"Desired Grade";
    v.startDateLabel.text = [self formatDate:self.fetchedAnswers.startDate];
    v.completionDateLabel.text = [self formatDate:self.fetchedAnswers.endDate];
    
    [self.scrollView addSubview:v];
}

- (NSString *)formatDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *s = [formatter stringFromDate:date];
    return s;
    
}
- (void)supportTeamView:(int)i  {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    SupportTeamView *v = [[SupportTeamView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)];
    
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    v.delegate = self;
    v.firstSupport.text = self.fetchedAnswers.firstSupport;
    v.secondSupport.text = self.fetchedAnswers.secondSupport;
    v.thirdSupport.text = self.fetchedAnswers.thirdSupport;
    
    [self.scrollView addSubview:v];
}


- (void)finalTipsView:(int)i {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                             andFinalTips:nil];
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.finalGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    v.delegate = self;
    [self.scrollView addSubview:v];
}





#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat contentX = scrollView.contentOffset.y;
    
    
    
    // add the logic to remove next button
    if (scrollView.contentOffset.y > screenRect.size.height * 8 ) {
        scrollButton.hidden = YES;

    } else {
        scrollButton.hidden = NO;
    }
    
    
}

- (void)addAnswersButton {
    
    UIColor *color = GREEN_COLOR;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, CGRectGetMaxY(container.frame) + 25, self.view.frame.size.width, 50)];
    [button setTitle:@"Detailed Analysis" forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"DETAILED ANAL");
        
        FinalGradeViewController *gradeController = [[FinalGradeViewController alloc] init];
        [self.navigationController pushViewController:gradeController animated:YES];
        
        
    }];
    
    [self.view addSubview:button];
}

- (void)saveToParse {
    
    NSString *email = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"email"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"password"];
    
    
    
    PFObject *post = [PFObject objectWithClassName:@"Grade"];
    post[@"questionOne"] = self.fetchedAnswers.questionOne;
    post[@"questionTwo"] = self.fetchedAnswers.questionTwo;
    post[@"questionThree"] = self.fetchedAnswers.questionThree;
    post[@"questionFour"] = self.fetchedAnswers.questionFour;
    post[@"questionFive"] = self.fetchedAnswers.questionFive;
    post[@"questionSix"] = self.fetchedAnswers.questionSix;
    post[@"questionSeven"] = self.fetchedAnswers.questionSeven;
    post[@"questionEight"] = self.fetchedAnswers.questionEight;
    post[@"questionNine"] = self.fetchedAnswers.questionNine;
    post[@"questionTen"] = self.fetchedAnswers.questionTen;
    post[@"desiredGrade"] = self.fetchedAnswers.desiredGrade;
    post[@"finalGrade"] = self.fetchedAnswers.finalGrade;
    post[@"trackingProgressOne"] = self.fetchedAnswers.trackingProgressOne;
    post[@"trackingProgressTwo"] = self.fetchedAnswers.trackingProgressTwo;
    post[@"trackingProgressThree"] = self.fetchedAnswers.trackingProgressThree;
    post[@"startDate"] = (self.fetchedAnswers.startDate) ? self.fetchedAnswers.startDate : [NSDate date];
    post[@"endDate"] = (self.fetchedAnswers.endDate) ? self.fetchedAnswers.endDate : [NSDate date];
    post[@"firstSupport"] = self.fetchedAnswers.firstSupport;
    post[@"secondSupport"] = self.fetchedAnswers.secondSupport;
    post[@"thirdSupport"] = self.fetchedAnswers.thirdSupport;
    post[@"specificFocus"] = self.fetchedAnswers.specificFocus;
    
    
    NSLog(@"FINALDESIRE %@", self.fetchedAnswers.finalGrade);
    PFUser *user = [PFUser currentUser];
    
    user[@"desiredGrade"] = self.fetchedAnswers.desiredGrade;
    
    if (user) {
        post[@"user"] = user;
    } else if (email) {
        post[@"backupEmail"] = email;
    } else {
        
        NSLog(@"no current user and no user defaults");
    }
    
    [post save];
    [user save];
}



- (void)openPopUpWithGrade:(Grade *)g {
    
    CGFloat h = 0.6;
    if (IS_IPHONE4) {
        h = 0.7;
    }
 
    
    self.goodBadView = [[GoodBadResponseView alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*h) andGrade:g andCloseBlock:^{
       // close this shit
        
    }];
    
    self.goodBadView.clipsToBounds = YES;
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup show];
    
}

- (void)openTrackingProgressPopUp:(NSInteger)i withMethod:(ProgressMethods *)method {
    NSString *b;
    
    
//    switch (i) {
//        case 0:
//            b = self.fetchedAnswers.trackingProgressOne;
//            break;
//        case 1:
//            b = self.fetchedAnswers.trackingProgressTwo;
//            break;
//        case 2:
//            b = self.fetchedAnswers.trackingProgressThree ;
//            break;
//            
//        default:
//            break;
//    }
    
    CGFloat h = 0.7;
    if (IS_IPHONE4) {
        h = 0.7;
    }
    
    self.goodBadView = [[GoodBadResponseView alloc] initForTrackingAndFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*h) withMethod:method andBlock:^{
        
        [popup dismiss:YES];
    }];
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup show];
    
    
    
}

- (void)getTrackingMethod {
    
    // loop through array (need to build) of progress methods and find a mtach for key
}

- (void)openAttributes {
    
    self.goodBadView = [[GoodBadResponseView alloc] initForAttributesAndFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*.6) withAttributes:self.fetchedAttributes andBlock:^{
        
        [popup dismiss:YES];
    }];
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup show];
    
    
    
}

- (void)openRealisticPopup  {
    
    CGFloat h = 0.6;
    if (IS_IPHONE4) {
        h = 0.7;
    }
    self.goodBadView = [[GoodBadResponseView alloc] initForAnalysisRealisticAndFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*h) andBlock:^{
         [popup dismiss:YES];
       
        
    }];
        
    
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup show];
}

- (void)addMethods {
    
    
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


#pragma mark - CompletionDate Delegato

- (void)havingTroubleSelected {
    
    self.goodBadView = [[GoodBadResponseView alloc] initForDatesAndFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*.6) andBlock:^{
        [popup dismiss:YES];
        
        
    }];
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup show];
}

- (void)whyDoINeedSupport {
    
    self.goodBadView = [[GoodBadResponseView alloc] initForSupportAndFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*.6) andBlock:^{
        [popup dismiss:YES];
        
        
    }];
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup show];
    
}


- (void)finalTipsSelectedAtIndex:(int)idx {
    
    CGFloat h = 0.6;
    if (IS_IPHONE4) {
        h = 0.7;
    }
    
    self.goodBadView = [[GoodBadResponseView alloc] initForFinalTipsAndFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height*h) withTip:[self getTipForIndex:idx] andBlock:^{
        [popup dismiss:YES];
        
        
    }];
    
    popup = [KLCPopup popupWithContentView:self.goodBadView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup show];
}

- (NSString *)getTipForIndex:(int)i {
    
    NSString *text;
    switch (i) {
        case 0:
            text = @"This journey you are now on will most likely feel like it has set-backs and can discourage you in moving forward. Keep in mind that just as in shooting a bow and arrow, you must pull the bow backwards before shooting it forwards. The focus should be less on the fact that there is a set-back and more on how you choose to respond to the set-back. ";
            break;
        case 1:
            text = @"When you experience a success or set-back do you listen to your inner-coach talk? How you and your inner Jiminy Cricket  coach yourself should reflect how you would like other people to coach you. Keep tabs on how your inner voice responds to positive and negative experiences. Try and allow yourself to first see things better than they are, then worse than they are, and finally as they actually are.";
            break;
        case 2:
            text = @"Remind yourself frequently why you started. Your motivation may fluctuate throughout pursuing your goal, but constantly remind yourself of the value in what you are doing for yourself.";
            break;
            
        default:
            break;
    }
    

    return text;

}

@end
