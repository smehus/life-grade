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
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"
#import "HATransitionController.h"
#import "HATransitionLayout.h"
#import "HAPaperCollectionViewController.h"
#import "ChecklistViewController.h"
#import "InstructionsViewController.h"
#import "MyActionViewController.h"

@interface PickDesiredGradeController () <UICollectionViewDelegateFlowLayout,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            DesiredCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) CoverFlowLayout *layout;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@property (nonatomic, strong) NSArray *gradeArray;
@property (nonatomic, strong) NSNumber *selectedGrade;
@property (nonatomic, strong) Answers *fetchedAnswers;

@property (nonatomic, strong) NSIndexPath *selectedCell;

@property (nonatomic, strong) HACollectionViewLargeLayout *largeLayout;
@property (nonatomic, strong) HACollectionViewSmallLayout *smallLayout;

@property (nonatomic, assign) BOOL isLarge;


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
    [self constructTitleView];
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    
    [self setTitleView];
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
//    
//    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(finishedGrading)];
//    [self.nextButton setTintColor:[UIColor blackColor]];
//    self.nextButton.enabled = YES;
//    self.navigationItem.rightBarButtonItem = self.nextButton;
//    
    self.title = @"Desired Grade";
    
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
    
    [self.collectionView registerClass:[DesiredCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.collectionView];
    
}

- (void)constructTitleView {
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 50)];
    l.numberOfLines = 0;
    l.lineBreakMode = NSLineBreakByWordWrapping;
    l.textAlignment = NSTextAlignmentCenter;
    l.font = FONT_AMATIC_BOLD(40);
    l.text = @"Choose your desired grade";
    [self.view addSubview:l];
}

- (void)setTitleView {
    
    // TITLE VIEW SET
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
        self.selectedCell = [NSIndexPath indexPathForRow:[self.fetchedAnswers.desiredGrade intValue] inSection:0];
        if (indexPath.row == self.selectedCell.row) {
            
//            cell.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
//            cell.gradeLabel.textColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
            
        }
    }
    cell.cellDelegate = self;
    cell.nextButton.hidden = YES;
    cell.theIndex = indexPath;
    NSString *gradeText = [[self.gradeArray objectAtIndex:indexPath.row] objectForKey:@"grade"];
    NSLog(@"GRADE TEXT %@", gradeText);
    cell.gradeLabel.text = gradeText;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected item");
    
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    DesiredCell *cell = (DesiredCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (!self.isLarge) {
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];

            cell.nextButton.hidden = NO;
            self.isLarge = YES;
            [cell setLargeFrame];
        } else {
            [collectionView setCollectionViewLayout:self.smallLayout animated:YES];
            self.isLarge = NO;
            [cell setSmallFrame];
        }

        
        // Transform to zoom in effect
//        _mainView.transform = CGAffineTransformScale(_mainView.transform, 0.96, 0.96);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didPickGrade:(NSString *)grade andIndex:(NSIndexPath *)idx {
    NSLog(@"DIDPICKGRADE %@ : %li", grade, (long)idx.row);
    self.fetchedAnswers.desiredGrade = [NSNumber numberWithInteger:idx.row];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }

    ChecklistViewController *checklist = [[ChecklistViewController alloc] initWithChecklist:1 andCompletionBlock:^{
        InstructionsViewController *controller = [[InstructionsViewController alloc] initWithViewController:[MyActionViewController class] andCompletionBlock:^{
            
            MyActionViewController *actionPlan = [[MyActionViewController alloc] init];
            actionPlan.managedObjectContext = self.managedObjectContext;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:actionPlan];
            [self.revealViewController setFrontViewController:nav animated:YES];
            
        }];
        [self.navigationController pushViewController:controller animated:YES];
        
    }];
    [self.navigationController pushViewController:checklist animated:YES];
    
}





//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"DID SELECT %@", indexPath);
//
//    DesiredCell *oldCell = (DesiredCell*)[collectionView cellForItemAtIndexPath:self.selectedCell];
//    oldCell.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
//    oldCell.gradeLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
//    
//    DesiredCell *cell = (DesiredCell*)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
//    cell.gradeLabel.textColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
//    self.selectedCell = indexPath;
//    
//    self.fetchedAnswers.desiredGrade = [NSNumber numberWithInteger:indexPath.row];
//}



// USED WITH OLD GRADE SELECTION
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGSize s = CGSizeMake(150, 150);
//    return s;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    
//    return UIEdgeInsetsMake(0, 5, 0, 5);
//}



@end
