//
//  QuestionView.m
//  life-grade
//
//  Created by scott mehus on 3/25/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "QuestionView.h"
#import "CollectionCell.h"
#import "SimpleCoverFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"
#import "HATransitionController.h"
#import "HATransitionLayout.h"
#import "HAPaperCollectionViewController.h"
#import "GradeCell.h"
#import "Grade.h"


#define kOffset 10.0

@interface QuestionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SimpleCoverFlowLayout *simpleLayout;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSMutableArray *grades;

@property (nonatomic, assign) int draggedIndex;

@property (nonatomic, assign) CGRect selectedCellDefaultFrame;
@property (nonatomic, assign) CGAffineTransform selectedCellDefaultTransform;

@property (nonatomic, assign) CGRect *screenRect;
@property (nonatomic, assign) CGPoint cellCenter;
@property (nonatomic, assign) BOOL isGrown;
@property (nonatomic, assign) BOOL gestureBegan;
@property (nonatomic, strong) UIPanGestureRecognizer *dragGesture;
@property (nonatomic, strong) UIView *gradeView;

@property (nonatomic, strong) HACollectionViewLargeLayout *largeLayout;
@property (nonatomic, strong) HACollectionViewSmallLayout *smallLayout;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, assign) BOOL isBig;

@property (nonatomic, strong) UILabel *directions;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) Grade *selectedGrade;
@property (nonatomic, strong) GradeCell *selectedGradeCelll;



@end

#define CELL_INSET 140

@implementation QuestionView {
    
    CGFloat grownCellWidth;
    CGFloat grownCellHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"JUST INIT");
        [self setUpView];
    }
    return self;
}

- (id)initWithQuestion:(Grade *)grade {
    
    self.grade = grade;
    
    self = [super init];
    if (self == nil) {
        

        NSLog(@"INIT WITH QUESTION");
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




- (void)setUpView {
    

    
    NSLog(@"WINDOW  %f question %@ INDEX %@", self.frame.origin.x, self.grade, self.theIndexPath);
    
   
    
    
    _smallLayout = [[HACollectionViewSmallLayout alloc] init];
    _largeLayout = [[HACollectionViewLargeLayout alloc] init];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
//    _mainView.clipsToBounds = YES;
//    _mainView.layer.cornerRadius = 4;
//    [self insertSubview:_mainView belowSubview:_collectionView];
//    
    self.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
    
    self.gestureBegan = NO;
    

    

    self.isGrown = NO;
    NSArray *ary = @[@{@"grade" : @"A+", @"GradeNum" : @10},
                     @{ @"grade" : @"A", @"GradeNum" : @9.5},
                     @{@"grade" : @"A-", @"GradeNum" : @9},
                     @{@"grade" : @"B+", @"GradeNum" : @8.7},
                     @{@"grade" : @"B", @"GradeNum" : @8},
                     @{@"grade" : @"B-", @"GradeNum" : @8.3},
                     @{@"grade" : @"C+", @"GradeNum" : @7.7},
                     @{@"grade" : @"C", @"GradeNum" : @7.5},
                     @{@"grade" : @"C-", @"GradeNum" : @7.3},
                     @{@"grade" : @"D+", @"GradeNum" : @6.7},
                     @{@"grade" : @"D", @"GradeNum" : @6.5},
                     @{@"grade" : @"D-", @"GradeNum" : @6.3},
                     @{@"grade" : @"F", @"GradeNum" : @5.7}];

    self.grades = [[NSMutableArray alloc] initWithCapacity:20];
    __block NSUInteger count = 0;
    [ary enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        count++;
        Grade *grade = [[Grade alloc] init];
        NSDictionary *dict = obj;
        grade.grade = [dict objectForKey:@"grade"];
        grade.buttonHidden = YES;
        grade.gradeSelected = NO;
        grade.gradeNum = [dict objectForKey:@"GradeNum"];
        NSLog(@"gradenum %@", grade.gradeNum);
        [self.grades addObject:grade];
        
    }];
    self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    // DRAG TO BUILD
//    self.dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pressDetected:)];
//    self.dragGesture.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gradeSelected:)];

   
//    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
//    UICollectionViewFlowLayout *coverFlow = [[UICollectionViewFlowLayout alloc] init];
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    self.simpleLayout = [[SimpleCoverFlowLayout alloc] init];

    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.simpleLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, - CELL_INSET, 0, 0);
    self.collectionView.clipsToBounds = NO;
    self.collectionView.userInteractionEnabled = YES;
//    [self addGestureRecognizer:self.dragGesture];
    [self.collectionView addGestureRecognizer:tap];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GradeCell" bundle:nil] forCellWithReuseIdentifier:@"GradeCell"];
    
    [self addSubview:self.collectionView];
    
    self.isBig = NO;
    
    self.directions = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 150, 300, 150, 100)];
    self.directions.text = @"Select your grade!";
    self.directions.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    self.directions.textColor = [UIColor whiteColor];
    self.directions.numberOfLines = 0;
    self.directions.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.directions];
    
    UILabel *questionTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 150,50, 150, 100)];
    questionTitle.text = self.grade.question;
    questionTitle.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    questionTitle.textColor = [UIColor whiteColor];
    questionTitle.numberOfLines = 0;
    questionTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:questionTitle];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 150, 400, 100, 50)];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    

    
}

