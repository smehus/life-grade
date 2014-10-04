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
#import "ActionPlanViewController.h"
#import "FinalGradeViewController.h"
#import "AboutViewController.h"
#import "AttributesViewController.h"
#import <Parse/Parse.h>
#import "OpeningViewController.h"
#import "MainAppDelegate.h"
#import "Answers.h"
#import <CoreData/CoreData.h>
#import "FinalAnalysisViewController.h"

@interface MenuViewController ()


@property (nonatomic, strong) SWRevealViewController *myRevealController;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSMutableArray *allAnswers;
@end

@implementation MenuViewController {

    MainAppDelegate *del;
    
}



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
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self performFetch];
    self.titleArray = @[@"Grading", @"Desired Grade", @"Steps", @"Attributes", @"My Grade", @"About", @"Log Out"];
    
    NSLog(@"MENU LOADED");
    [super viewDidLoad];
    self.myRevealController = [self revealViewController];
    self.tableView.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    [self performFetch];
    NSLog(@"MENU APPEARED");
    
    
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)performFetch {
    
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
    self.allAnswers = [NSMutableArray arrayWithArray:foundObjects];
    NSLog(@"question bitch %@", self.fetchedAnswers);
    
}

    

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.titleArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 66;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];

    
    if (indexPath.section == 0) {
        PFUser *user = [PFUser currentUser];
        if (user) {
            cell.textLabel.text = user.email;
        } else {
            cell.textLabel.text = @"Not Signed In";
        }

        NSString *sf = LIGHT_FONT;
        cell.textLabel.font = [UIFont fontWithName:sf size:16];
        cell.textLabel.textColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0f];
    } else {
        cell.textLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
        cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSLog(@"clicked email");
    } else {
    
        if (indexPath.row == 0) {
            
            DesiredGradeViewController *desiredView = [[DesiredGradeViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desiredView];
            [self.myRevealController pushFrontViewController:nav animated:YES];
            
        } else if (indexPath.row == 1) {
            
            PickDesiredGradeController *pickDesire = [[PickDesiredGradeController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pickDesire];
            [self.myRevealController pushFrontViewController:nav animated:YES];
            
            
        } else if (indexPath.row == 2) {
            
            ActionPlanViewController *desiredController = [[ActionPlanViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desiredController];
            [self.myRevealController pushFrontViewController:nav animated:YES];
        } else if (indexPath.row == 3) {
            
            AttributesViewController *attsController = [[AttributesViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:attsController];
            [self.myRevealController pushFrontViewController:nav animated:YES];
            
        
        } else if (indexPath.row == 4) {
            
            FinalAnalysisViewController *finalontroller = [[FinalAnalysisViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalontroller];
            [self.myRevealController pushFrontViewController:nav animated:YES];
        
            
        } else if (indexPath.row == 5) {
            
            AboutViewController *aboutController = [[AboutViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:aboutController];
            [self.myRevealController pushFrontViewController:nav animated:YES];
            
        } else if (indexPath.row == 6) {
            
            NSLog(@"***LOG OUT");
            
            PFUser *user = [PFUser currentUser];
            if (user) {
                
                [PFUser logOut];
                
                [self.managedObjectContext deleteObject:self.fetchedAnswers];
                
                NSError *error = nil;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                    return;
                }
                
                NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
                for (NSString *key in [defaultsDictionary allKeys]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                }
                
                
                
                OpeningViewController *opening = [[OpeningViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:opening];
                [self.myRevealController pushFrontViewController:opening animated:YES];
            }
        }
    }
}



@end
