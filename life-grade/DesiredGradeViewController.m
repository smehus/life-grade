//
//  DesiredGradeViewController.m
//  SWReveal
//
//  Created by scott mehus on 6/24/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "DesiredGradeViewController.h"
#import "MainAppDelegate.h"
#import "SWRevealViewController.h"
#import "CollectionCell.h"
#import "CoverFlowLayout.h"
#import "QuestionView.h"
#import "HAViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Grade.h"
#import "FinalGradeViewController.h"
#import "ActionPlanViewController.h"
#import "Answers.h"
#import <CoreData/CoreData.h>
#import "PickDesiredGradeController.h"
#import "AttributesViewController.h"
#import "MainAppDelegate.h"
#import "ChecklistViewController.h"
#import "InstructionsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BFPaperButton.h"





@interface DesiredGradeViewController () <UICollectionViewDataSource,
                                            UICollectionViewDelegateFlowLayout,
                                            UICollectionViewDelegate,
                                            QuestionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CoverFlowLayout *layout;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;

@property (nonatomic, assign) CGRect selectedCellDefaultFrame;
@property (nonatomic, assign) CGAffineTransform selectedCellDefaultTransform;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL shouldDeselectCell;

@property (nonatomic, assign) BOOL isGrown;

@property (nonatomic, strong) NSMutableArray *questions;

@property (nonatomic, strong) NSMutableArray *myGrades;

@property (nonatomic, strong) UIBarButtonItem *nextButton;

@property (nonatomic, assign) int *finalGrade;

@property (nonatomic, assign) BOOL didSelect;

@property (nonatomic, strong) Answers *fetchedAnswers;

@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UILabel *stepTitleLabel;

@property (nonatomic, strong) BFPaperButton *continueButton;



@end



@implementation DesiredGradeViewController {
    
    NSMutableArray *items;
    BOOL didFetchAnswers;
    MainAppDelegate *delegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.managedObjectContext = delegate.managedObjectContext;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    delegate = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = delegate.managedObjectContext;
    }

    self.revealViewController.panGestureRecognizer.enabled = YES;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    didFetchAnswers = NO;
    self.didSelect = NO;
    
    self.myGrades = [[NSMutableArray alloc] initWithCapacity:1];
    self.questions = [[NSMutableArray alloc] initWithCapacity:10];
    
    
    // GET QUESTIONS
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *ary = [dict objectForKey:@"questions"];
    [ary enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
       
        Grade *grade = [[Grade alloc] init];
        grade.question = obj[@"question"];
        grade.factorDescription = obj[@"description"];
        
        [self.questions addObject:grade];
        
    }];

    
    NSLog(@"desired context %@", self.managedObjectContext);
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    

    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(0, 0, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:12];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [self.collectionView addGestureRecognizer:tapGest];
    
    
    //SWRevealViewController *revealController = self.revealViewController;
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(finishedGrading)];
    [self.nextButton setTintColor:[UIColor blackColor]];
    self.nextButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    
    [self setTitleView];

    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
   
   
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    self.layout = [[CoverFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    items = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 10; i++) {
        
        [items addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self performFetch];
    
    if (self.fetchedAnswers != nil) {
        NSLog(@"*** loaded old answer");
        
        
        [self setTheFetchedGrades];
        didFetchAnswers = YES;
        self.nextButton.enabled = YES;
        
    }
    
    [self addStepTitle];
}

- (void)addStepTitle {
    
    
    
    self.stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, self.view.frame.size.width, 50)];
    self.stepLabel.text = @"Step One:";
    self.stepLabel.backgroundColor = [UIColor clearColor];
    self.stepLabel.font = FONT_AMATIC_BOLD(50);
    [self.view addSubview:self.stepLabel];

    
    self.stepTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.stepLabel.frame), self.view.frame.size.width, 50)];
    self.stepTitleLabel.text = @"CURRENT GRADE";
    self.stepTitleLabel.backgroundColor = [UIColor clearColor];
    self.stepTitleLabel.font = FONT_AVENIR_BLACK(30);
    [self.view addSubview:self.stepTitleLabel];
    
    
    
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


- (void)setTheFetchedGrades {
    

    for (int i = 0; i < 10; i++) {
        
        NSNumber *var = [self getGradeForIndex:[NSIndexPath indexPathForRow:i inSection:0]];
        var = (var) ? var : [NSNumber numberWithInt:5];
        NSLog(@"***VAR %i %@", i, var);
        Grade *g = [[Grade alloc] init];
        g.gradeNum = var;
        [self.myGrades addObject:g];
        
        
    }
}




