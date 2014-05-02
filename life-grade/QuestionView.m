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

#define kOffset 10.0

@interface QuestionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SimpleCoverFlowLayout *simpleLayout;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSArray *grades;

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

@end

#define CELL_INSET 100

@implementation QuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpView];
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
    
    NSLog(@"WINDOW  %f", self.frame.origin.x);
    
    _smallLayout = [[HACollectionViewSmallLayout alloc] init];
    _largeLayout = [[HACollectionViewLargeLayout alloc] init];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    [self insertSubview:_mainView belowSubview:_collectionView];
    
    self.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
    
    self.gestureBegan = NO;

    self.isGrown = NO;
    self.grades = @[@"A+", @"A", @"A-", @"B+", @"B", @"B-", @"C+", @"C", @"C-", @"D+", @"D", @"D-", @"F"];
    self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    
    self.dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pressDetected:)];
    self.dragGesture.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    UICollectionViewFlowLayout *coverFlow = [[UICollectionViewFlowLayout alloc] init];
    
    self.simpleLayout = [[SimpleCoverFlowLayout alloc] init];
    /*
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 200, kOffset, self.frame.size.width, self.frame.size.height - 88) collectionViewLayout:self.simpleLayout];
     */
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.simpleLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, - CELL_INSET, 0, 0);
    self.collectionView.clipsToBounds = NO;
    
    [self addGestureRecognizer:self.dragGesture];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [self addSubview:self.collectionView];
    

    
    /*
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 375, self.frame.size.width, 50)];
    [self.nextButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setTitle:@"Next Question" forState:UIControlStateNormal];
    [self addSubview:self.nextButton];
    */
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.grades.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
   CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    cell.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0];
    cell.layer.cornerRadius = 8.0f;
    cell.text.text = self.grades[indexPath.row];
    cell.clipsToBounds = NO;
    cell.userInteractionEnabled = YES;
    
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
    
    if (self.collectionView.collectionViewLayout == _largeLayout) {
        NSLog(@"***large layout");
        return CGSizeMake(self.frame.size.width, self.frame.size.height);
        
    } else {
    
    return CGSizeMake(200, 200);
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(-10, 10, 0, 10);
}

- (void)nextPressed {
    
    NSLog(@"NEXT PRESSED");
    [self.delegate didPickAnswer:self.theIndexPath];
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
        
        CGFloat transRatioX = translation.x / self.window.frame.size.width;
    
        CollectionCell *cell = cell = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:idx];
        cell.clipsToBounds = NO;
        CGFloat originalY;

    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"<<<<<<<<<< Tab en Cell");
        self.gestureBegan = YES;
        
        if (self.isGrown == NO) {
            self.selectedCellDefaultFrame = cell.frame;
            self.selectedCellDefaultTransform = cell.transform;
            
            
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];

   
        }

        
        
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
                              duration:0.2
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
//                                NSLog(@"NIMATIOON");
                         
                                

                                
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
