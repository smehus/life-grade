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
    UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
    CGRect colRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:colRect collectionViewLayout:lay];
    self.collectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.collectionView.layer.borderWidth = 1.0f;
    [self.collectionView registerClass:[AttributesCell class] forCellWithReuseIdentifier:@"Cell"];
    

    
    
    [self.view addSubview:self.collectionView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AttributesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.headerLabel.text = @"BallsDick";
    return cell;
}



@end
