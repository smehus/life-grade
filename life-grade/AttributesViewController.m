//
//  AttributesViewController.m
//  life-grade
//
//  Created by scott mehus on 6/22/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AttributesViewController.h"
#import "AttributesCell.h"

@interface AttributesViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

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
    
    self.navigationController.title = @"Attributes";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
    lay.minimumInteritemSpacing = 1.0f;
    lay.minimumLineSpacing = 1.0f;
    CGRect colRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:colRect collectionViewLayout:lay];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[AttributesCell class] forCellWithReuseIdentifier:@"Cell"];
    

    
    
    [self.view addSubview:self.collectionView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AttributesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
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
    
    AttributesCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    
    
    
}


@end
