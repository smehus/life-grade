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


@interface FinalAnalysisViewController ()
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSArray *fetchedAttributes;
@property (nonatomic, strong) NSString *gradeLetter;



@end

@implementation FinalAnalysisViewController {
    
    MainAppDelegate *del;
    float finalGradeNum;
    NSString *fontName;
    UIView *firstView;
    UIView *secondView;
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
    
    fontName = LIGHT_FONT;
    
    self.title = @"Analysis";
    
    self.view.backgroundColor = [UIColor whiteColor];
    del = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    [self fetchAnswers];
    [self fetchAttributes];

    

    [self drawGradeView];
    [self drawSecondView];
    [self addAnswersButton];
}

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
    
    self.fetchedAnswers = [foundObjects lastObject];
    [self saveToParse];
    NSNumber *num = self.fetchedAnswers.finalGrade;
    float balls = [num floatValue];
    NSLog(@"FINAL GRADE %f", balls);
    finalGradeNum = balls/100;
    
    [self calculateGrade];
    
}

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


- (void)drawGradeView {
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    firstView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    firstView.layer.borderWidth = 1.0f;
    
    UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    gradeLabel.textAlignment = NSTextAlignmentCenter;
    gradeLabel.textColor = [UIColor redColor];
    gradeLabel.text = self.gradeLetter;
    gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:98];
    [firstView addSubview:gradeLabel];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeLabel.frame) + 20, 10, 200, 50)];
    currentGrade.text = @"Final Life+Grade";
    currentGrade.font = [UIFont fontWithName:fontName size:24];
    [firstView addSubview:currentGrade];
    
    
    [self.view addSubview:firstView];
}

- (void)drawSecondView {
    
    secondView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstView.frame) + 5, self.view.frame.size.width, 150)];
    secondView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    secondView.layer.borderWidth = 1.0f;
    
    UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 75)];
    gradeLabel.textAlignment = NSTextAlignmentCenter;
    gradeLabel.textColor = [UIColor redColor];
    
    int dg = [self.fetchedAnswers.desiredGrade intValue];
    gradeLabel.text = [self getDesiredGradeString:dg];
    gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:75];
    [secondView addSubview:gradeLabel];
    
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeLabel.frame) + 20, 10, 200, 50)];
    currentGrade.text = @"Desired Life+Grade";
    currentGrade.font = [UIFont fontWithName:fontName size:24];
    [secondView addSubview:currentGrade];
    
    
    [self.view addSubview:secondView];
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

- (void)addAnswersButton {
    
    UIColor *color = GREEN_COLOR;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, CGRectGetMaxY(secondView.frame) + 25, self.view.frame.size.width, 50)];
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