- (void)performFetch {
    
    MainAppDelegate *del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.questions.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    Grade *grade = [self.questions objectAtIndex:indexPath.row];
    
    UIImage *checkBox = [UIImage imageNamed:@"CheckBox"];
    UIImage *checkMark = [UIImage imageNamed:@"check_mark"];
    cell.checkmark.image = checkMark;
    cell.checkmark.hidden = YES;
    cell.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0];
    cell.layer.cornerRadius = 4.0f;
    
    __block NSString *textString;
    if (indexPath.row == 0) {
        NSArray *t = [grade.question componentsSeparatedByString:@" "];
        [t enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                textString = obj;
            } else {
            textString = [NSString stringWithFormat:@"%@ \n %@", textString, obj];
            }
        }];
    } else {
        
        textString = grade.question;
    }
    
    cell.text.text = textString;
    
    cell.factorLabel.text = [NSString stringWithFormat:@"Factor #%li", indexPath.row + 1];
    cell.factorLabel.font = FONT_AVENIR_BLACK(30);

    cell.text.font = FONT_AMATIC_BOLD(30);
    cell.gradeLabel.font = FONT_AMATIC_BOLD(24);
    cell.checkbox.image = checkBox;


    
    if (grade.isAnswered) {
        
        cell.checkmark.hidden = NO;
      
    }
    
    if (didFetchAnswers) {
        cell.checkmark.hidden = NO;
        NSNumber *num = [self getGradeForIndex:indexPath];
        cell.gradeLabel.text = [NSString stringWithFormat:@"GRADE %@", num];
    } else {
        cell.gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
        cell.gradeLabel.text = @"Click to grade";
    }
   
    

    return cell;
    
}

//- (NSString *)getQuestionForIndex:(NSIndexPath *)idx {
//    
//    NSString *quest;
//    
//    switch (idx.row) {
//        case 0:
//            quest = [self.questions objectForKey:@"questionOne"];
//            break;
//

//        case 1:
//            quest = [self.questions objectForKey:@"questionTwo"];
//            break;
//            
//        case 2:
//            quest = [self.questions objectForKey:@"questionThree"];
//            break;
//            
//        case 3:
//            quest  = [self.questions objectForKey:@"questionFour"];
//            break;
//            
//        case 4:
//            quest = [self.questions objectForKey:@"questionFive"];
//            break;
//            
//        case 5:
//            quest = [self.questions objectForKey:@"questionSix"];
//            break;
//            
//        case 6:
//            quest = [self.questions objectForKey:@"questionSeven"];
//            break;
//            
//        case 7:
//            quest = [self.questions objectForKey:@"questionEight"];
//            break;
//        
//        case 8:
//            quest = [self.questions objectForKey:@"questionNine"];
//            break;
//            
//        case 9:
//            quest = [self.questions objectForKey:@"questionTen"];
//            break;
//            
//        default:
//            quest = @"Whoops";
//            break;
//    }
//    
//    return quest;
//}

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
            return [NSNumber numberWithInt:10];
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval = CGSizeMake(200, 200);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    

    CGSize itemSize = CGSizeMake(200, 200);
    return UIEdgeInsetsMake(0.0f,
                            (collectionView.bounds.size.width - itemSize.width) / 2.0f,
                            0.0f,
                            (collectionView.bounds.size.width - itemSize.width)/ 2.0f);
    
    
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSArray *subViews = [cell subviews];
    QuestionView *view = [subViews lastObject];

    if (cell.selected && self.shouldDeselectCell == YES) {
        self.shouldDeselectCell = NO;
        cell.selected = NO;
        
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [UIView transitionWithView:cell
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            collectionView.scrollEnabled = YES;
                            [cell setFrame:self.selectedCellDefaultFrame];
                            cell.transform = self.selectedCellDefaultTransform;
                            [view removeFromSuperview];
                        }
                        completion:^(BOOL finished) {
                            self.selectedCellDefaultFrame = CGRectZero;
                            //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
                        }];
        
        return NO;
    }
    else {
        return YES;

    }
    
}

//!!!!: Ballsfacecokdbacfial
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.continueButton.hidden = YES;
    self.collectionView.scrollEnabled = NO;
    
    if (self.didSelect == YES) {
        self.didSelect = NO;
    } else {
        self.didSelect = YES;
    }

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    [cell.superview bringSubviewToFront:cell];
    self.selectedCellDefaultFrame = cell.frame;
    self.selectedCellDefaultTransform = cell.transform;
    NSLog(@"LSKDJFASLDJF %@", [[self.questions objectAtIndex:indexPath.row] question]);
    
    Grade *g = [self.questions objectAtIndex:indexPath.row];
    
