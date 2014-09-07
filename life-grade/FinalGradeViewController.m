//
//  FinalGradeViewController.m
//  life-grade
//
//  Created by scott mehus on 5/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "FinalGradeViewController.h"
#import "SWRevealViewController.h"
#import <EMAccordionTableViewController/EMAccordionTableViewController.h>
#import "MainAppDelegate.h"
#import "Answers.h"
#import "Grade.h"


@interface FinalGradeViewController () <EMAccordionTableDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) EMAccordionTableViewController *emTableView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSMutableArray *questions;

@end

@implementation FinalGradeViewController {
    
    MainAppDelegate *del;
    
    
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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    [self performFetch];
    self.questions = [[NSMutableArray alloc] initWithCapacity:10];
    [self fetchQuestions];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(0, 0, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    self.title = @"Final Grade";
    
    
    float avg = [self.finalGradeValue floatValue];
    avg = avg/10;
    
//    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
//    [barbut setTintColor:[UIColor blackColor]];
//    self.navigationItem.leftBarButtonItem = barbut;
//    
//    self.revealButton = barbut;
//    [self.revealButton setTarget: self.revealViewController];
//    [self.revealButton setAction: @selector( revealToggle: )];

    

    
    [self setupTableView];
    NSLog(@"final grade %f total %@", avg, self.finalGradeValue);

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
    NSLog(@"question bitch %@", self.fetchedAnswers.questionEight);
    
}

- (void)fetchQuestions {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *ary = [dict objectForKey:@"questions"];
    [ary enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        Grade *grade = [[Grade alloc] init];
        grade.question = obj[@"question"];
        grade.goodResponse = obj[@"goodResponse"];
        
        grade.badResponse = obj[@"badResponse"];
        [self.questions addObject:grade];
        
    }];
}

- (void)setupTableView {
    
    CGRect screenHeight = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);
    self.tableView = [[UITableView alloc] initWithFrame:screenHeight style:UITableViewStylePlain];
    [self.tableView setSectionHeaderHeight:screenHeight.size.height/10];
    self.emTableView = [[EMAccordionTableViewController alloc] initWithTable:self.tableView withAnimationType:EMAnimationTypeBounce];
    [self.emTableView setDelegate:self];
    
    UIColor *sectionsColor = [UIColor colorWithRed:62.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
    UIColor *sectionTitleColor = [UIColor whiteColor];
    UIFont *sectionTitleFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    
    EMAccordionSection *section01 = [[EMAccordionSection alloc] init];
    [section01 setBackgroundColor:sectionsColor];
    [section01 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section01 setTitle:[[self.questions objectAtIndex:0] question]];
    [section01 setTitleFont:sectionTitleFont];
    [section01 setTitleColor:sectionTitleColor];
    [self.emTableView addAccordionSection:section01];
    
    EMAccordionSection *section02 = [[EMAccordionSection alloc] init];
    [section02 setBackgroundColor:sectionsColor];
    [section02 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section02 setTitle:[[self.questions objectAtIndex:1] question]];
    [section02 setTitleColor:sectionTitleColor];
    [section02 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section02];
    
    EMAccordionSection *section03 = [[EMAccordionSection alloc] init];
    [section03 setBackgroundColor:sectionsColor];
    [section03 setTitle:[[self.questions objectAtIndex:2] question]];
    [section03 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section03 setTitleColor:sectionTitleColor];
    [section03 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section03];
    
    EMAccordionSection *section04 = [[EMAccordionSection alloc] init];
    [section04 setBackgroundColor:sectionsColor];
    [section04 setTitle:[[self.questions objectAtIndex:3] question]];
    [section04 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section04 setTitleColor:sectionTitleColor];
    [section04 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section04];
    
    EMAccordionSection *section05 = [[EMAccordionSection alloc] init];
    [section05 setBackgroundColor:sectionsColor];
    [section05 setTitle:[[self.questions objectAtIndex:4] question]];
    [section05 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section05 setTitleColor:sectionTitleColor];
    [section05 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section05];
    
    EMAccordionSection *section06 = [[EMAccordionSection alloc] init];
    [section06 setBackgroundColor:sectionsColor];
    [section06 setTitle:[[self.questions objectAtIndex:5] question]];
    [section06 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section06 setTitleColor:sectionTitleColor];
    [section06 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section06];
    
    EMAccordionSection *section07 = [[EMAccordionSection alloc] init];
    [section07 setBackgroundColor:sectionsColor];
    [section07 setTitle:[[self.questions objectAtIndex:6] question]];
    [section07 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section07 setTitleColor:sectionTitleColor];
    [section07 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section07];
    
    EMAccordionSection *section08 = [[EMAccordionSection alloc] init];
    [section08 setBackgroundColor:sectionsColor];
    [section08 setTitle:[[self.questions objectAtIndex:7] question]];
    [section08 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section08 setTitleColor:sectionTitleColor];
    [section08 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section08];
    
    EMAccordionSection *section09 = [[EMAccordionSection alloc] init];
    [section09 setBackgroundColor:sectionsColor];
    [section09 setTitle:[[self.questions objectAtIndex:8] question]];
    [section09 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section09 setTitleColor:sectionTitleColor];
    [section09 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section09];
    
    EMAccordionSection *section10 = [[EMAccordionSection alloc] init];
    [section10 setBackgroundColor:sectionsColor];
    [section10 setTitle:[[self.questions objectAtIndex:9] question]];
    [section10 setItems:[self requestGradeForGrade:[NSNumber numberWithInt:5]]];
    [section10 setTitleColor:sectionTitleColor];
    [section10 setTitleFont:sectionTitleFont];
    [self.emTableView addAccordionSection:section10];


    
//    NSMutableArray *sections = [[NSArray alloc] initWithObjects:section01, section02, section03, nil];
    
    [self.view addSubview:self.emTableView.tableView];
    
    
}

- (NSMutableArray *)requestGradeForGrade:(NSNumber *)num {
    
    
    
    return [NSMutableArray arrayWithArray:@[@"Balls"]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
//    NSMutableArray *ary = [self requestGradeForGrade:[self getGradeForIndex:indexPath]];
//    NSString *ans = ary[0];
//    cell.textLabel.text = ans;
//    cell.textLabel.textColor = [UIColor blackColor];
    
    Grade *g = self.questions[indexPath.row];
    cell.textLabel.text = g.badResponse;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"BALLZ");
}


- (NSNumber *)getGradeForIndex:(NSIndexPath *)idx {
    
    switch (idx.row) {
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
            return [NSNumber numberWithInt:5];
            break;
    }
}




@end
