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

#define kOffset 10.0

@interface QuestionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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
    

    self.isGrown = NO;
    self.grades = @[@"A+", @"A", @"A-", @"B+", @"B", @"B-", @"C+", @"C", @"C-", @"D+", @"D", @"D-", @"F"];
    self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    
    UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pressDetected:)];
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
    [self.collectionView addGestureRecognizer:dragGesture];
    self.collectionView.clipsToBounds = NO;
    
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
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCell *cell = (CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.center = CGPointMake(cell.center.y + 50, cell.center.y);
    
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(200, 200);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(-10, 10, 0, 10);
}

- (void)nextPressed {
    
    NSLog(@"NEXT PRESSED");
    [self.delegate didPickAnswer:self.theIndexPath];
}


- (void)pressDetected:(UIPanGestureRecognizer *)recognizer//7
{
    
    
    CGPoint pt = [recognizer locationInView:self.collectionView];
    NSIndexPath *idx = [self.collectionView indexPathForItemAtPoint:pt];
    CGPoint translation = [recognizer translationInView:self];
    
    //8
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"<<<<<<<<<< Tab en Cell");
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        
        CollectionCell *cell = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:idx];
           
            /*
             cell.center = CGPointMake(pt.x, cell.center.y);
             */
            self.selectedCellDefaultFrame = cell.frame;
            self.selectedCellDefaultTransform = cell.transform;
            self.cellCenter = cell.center;
            
            [UIView transitionWithView:cell
                              duration:0.2
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                
                                //cell.frame = CGRectMake(CELL_INSET, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                                
                                 //[cell setCenter:CGPointMake([cell center].x + translation.x, [cell center].y + translation.y)];
                                 [cell setCenter:CGPointMake(cell.center.x + translation.x/2, cell.center.y)];

                                
                            }
                            completion:^(BOOL finished) {
                            
                            
                            
                            }];
        
        

        
    }
    
    //9
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}







@end