//    QuestionView *view = [[QuestionView alloc] initWithQuestion:[self.questions objectAtIndex:indexPath.row]];
    QuestionView *view = [[QuestionView alloc] initWithFrame:CGRectZero andQuestion:g];
    
    Grade *theG = [[Grade alloc] init];
    theG.question = @"Balls";
    view.grade = theG;
    view.delegate = self;
    view.theIndexPath = indexPath;
  
    
    [UIView transitionWithView:cell
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [cell setFrame:collectionView.bounds];
                        cell.transform = CGAffineTransformMakeRotation(0.0);
                        [cell addSubview:view];

                    }
                    completion:^(BOOL finished) {
                        self.isGrown = YES;
                        self.stepTitleLabel.hidden = YES;
                        self.stepLabel.hidden = YES;
                    }];
}

-(void)cellTapped:(UITapGestureRecognizer *)recog {
    CGPoint p = [recog locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath == nil) {
       
    } else {
        
    BOOL select = [self collectionView:self.collectionView shouldSelectItemAtIndexPath:indexPath];
    if (select == YES && cell.selected == NO) {
        
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
}


- (void)flipCellBackAtIndex:(NSIndexPath *)idx {
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:idx];
    NSArray *subViews = [cell subviews];
    QuestionView *view = [subViews lastObject];
    
    cell.selected = NO;
        
    [self.collectionView deselectItemAtIndexPath:idx animated:YES];
    [UIView transitionWithView:cell
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.collectionView.scrollEnabled = YES;
                        [cell setFrame:CGRectMake(100, 100, 100, 100)];
//                        [cell setFrame:self.selectedCellDefaultFrame];
                        cell.transform = self.selectedCellDefaultTransform;
                        [view removeFromSuperview];
                    }
                    completion:^(BOOL finished) {
                        self.selectedCellDefaultFrame = CGRectZero;
                        //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }];
    
    
}

#pragma mark - QuestonView Delegate

- (void)didPickAnswer:(NSIndexPath *)idx withGrade:(Grade *)grade {
    
    self.continueButton.hidden = NO;
    self.collectionView.scrollEnabled = YES;
    self.stepLabel.hidden = NO;
    self.stepTitleLabel.hidden = NO;
    
    Grade *g = [self.questions objectAtIndex:idx.row];
    g.isAnswered = YES;
    
    if (idx.row > 10 ) {
        return;
    }
    
    self.shouldDeselectCell = YES;
    NSIndexPath *path = [NSIndexPath indexPathForRow:idx.row+1 inSection:0];
    [self collectionView:self.collectionView shouldSelectItemAtIndexPath:idx];
    
    CollectionCell *cell = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:idx];
    for (UIView *v in cell.subviews) {
        
        if ([v isKindOfClass:[QuestionView class]]) {
            [v removeFromSuperview];
        }
    }
    
    if (idx.row <= 11) {
        
        if (self.myGrades.count > idx.row && self.myGrades.count > 9) {
            
            [self.myGrades replaceObjectAtIndex:idx.row withObject:grade];
            self.nextButton.enabled = YES;
            
        } else {
            
            NSLog(@"grade %@", grade);
            
            if (self.didSelect) {
                
                [self.myGrades addObject:grade];
                NSLog(@"Add grade %@", grade.gradeNum);
                self.didSelect = NO;
                
            }
          
        }
        
    // scroll to item isn't being called at end - so keeps blue screen
    [self.collectionView reloadData];
        if (idx.row < 9) {
            NSLog(@"faaaaggggs %@", path);
            [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        } else {
            NSLog(@"Ballz");
            [self.collectionView reloadItemsAtIndexPaths:@[idx]];
//            [self.collectionView reloadData];
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
    
    NSLog(@"MY GRADE COUNT %lu", (unsigned long)self.myGrades.count);
    
    if (self.myGrades.count >= 10) {
        
        self.nextButton.enabled = YES;
        if (!self.continueButton) {
            int sub = 0;
            int ret = 0;
            if ([self isIpad] || IS_IPHONE4) {
                ret = 30;
                sub = 40;
            } else {
                sub = 70;
                ret = 50;
            }
            
        self.continueButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - sub, self.view.frame.size.width - 20, ret) raised:NO];
            UIColor *bc = GREEN_COLOR;
            [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
            [self.continueButton setBackgroundColor:bc];
            [[self.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                NSLog(@"button pressed");
                [self finishedGrading];
            }];
            [self.view addSubview:self.continueButton];
        }

    }
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

- (void)finishedGrading {
    

    float finalNum = 0;
    
    for (Grade *g in self.myGrades) {
        
        float value = [g.gradeNum floatValue];
        finalNum = finalNum + value;
        
    }
    
    NSLog(@"FINAL GRADE NUM %f", finalNum);
    
//    FinalGradeViewController *finalController = [[FinalGradeViewController alloc] init];
//    finalController.finalGradeValue = [NSNumber numberWithInteger:finalNum];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalController];
//
    
//    NSLog(@"%@", self.managedObjectContext.persistentStoreCoordinator.managedObjectModel.entities);
    
//    if (self.fetchedAnswers != nil) {
//        [self.managedObjectContext deleteObject:self.fetchedAnswers];
//    }
//    
//    
    if (didFetchAnswers) {
        
        self.fetchedAnswers.questionOne = [[self.myGrades objectAtIndex:0] gradeNum];
        self.fetchedAnswers.questionTwo = [[self.myGrades objectAtIndex:1] gradeNum];
        self.fetchedAnswers.questionThree = [[self.myGrades objectAtIndex:2] gradeNum];
        self.fetchedAnswers.questionFour = [[self.myGrades objectAtIndex:3] gradeNum];
        self.fetchedAnswers.questionFive = [[self.myGrades objectAtIndex:4] gradeNum];
        self.fetchedAnswers.questionSix = [[self.myGrades objectAtIndex:5] gradeNum];
        self.fetchedAnswers.questionSeven = [[self.myGrades objectAtIndex:6] gradeNum];
        self.fetchedAnswers.questionEight = [[self.myGrades objectAtIndex:7] gradeNum];
        self.fetchedAnswers.questionNine = [[self.myGrades objectAtIndex:8] gradeNum];
        self.fetchedAnswers.questionTen = [[self.myGrades objectAtIndex:9] gradeNum];
        self.fetchedAnswers.finalGrade = [NSNumber numberWithInt:finalNum];
        
        
    } else {
    Answers *answers = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:self.managedObjectContext];
    
        answers.questionOne = [[self.myGrades objectAtIndex:0] gradeNum];
        answers.questionTwo = [[self.myGrades objectAtIndex:1] gradeNum];
        answers.questionThree = [[self.myGrades objectAtIndex:2] gradeNum];
        answers.questionFour = [[self.myGrades objectAtIndex:3] gradeNum];
        answers.questionFive = [[self.myGrades objectAtIndex:4] gradeNum];
        answers.questionSix = [[self.myGrades objectAtIndex:5] gradeNum];
        answers.questionSeven = [[self.myGrades objectAtIndex:6] gradeNum];
        answers.questionEight = [[self.myGrades objectAtIndex:7] gradeNum];
        answers.questionNine = [[self.myGrades objectAtIndex:8] gradeNum];
        answers.questionTen = [[self.myGrades objectAtIndex:9] gradeNum];
        answers.finalGrade = [NSNumber numberWithInt:finalNum];
    }
    
    NSString *email = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"email"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"password"];
    
    
//    PFObject *post = [PFObject objectWithClassName:@"Grade"];
//    post[@"questionOne"] = [[self.myGrades objectAtIndex:0] gradeNum];
//    post[@"questionTwo"] = [[self.myGrades objectAtIndex:1] gradeNum];
//    post[@"questionThree"] = [[self.myGrades objectAtIndex:2] gradeNum];
//    post[@"questionFour"] = [[self.myGrades objectAtIndex:3] gradeNum];
//    post[@"questionFive"] = [[self.myGrades objectAtIndex:4] gradeNum];
//    post[@"questionSix"] = [[self.myGrades objectAtIndex:5] gradeNum];
//    post[@"questionSeven"] = [[self.myGrades objectAtIndex:6] gradeNum];
//    post[@"questionEight"] = [[self.myGrades objectAtIndex:7] gradeNum];
//    post[@"questionNine"] = [[self.myGrades objectAtIndex:8] gradeNum];
//    post[@"questionTen"] = [[self.myGrades objectAtIndex:9] gradeNum];
//    
//    if (delegate.currentUser) {
//        post[@"user"] = delegate.currentUser;f
//    } else if (email) {
//        post[@"backupEmail"] = email;
//    } else {
//        
//        NSLog(@"no current user and no user defaults");
//    }
//    
//    [post save];
//    
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    self.stepTitleLabel.hidden = YES;
    self.stepLabel.hidden = YES;

    ChecklistViewController *checklist = [[ChecklistViewController alloc] initWithChecklist:0 andCompletionBlock:^{
        InstructionsViewController *controller = [[InstructionsViewController alloc] initWithViewController:[PickDesiredGradeController class] andCompletionBlock:^{
            PickDesiredGradeController *myDesiredController = [[PickDesiredGradeController alloc] init];
            myDesiredController.managedObjectContext = self.managedObjectContext;
            myDesiredController.finalGradeValue = [NSNumber numberWithInt:finalNum];
    
    
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myDesiredController];
            [self.revealViewController setFrontViewController:nav animated:YES];
            
        }];
        [self.navigationController pushViewController:controller animated:YES];
        
    }];
    [self.navigationController pushViewController:checklist animated:YES];
}






@end
