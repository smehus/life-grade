//
//  AttributesViewController.m
//  life-grade
//
//  Created by scott mehus on 6/22/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AttributesViewController.h"
#import "AttributesCell.h"
#import <POP/POP.h>
#import "FinalGradeViewController.h"
#import "SWRevealViewController.h"

@interface AttributesViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedAttributes;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;

@end

@implementation AttributesViewController

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.contentMode = UIViewContentModeScaleAspectFit;
//    bg.frame = CGRectMake(0, 0, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    
    
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    
    
    self.selectedAttributes = [[NSMutableArray alloc] initWithCapacity:10];
    self.title = @"Attributes";
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
    lay.minimumInteritemSpacing = 1.0f;
    lay.minimumLineSpacing = 1.0f;
    CGRect colRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:colRect collectionViewLayout:lay];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);

    [self.collectionView registerClass:[AttributesCell class] forCellWithReuseIdentifier:@"Cell"];
    

    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)];
    [next setTitle:@"Done"];
    [next setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = next;
    
    
    [self.view addSubview:self.collectionView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)doneButton {
    
    NSLog(@"***DONE PRESSED");
    FinalGradeViewController *finalController = [[FinalGradeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalController];
    [self.revealViewController setFrontViewController:nav];
    

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AttributesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.headerLabel.text = @"BallsDick";
    cell.layer.cornerRadius = 8.0f;
    cell.layer.borderWidth = 3.0f;
    cell.layer.borderColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0].CGColor;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize s = CGSizeMake(self.collectionView.frame.size.width/2 - 4, self.collectionView.frame.size.width/2);
    return s;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SELECTED CELL %@", indexPath);
    
    AttributesCell *cell = (AttributesCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    
    CGFloat rect = self.collectionView.frame.size.width/2 - 4;
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, rect*.95, rect*.95)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, rect, rect)];
    anim.springBounciness = 20.0f;
    anim.springSpeed = 2.0f;
    [cell.layer pop_addAnimation:anim forKey:@"size"];
    
}


@end
