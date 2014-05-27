//
//  MenuViewController.m
//  life-grade
//
//  Created by scott mehus on 3/23/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "DesiredGradeViewController.h"
#import "PickDesiredGradeController.h"

@interface MenuViewController ()


@property (nonatomic, strong) SWRevealViewController *myRevealController;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.titleArray = @[@"Grading", @"Desired Grade", @"My Grade", @"About"];
    
    NSLog(@"MENU LOADED");
     self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    [super viewDidLoad];
    self.myRevealController = [self revealViewController];
    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    NSLog(@"MENU APPEARED");
    
     self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

    

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
     tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    return self.titleArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
     tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];

    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        DesiredGradeViewController *desiredView = [[DesiredGradeViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desiredView];
        [self.myRevealController pushFrontViewController:nav animated:YES];
        
    } else if (indexPath.row == 1) {
        
        PickDesiredGradeController *desiredController = [[PickDesiredGradeController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desiredController];
        [self.myRevealController pushFrontViewController:nav animated:YES];
    }   
    
}



@end
