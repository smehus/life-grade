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

@interface FinalAnalysisViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSArray *fetchedAttributes;
@property (nonatomic, strong) NSString *gradeLetter;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *lowestFactors;
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
    barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    [self fetchGrades];
    [self fetchAnswers];
    [self fetchAttributes];

    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight *8);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.layer.masksToBounds = NO;
    self.scrollView.layer.shouldRasterize = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    [self drawFirstView];
    
    
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
    [self saveToParse];
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

- (void)drawFirstView {
    
    for (int i = 0; i <= 8; i++) {
        
        AnalysisView *theView = [[AnalysisView alloc] initWithFrame:CGRectMake(0, screenHeight * i, screenWidth, screenHeight) andIndex:i];
        [self.scrollView addSubview:theView];
    }

    
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
    NSLog(@"FINALDESIRE %@", self.fetchedAnswers.desiredGrade);
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
