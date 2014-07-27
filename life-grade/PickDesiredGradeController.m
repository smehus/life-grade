//
//  PickDesiredGradeController.m
//  life-grade
//
//  Created by scott mehus on 5/19/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "PickDesiredGradeController.h"
#import "SWRevealViewController.h"
#import "CoverFlowLayout.h"
#import "CollectionCell.h"
#import "ActionPlanViewController.h"
#import "DesiredCell.h"
#import "MainAppDelegate.h"
#import "Answers.h"

@interface PickDesiredGradeController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) CoverFlowLayout *layout;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@property (nonatomic, strong) NSArray *gradeArray;
@property (nonatomic, strong) NSNumber *selectedGrade;
@property (nonatomic, strong) Answers *fetchedAnswers;

@property (nonatomic, strong) NSIndexPath *selectedCell;


@end

@implementation PickDesiredGradeController {
    
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
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    [self performFetch];
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    self.gradeArray = @[@{@"grade" : @"A+", @"GradeNum" : @12},
                     @{ @"grade" : @"A", @"GradeNum" : @11},
                     @{@"grade" : @"A-", @"GradeNum" : @10},
                     @{@"grade" : @"B+", @"GradeNum" : @9},
                     @{@"grade" : @"B", @"GradeNum" : @8},
                     @{@"grade" : @"B-", @"GradeNum" : @7},
                     @{@"grade" : @"C+", @"GradeNum" : @6},
                     @{@"grade" : @"C", @"GradeNum" : @5},
                     @{@"grade" : @"C-", @"GradeNum" : @4},
                     @{@"grade" : @"D+", @"GradeNum" : @3},
                     @{@"grade" : @"D", @"GradeNum" : @2},
                     @{@"grade" : @"D-", @"GradeNum" : @1},
                     @{@"grade" : @"F", @"GradeNum" : @0}];
    
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
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    self.title = @"Desired Grade";
    
    self.revealButton = barbut;
    
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CoverFlowLayout *coverLayot = [[CoverFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 100, 0);
    
    [self.collectionView registerClass:[DesiredCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.collectionView];
    
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



- (void)finishedGrading {
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    
    ActionPlanViewController *actionPlan = [[ActionPlanViewController alloc] init];
    actionPlan.managedObjectContext = self.managedObjectContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:actionPlan];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.revealViewController setFrontViewController:nav];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gradeArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DesiredCell *cell = (DesiredCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.cornerRadius = 8.0f;
    cell.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];

    if (self.fetchedAnswers.desiredGrade) {
        NSLog(@"desired : %@", self.fetchedAnswers.desiredGrade);
        self.selectedCell = [NSIndexPath indexPathForRow:[self.fetchedAnswers.desiredGrade intValue] inSection:0];
        if (indexPath.row == self.selectedCell.row) {
            
            cell.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
            cell.gradeLabel.textColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
            
        }
    }
    
    cell.gradeLabel.text = [[self.gradeArray objectAtIndex:indexPath.row] objectForKey:@"grade"];    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"DID SELECT %@", indexPath);

    DesiredCell *oldCell = (DesiredCell*)[collectionView cellForItemAtIndexPath:self.selectedCell];
    oldCell.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    oldCell.gradeLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
    
    DesiredCell *cell = (DesiredCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
    cell.gradeLabel.textColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    self.selectedCell = indexPath;
    
    self.fetchedAnswers.desiredGrade = [NSNumber numberWithInteger:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize s = CGSizeMake(150, 150);
    return s;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}



@end
