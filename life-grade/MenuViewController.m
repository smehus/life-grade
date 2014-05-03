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

@interface MenuViewController ()


@property (nonatomic, strong) SWRevealViewController *myRevealController;

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
    return 5;
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

    cell.textLabel.text = @"Item";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        DesiredGradeViewController *desiredView = [[DesiredGradeViewController alloc] init];
        [self.myRevealController pushFrontViewController:desiredView animated:YES];
        
    }
    
    
    
}



@end
