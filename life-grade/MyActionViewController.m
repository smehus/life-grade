//
//  MyActionViewController.m
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "MyActionViewController.h"
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"
#import "HATransitionController.h"
#import "HATransitionLayout.h"
#import "HAPaperCollectionViewController.h"
#import "MainAppDelegate.h"
#import "SWRevealViewController.h"
#import "CoverFlowLayout.h"
#import "CollectionCell.h"
#import "Answers.h"
#import "ChecklistViewController.h"
#import "InstructionsViewController.h"
#import "ActionCell.h"
#import "Grade.h"
#import "QuestionAnswerViewController.h"

@interface MyActionViewController ()  <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ActionCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) CoverFlowLayout *layout;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *lowestFactors;
@property (nonatomic, strong) NSNumber *selectedGrade;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSMutableArray *grades;

@property (nonatomic, strong) NSIndexPath *selectedCell;

@property (nonatomic, strong) HACollectionViewLargeLayout *largeLayout;
@property (nonatomic, strong) HACollectionViewSmallLayout *smallLayout;
@property (nonatomic, strong) UILabel *directionsLabel;
@property (nonatomic, assign) BOOL isLarge;


@property (nonatomic, strong) UIView *info;



@end

@implementation MyActionViewController {
    MainAppDelegate *del;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    self.questions = [[NSMutableArray alloc] initWithCapacity:10];
    self.lowestFactors = [[NSMutableArray alloc] initWithCapacity:3];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *ary = [dict objectForKey:@"questions"];
    [ary enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        Grade *grade = [[Grade alloc] init];
        grade.question = obj[@"question"];
        
        [self.questions addObject:grade];
        
    }];
    
    [self performFetch];
    [self setAnswersArray];
    [self getLowestGrade];
    
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(finishedGrading)];
    [self.nextButton setTintColor:[UIColor blackColor]];
    self.nextButton.enabled = YES;
//    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    
    [self setTitleView];
    
    self.revealButton = barbut;
    
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    _smallLayout = [[HACollectionViewSmallLayout alloc] init];
    _largeLayout = [[HACollectionViewLargeLayout alloc] init];
    
    self.largeLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CoverFlowLayout *coverLayot = [[CoverFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.smallLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 100, 0);
    
    [self.collectionView registerClass:[ActionCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionView];
    
    
    self.directionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 200)];
    self.directionsLabel.text = @"Choose one factor to focus on";

    self.directionsLabel.font = FONT_AVENIR_BLACK(40);
    self.directionsLabel.numberOfLines = 0;
    self.directionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.directionsLabel];
    
    self.info = [[UIView alloc ] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.directionsLabel.frame) + 20, self.view.frame.size.width, 50)];
    // make label with amatic 'bottom three factors'
    self.info.backgroundColor = GREEN_COLOR;
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.info.frame.size.width, 30)];
    l.text = @"Bottom Three Factors";
    l.textAlignment = NSTextAlignmentCenter;
    l.font = FONT_AVENIR_BLACK(18);
    [self.info addSubview:l];
    [self.view addSubview:self.info];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)getLowestGrade {
    
    NSArray *sortedArray;
    sortedArray = [self.grades sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(Grade*)a gradeNum];
        NSNumber *second = [(Grade*)b gradeNum];
        return [first compare:second];
    }];
    
    
    for (int i = 0; i <= 2; i ++) {
        Grade *g = [sortedArray objectAtIndex:i];
        [self.lowestFactors addObject:g];
    }
    [self.collectionView reloadData];
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



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lowestFactors.count;
    
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActionCell *cell = (ActionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 8.0f;
    cell.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    cell.cellDelegate = self;
    cell.nextButton.hidden = YES;
    cell.theIndex = indexPath;
    Grade *g = [self.lowestFactors objectAtIndex:indexPath.row];
    cell.grade = g;
    cell.factorLabel.text = g.question;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected item");
    
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (!self.isLarge) {
            self.directionsLabel.hidden = YES;
            self.info.hidden = YES;
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
            ActionCell *cell = (ActionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.nextButton.hidden = NO;
            
            self.isLarge = YES;
        } else {
           
            [collectionView setCollectionViewLayout:self.smallLayout animated:YES];
            self.isLarge = NO;
            self.directionsLabel.hidden = NO;
            self.info.hidden = NO;
        }
        
        
        // Transform to zoom in effect
        //        _mainView.transform = CGAffineTransformScale(_mainView.transform, 0.96, 0.96);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didPickFactor:(Grade *)grade andIndex:(NSIndexPath *)idx {
    
    self.fetchedAnswers.focusFactor = grade.question;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    
    QuestionAnswerViewController *controller = [[QuestionAnswerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self.navigationController pushViewController:controller animated:YES];
//    [self.revealViewController setFrontViewController:controller];
    [self.revealViewController pushFrontViewController:nav animated:YES];
}




@end
