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

@interface PickDesiredGradeController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) CoverFlowLayout *layout;
@property (nonatomic, strong) UIBarButtonItem *nextButton;


@end

@implementation PickDesiredGradeController

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
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    self.layout = [[CoverFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.collectionViewLayout = self.layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    

    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-10, 10, self.view.bounds.size.width + 50, self.view.bounds.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(didSelectGrade)];
    [self.nextButton setTintColor:[UIColor blackColor]];
    self.nextButton.enabled = YES;
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)didSelectGrade {
    
    ActionPlanViewController *actionController = [[ActionPlanViewController alloc] init];
    actionController.managedObjectContext = self.managedObjectContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:actionController];
    [self.revealViewController setFrontViewController:nav];
    
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval = CGSizeMake(200, 200);
    return retval;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"***DID SELECT GRADE");
    
    ActionPlanViewController *actionController = [[ActionPlanViewController alloc] init];
    actionController.managedObjectContext = self.managedObjectContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:actionController];
    [self.revealViewController setFrontViewController:nav];
    
    
}



@end