- (void)gradeSelected:(UITapGestureRecognizer *)recognizer {
    
    if (self.selectedGrade) {
        self.selectedGrade.gradeSelected = NO;
        self.selectedGradeCelll.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0];
    }
    
    CGPoint pt = [recognizer locationInView:self.collectionView];
    NSIndexPath *idx = [self.collectionView indexPathForItemAtPoint:pt];
    
    GradeCell *cell = cell = (GradeCell *)[self.collectionView cellForItemAtIndexPath:idx];
    self.selectedGradeCelll = cell;
    Grade *grade = [self.grades objectAtIndex:idx.row];
    self.selectedGrade = grade;
    grade.gradeSelected = YES;
    cell.backgroundColor = [UIColor greenColor];

    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.grades.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
   GradeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GradeCell" forIndexPath:indexPath];
    
    cell.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    cell.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0];
    cell.layer.cornerRadius = 8.0f;
    cell.clipsToBounds = NO;
    cell.userInteractionEnabled = YES;
    
    Grade *grade = [self.grades objectAtIndex:indexPath.row];
    
    UIButton *clickedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];    
    cell.grade.text = grade.grade;
    cell.grade.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
    [cell.doneButton addTarget:self action:@selector(gradeSelected) forControlEvents:UIControlEventTouchUpInside];
    cell.doneButton.frame = CGRectMake(0, 300, 320, 50);
    [cell.doneButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    
    if (grade.gradeSelected) {
        cell.backgroundColor = [UIColor greenColor];
    }
    

    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected item");

        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // Change flow layout
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
            _collectionView.backgroundColor = [UIColor blackColor];
            
            // Transform to zoom in effect
            _mainView.transform = CGAffineTransformScale(_mainView.transform, 0.96, 0.96);
        } completion:^(BOOL finished) {

        }];
}


- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView
                        transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    HATransitionLayout *transitionLayout = [[HATransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isBig) {

        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.collectionView.pagingEnabled = YES;
        return CGSizeMake(self.frame.size.width, self.frame.size.height);
//        return CGSizeMake(grownCellWidth, grownCellHeight);
    
    } else {
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, - CELL_INSET, 0, 100);
    self.collectionView.pagingEnabled = NO;
    return CGSizeMake(200, 200);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
  
    
    return UIEdgeInsetsMake(-10, 10, 0, 10);
}

- (void)nextPressed {
    
    NSLog(@"NEXT PRESSED");
    [self.delegate didPickAnswer:self.theIndexPath withGrade:self.selectedGrade];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && gestureRecognizer == self.dragGesture) {
        
        UIPanGestureRecognizer *panGest = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint velocity = [panGest velocityInView:self];
        return ABS(velocity.x) > ABS(velocity.y);
        
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.dragGesture) {
        return NO;
    }
    
    return YES;
}


