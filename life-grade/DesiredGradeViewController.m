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




@end



@implementation DesiredGradeViewController {
    
    NSMutableArray *items;
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
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    

    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    NSLog(@"navbar %@ : navItem %@", self.navigationController, self.navigationController);
    
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:12];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [self.collectionView addGestureRecognizer:tapGest];
    
    
    //SWRevealViewController *revealController = self.revealViewController;
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    

    self.revealButton = barbut;
    

    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
   
   
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    self.layout = [[CoverFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    items = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 10; i++) {
        
        [items addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [items count];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0];
    cell.layer.cornerRadius = 4.0f;
    
    cell.text.text = items[indexPath.row];
    
    return cell;
    
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
        
//        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//        [UIView transitionWithView:cell
//                          duration:0.2
//                           options:UIViewAnimationOptionTransitionFlipFromLeft
//                        animations:^{
//                            collectionView.scrollEnabled = YES;
//                            [cell setFrame:self.selectedCellDefaultFrame];
//                            cell.transform = self.selectedCellDefaultTransform;
//                            [view removeFromSuperview];
//                        }
//                        completion:^(BOOL finished) {
//                            self.selectedCellDefaultFrame = CGRectZero;
//                            //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                        }];
        
        return NO;
    }
    else {
        return YES;

    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    collectionView.scrollEnabled = NO;
    

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    [cell.superview bringSubviewToFront:cell];
    self.selectedCellDefaultFrame = cell.frame;
    self.selectedCellDefaultTransform = cell.transform;
    
    QuestionView *view = [[QuestionView alloc] initWithFrame:self.view.frame];
    view.delegate = self;
    view.theIndexPath = indexPath;

//    HAViewController *view = [[HAViewController alloc] init];
//    view.view.frame = self.view.frame;
//    
//    
    
    [UIView transitionWithView:cell
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [cell setFrame:collectionView.bounds];
                        cell.transform = CGAffineTransformMakeRotation(0.0);
                        [cell addSubview:view];
//                        [self addChildViewController:view];
//                        [cell addSubview:view.view];
//                        [view didMoveToParentViewController:self];
                    }
                    completion:^(BOOL finished) {
                        self.isGrown = YES;
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

#pragma mark - QuestonView Delegate


- (void)didPickAnswer:(NSIndexPath *)idx {
    
    NSLog(@"DID PICK ANSWER %@", idx);
    self.shouldDeselectCell = YES;
    NSIndexPath *path = [NSIndexPath indexPathForRow:idx.row+1 inSection:0];
    [self collectionView:self.collectionView shouldSelectItemAtIndexPath:idx];
    if (idx.row <= 11) {
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    
}





@end
