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
#import "TrackingProgressViewController.h"
#import "MyActionViewController.h"

@interface MenuViewController ()


@property (nonatomic, strong) SWRevealViewController *myRevealController;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) NSMutableArray *allAnswers;
@property (nonatomic, strong) NSMutableArray *unsubscribeArray;
@property (nonatomic, assign) BOOL unsubscribeOpen;
@property (nonatomic, strong) UIImageView *unsubcribeImage;

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
    self.titleArray = @[@"Current Grade", @"Desired Grade", @"Action Plan",@"My Final Analysis", @"About", @"Log Out"];
    
    self.unsubscribeArray = [[NSMutableArray alloc] initWithCapacity:2];
    self.unsubscribeOpen = NO;
    
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
    
    
    [self.tableView reloadData];
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

- (void)userNameTapped {
    NSLog(@"USER NAME TAPPED");
    
    
    
    NSIndexPath *idxs = [NSIndexPath indexPathForRow:0 inSection:0];
    if (!self.unsubscribeOpen) {
        self.unsubscribeOpen = YES;
        [self.unsubscribeArray addObject:@"Unsubscribe"];
        [self.tableView insertRowsAtIndexPaths:@[idxs] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.unsubcribeImage.transform = CGAffineTransformMakeScale(1, -1);
        
    } else {
        self.unsubscribeOpen = NO;
        [self.unsubscribeArray removeLastObject];
        [self.tableView deleteRowsAtIndexPaths:@[idxs] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.unsubcribeImage.transform = CGAffineTransformMakeScale(1, 1);
        
    }
    

    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userNameTapped)];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        [v addGestureRecognizer:tapGest];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width/4, 44)];
        NSString *sf = LIGHT_FONT;
        l.font = [UIFont fontWithName:sf size:16];
        l.textColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0f];
        
        UIImage *image = [UIImage imageNamed:@"red-arrow-1-"];
        self.unsubcribeImage = [[UIImageView alloc] initWithImage:image];
        self.unsubcribeImage.frame = CGRectMake(CGRectGetMaxX(l.frame), 0, 44, 44);
        self.unsubcribeImage.contentMode = UIViewContentModeScaleAspectFill;
        [v addSubview:self.unsubcribeImage];

        PFUser *user = [PFUser currentUser];
        if (user) {
            l.text = user.email;
        } else {
            l.text = @"Not Signed In";

        }
        
        [v addSubview:l];
        return v;
    }
        
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 44;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.unsubscribeArray.count;
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
        
        cell.textLabel.text = @"Unsubscribe";

        NSString *sf = LIGHT_FONT;
        cell.textLabel.font = [UIFont fontWithName:sf size:16];
        cell.textLabel.textColor = [UIColor colorWithRed:13.0/255.0 green:196.0/255.0 blue:224.0/255.0 alpha:1.0f];
        
        
    } else {
        
        switch (indexPath.row) {
            case 1:
                
                
                if (self.fetchedAnswers.finalGrade) {
                    cell.textLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
                } else {
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
                break;
            case 2:
                if (self.fetchedAnswers.desiredGrade) {
                    cell.textLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
                } else {
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
                break;
            case 3:
                if (self.fetchedAnswers.focusFactor) {
                    cell.textLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
                } else {
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
                break;
            case 4:
                if (self.fetchedAnswers.firstSupport) {
                    cell.textLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
                } else {
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
                break;
                
            default:
                cell.textLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
                break;
        }
        
        cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    }
    return cell;
}

//TODO: add code to delete email address from data base

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSLog(@"UNSUBSCRIBE");
        
        
        
        
        // *** LOG OUT PROCESS *** \\
        
        PFUser *user = [PFUser currentUser];

        if (user) {
            
            
            [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                del = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
                del.currentUser = nil;
                [self.managedObjectContext deleteObject:self.fetchedAnswers];
                
                NSError *err = nil;
                if (![self.managedObjectContext save:&err]) {
                    NSLog(@"Can't Delete! %@ %@", err, [err localizedDescription]);
                    return;
                }
                
                NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
                for (NSString *key in [defaultsDictionary allKeys]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                }
                
                
                
                OpeningViewController *opening = [[OpeningViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:opening];
                [self.myRevealController pushFrontViewController:opening animated:YES];
                [PFUser logOut];
                
                [[[UIAlertView alloc] initWithTitle:@"Account Deleted"
                                                            message:@"Your account has been completely removed from our database"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
            
                
            }];

        } else {
            
            
            NSLog(@"No Cached User Exists"); // need to do something - maybe if defaults has an email send that to server to unsubscribe    

            
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
            for (NSString *key in [defaultsDictionary allKeys]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            
            if (self.fetchedAnswers != nil) {
                
                [self.managedObjectContext deleteObject:self.fetchedAnswers];
                NSError *error = nil;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                    return;
                }
            }

            
            OpeningViewController *opening = [[OpeningViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:opening];
            [self.myRevealController pushFrontViewController:opening animated:YES];
            
            // add pop up to explain they've unsubscribed
            
            
            [[[UIAlertView alloc] initWithTitle:@"Account Deleted"
                                                        message:@"Your account has been completely removed from our database"
                                                       delegate:nil
                                               cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
            
        }

        
    } else {
    
        if (indexPath.row == 0) {
            
            DesiredGradeViewController *desiredView = [[DesiredGradeViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desiredView];
            [self.myRevealController pushFrontViewController:nav animated:YES];
            
        } else if (indexPath.row == 1) {
            if  (self.fetchedAnswers.finalGrade) {
                PickDesiredGradeController *pickDesire = [[PickDesiredGradeController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pickDesire];
                [self.myRevealController pushFrontViewController:nav animated:YES];
            }
            
        } else if (indexPath.row == 2) {
            /*
            ActionPlanViewController *desiredController = [[ActionPlanViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desiredController];
            [self.myRevealController pushFrontViewController:nav animated:YES];
             */
            
            
            // factors
            if  (self.fetchedAnswers.desiredGrade ) {
                MyActionViewController *action = [[MyActionViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:action];
                [self.myRevealController pushFrontViewController:nav animated:YES];
            }
        
        } else if (indexPath.row == 3) {
            if  (self.fetchedAnswers.firstSupport) {
                FinalAnalysisViewController *finalontroller = [[FinalAnalysisViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalontroller];
                [self.myRevealController pushFrontViewController:nav animated:YES];
            }
            
        } else if (indexPath.row == 4) {
            
            AboutViewController *aboutController = [[AboutViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:aboutController];
            [self.myRevealController pushFrontViewController:nav animated:YES];
            
        } else if (indexPath.row == 5) {
            
            NSLog(@"***LOG OUT");
            
            PFUser *user = [PFUser currentUser];
            if (user) {
                
                [PFUser logOut];
                del.currentUser = nil;
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