- (void)pressDetected:(UIPanGestureRecognizer *)recognizer
{
    
 
    if ([self gestureRecognizerShouldBegin:self.dragGesture]) {

        CGPoint pt = [recognizer locationInView:self.collectionView];
        CGFloat xRatio = pt.x/self.window.frame.size.width;
        CGFloat yRatio = pt.x/ self.window.frame.size.height;
        NSIndexPath *idx = [self.collectionView indexPathForItemAtPoint:pt];
        CGPoint translation = [recognizer translationInView:self];
        CGPoint vel = [recognizer velocityInView:self.collectionView];
        NSLog(@"VELOCITY %@", NSStringFromCGPoint(vel));
        CGFloat transRatioX = translation.x / self.window.frame.size.width;
    
        GradeCell *cell = cell = (GradeCell *)[self.collectionView cellForItemAtIndexPath:idx];
        Grade *grade = [self.grades objectAtIndex:idx.row];
        cell.clipsToBounds = NO;
        CGFloat originalY;

    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"<<<<<<<<<< Tab en Cell");
        self.gestureBegan = YES;
        
//        if (self.isGrown == NO) {
//            self.selectedCellDefaultFrame = cell.frame;
//            self.selectedCellDefaultTransform = cell.transform;
//            
//            //[self.collectionView.collectionViewLayout invalidateLayout];
//            self.isBig = YES;
//            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
//
//   
//        }

        
        
        self.selectedCellDefaultFrame = cell.frame;
        
        originalY = cell.frame.origin.y;
        //NSLog(@"original y %f", originalY);
        
        self.gradeView = [[UIView alloc] initWithFrame:cell.frame];
        self.gradeView.backgroundColor = [UIColor whiteColor];
        //[self.collectionView addSubview:self.gradeView];
        
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        

            //NSLog(@"XRATIO %f YRATIO %f WINDOW %F POINT %f Translation %f WINDOW %f", xRatio, yRatio, self.bounds.origin.x, pt.x, transRatioX, translation);
            /*
             cell.center = CGPointMake(pt.x, cell.center.y);
             */

            CGRect mWindow = self.window.frame;
            self.cellCenter = cell.center;
            CGFloat cellContentY  = 200 + self.collectionView.contentOffset.y;
        
            [UIView transitionWithView:self.collectionView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
//                                NSLog(@"NIMATIOON");
                         
                                
                                if (self.isBig == NO) {
                                    
                                    // set up view
                                    
                                    self.directions.hidden = YES;
                                    
                                    grownCellWidth = translation.x *12 + 200;
                                    grownCellHeight = translation.x*24 + 200;
                                    
                                    cell.doneButton.hidden = NO;
                             
                                    self.selectedCellDefaultFrame = cell.frame;
                                    self.selectedCellDefaultTransform = cell.transform;
                                    
                                    if (pt.x > 200 & vel.x > 0) {
                                        self.isBig = YES;
                                        [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
                                    }
                                   
                                } else if (self.isBig == YES && vel.x < 0) {
                                    
                                    self.isBig = NO;
                                    cell.doneButton.hidden = YES;
                                    [self.collectionView reloadData];
                                    //self.collectionView.contentInset = UIEdgeInsetsMake(0, - CELL_INSET, 0, 0);
                                    [self.collectionView setCollectionViewLayout:self.simpleLayout animated:YES];
                                    [self.collectionView reloadData];
                                }
                                
                                
                                // ****old way of doing it
                                /*
                                cell.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0f, 0.0f, 0.0f);
                                if (cell.frame.size.width < 250) {
                                    cell.frame = CGRectMake(100, cellContentY - translation.x*2.5, 200 + translation.x*2, 200 + translation.x*4);
                                } else if (cell.frame.size.width > 250) {
                                    cell.frame = CGRectMake(100, self.collectionView.contentOffset.y, self.frame.size.width, self.frame.size.height);
                                } else if (cell.frame.size.width == self.frame.size.width ) {
                                    NSLog(@"Do Nothing");
                                }
                                */
                                
                                

                                
                            }
                            completion:^(BOOL finished) {
                            
                                
                            
                            }];
                                
                          
        
        
        
    
    }
    
    //9
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        
        self.gestureBegan = NO;
        }
    }
    
}







@end
