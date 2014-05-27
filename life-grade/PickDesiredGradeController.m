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

@interface PickDesiredGradeController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) CoverFlowLayout *layout;


@end

@implementation PickDesiredGradeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    
    
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    self.layout = [[CoverFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = self.layout;
    
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
//    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
//    UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
//    self.collectionView.backgroundView = bgView;
    
    self.view.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    
    
    cell.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0];
    cell.layer.cornerRadius = 4.0f;
    cell.text.text = @"balls";
    
    
    return cell;
    
}



@end
