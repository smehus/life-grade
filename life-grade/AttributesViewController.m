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
#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "MainAppDelegate.h"
#import "Answers.h"
#import "Attributes.h"
#import "FinalAnalysisViewController.h"

@interface AttributesViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedAttributes;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSArray *attributes;

@end

@implementation AttributesViewController {
    
    MainAppDelegate *del;
    
}

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
    
    del = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    self.attributes = [self loadAttributes];
    [self performFetch];
    
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

- (NSArray *)loadAttributes {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *ary = [dict objectForKey:@"attributes"];
    NSArray *attributes = [ary componentsSeparatedByString:@" "];
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:10];
    [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *n = [NSNumber numberWithInteger:idx];
        NSDictionary *dict = @{@"isSelected" : @NO, @"attribute" : obj};
        [a addObject:dict];
    }];
    
    
    return a;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)performFetch {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
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
    NSLog(@"question bitch %@", self.fetchedAnswers.questionEight);
    
}

//!!!!: This fucking works!

- (void)doneButton {
//    FinalGradeViewController *finalController = [[FinalGradeViewController alloc] init];
    
    [self.selectedAttributes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
       
        Attributes *at = [NSEntityDescription insertNewObjectForEntityForName:@"Attributes"
                                                       inManagedObjectContext:self.managedObjectContext];
        at.attribute = obj;
        
    }];
    
    [self finishedGrading];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {

        FinalAnalysisViewController *finalController = [[FinalAnalysisViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalController];
        [self.revealViewController setFrontViewController:nav];
        
    } else {
        
        SignupViewController *signUp = [[SignupViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUp];
        [self.revealViewController setFrontViewController:nav];
   
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.attributes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AttributesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (self.fetchedAnswers) {
        // still have to add attributes to model
        
    }
    
    NSDictionary *dict = self.attributes[indexPath.row];
    
    cell.headerLabel.text = dict[@"attribute"];
    cell.headerLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
    cell.headerLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.cornerRadius = 8.0f;
    cell.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
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
    
    NSDictionary *dict = self.attributes[indexPath.row];
    NSString *att = dict[@"attribute"];
    
    [self.selectedAttributes addObject:att];
    
    CGFloat rect = self.collectionView.frame.size.width/2 - 4;
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, rect*.95, rect*.95)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, rect, rect)];
    anim.springBounciness = 20.0f;
    anim.springSpeed = 2.0f;
    [cell.layer pop_addAnimation:anim forKey:@"size"];
    
}

- (void)finishedGrading {
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    
//    ActionPlanViewController *actionPlan = [[ActionPlanViewController alloc] init];
//    actionPlan.managedObjectContext = self.managedObjectContext;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:actionPlan];
//    //    [self presentViewController:nav animated:YES completion:nil];
//    [self.revealViewController setFrontViewController:nav];
    
}


@end
