
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

@interface FinalAnalysisViewController () <UIScrollViewDelegate>
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
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
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
    self.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight *9);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.layer.masksToBounds = NO;
    self.scrollView.layer.shouldRasterize = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
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
    
//    [self saveToParse];
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
    
    for (int i = 0; i <= 8; i++) {
        
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
            default:
                break;
        }
    }
}

- (void)strengthsView:(int)i {
    
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                       andIndex:i andData:a];
    v.currentGrade.text = @"Current Grade";
    v.titleLabel.text = @"Strengths";
    v.gradeLabel.text = self.gradeLetter;
    [self.scrollView addSubview:v];
}
- (void)challengesView:(int)i {
    NSArray *a = self.lowestFactors;
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a];
    v.titleLabel.text = @"Challenges";
    v.currentGrade.text = @"Current Grade";
    v.gradeLabel.text = self.gradeLetter;
    [self.scrollView addSubview:v];
}


- (void)goalView:(int)i  {
    

    
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a andGoal:self.fetchedAnswers.specificFocus];
    v.titleLabel.text = @"Goal";
    v.currentGrade.text = @"Desired Grade";
    NSString *dG = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    
    v.gradeLabel.text = dG;
    
    v.quoteLabel.text = @"Hey you kids are probably saying to yourselves: I'm gonna go out there and grab the world by the tail! and wrap it around and pull it down and put it in my pocket. Well I'm here to tell you that you're probably going to find out, as you go out there, that you're not going to amount to jack squat!";
    [self.scrollView addSubview:v];
}

- (void)trackingProgress:(int)i {
    
    NSArray *a = @[self.fetchedAnswers.trackingProgressOne, self.fetchedAnswers.trackingProgressTwo, self.fetchedAnswers.trackingProgressThree];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a andQuote:@"Balls"];
    v.currentGrade.text = @"Desired Grade";
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.titleLabel.text = @"Tracking Progress";
    v.quoteLabel.text = @"I'm saying I did an ocular assessment of the situation garnered that he was not a security risk and I cleared him for passage.";
    [self.scrollView addSubview:v];
    
}
- (void)attainableView:(int)i {
    NSArray *a = self.fetchedAttributes;
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a attainableQuote:@"Dicks"];
    v.titleLabel.text = @"Attainable";
    v.quoteLabel.text =  @"Hey you kids are probably saying to yourselves: I'm gonna go out there and grab the world by the tail! and wrap it around and pull it down and put it in my pocket. Well I'm here to tell you that you're probably going to find out, as you go out there, that you're not going to amount to jack squat!";
    
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    [v.bottomButton setTitle:@"Click For Your Positive Attributes" forState:UIControlStateNormal];
    [self.scrollView addSubview:v];
}
- (void)realisticView:(int)i {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                                 andIndex:i andData:a isRealstic:YES];
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    [self.scrollView addSubview:v];
}
- (void)completionDateView:(int)i {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    CompletionDateView *v = [[CompletionDateView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)];
    
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    
    [self.scrollView addSubview:v];
}
- (void)supportTeamView:(int)i  {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    SupportTeamView *v = [[SupportTeamView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)];
    
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    v.firstSupport.text = self.fetchedAnswers.firstSupport;
    v.secondSupport.text = self.fetchedAnswers.secondSupport;
    v.thirdSupport.text = self.fetchedAnswers.thirdSupport;
    
    [self.scrollView addSubview:v];
}
- (void)finalTipsView:(int)i {
    NSArray *a = [[self.lowestFactors reverseObjectEnumerator] allObjects];
    
    AnalysisView *v = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight)
                                             andFinalTips:nil];
    v.gradeLabel.text = [self getDesiredGradeString:[self.fetchedAnswers.desiredGrade intValue]];
    v.currentGrade.text = @"Desired Grade";
    
    [self.scrollView addSubview:v];
}




#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
    
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



@end
