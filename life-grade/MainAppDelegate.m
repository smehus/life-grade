//
//  MainAppDelegate.m
//  life-grade
//
//  Created by scott mehus on 3/23/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "MainAppDelegate.h"
#import <Parse/Parse.h>
#import "OpeningViewController.h"
#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import <CoreData/CoreData.h>
#import "HAViewController.h"
#import "HASmallCollectionViewController.h"
#import "HACollectionViewSmallLayout.h"
#import "HATransitionController.h"
#import "HATransitionLayout.h"



@interface MainAppDelegate ()<UINavigationControllerDelegate, HATransitionControllerDelegate>

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) HATransitionController *transitionController;
@end

@implementation MainAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext, managedObjectModel, persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"3KyZ4sPQCxqmw2MxEWcwu4HjJi8JH2fcxeOPvDQC"
                  clientKey:@"QCRzp1GVgG2TrlGNhw0j7FCNUAymOyHBB6IDLFNu"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
//    PFObject *player = [PFObject objectWithClassName:@"Player"];//1
//    [player setObject:@"fagboy" forKey:@"Name"];
//    [player setObject:[NSNumber numberWithInt:1230] forKey:@"Score"];//2
//    [player save];//3
//    
    
    MenuViewController *rearViewController = [[MenuViewController alloc] init];
    rearViewController.managedObjectContext = self.managedObjectContext;
    

    self.openingViewController = [[OpeningViewController alloc] initWithNibName:@"OpeningViewController" bundle:nil];
    NSLog(@"%@", self.managedObjectContext.persistentStoreCoordinator.managedObjectModel.entities);
    self.openingViewController.managedObjectContext = self.managedObjectContext;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:self.openingViewController];
//
//    HASmallCollectionViewController *opening = [[HASmallCollectionViewController alloc] initWithCollectionViewLayout:[[HACollectionViewSmallLayout alloc] init]];
//    opening.view.frame = [[UIScreen mainScreen] bounds];
//    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearViewController frontViewController:navCon];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];

    
    
    
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:opening];
//    self.navigationController.delegate = self;
//    self.navigationController.navigationBarHidden = YES;
//    
//    self.transitionController = [[HATransitionController alloc] initWithCollectionView:opening.collectionView];
//    self.transitionController.delegate = self;
//    
//    
    mainRevealController.rearViewRevealWidth = 200;
    mainRevealController.rearViewRevealOverdraw = 320;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    mainRevealController.delegate = self;
    
    self.window.rootViewController = mainRevealController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)interactionBeganAtPoint:(CGPoint)point
{
    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op
    HASmallCollectionViewController *presentingVC = (HASmallCollectionViewController *)[self.navigationController topViewController];
    HASmallCollectionViewController *presentedVC = (HASmallCollectionViewController *)[presentingVC nextViewControllerAtPoint:point];
    if (presentedVC!=nil)
    {
        [self.navigationController pushViewController:presentedVC animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController==self.transitionController) {
        return self.transitionController;
    }
    return nil;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]])
    {
        return nil;
    }
    if (!self.transitionController.hasActiveInteraction)
    {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel == nil) {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return managedObjectModel;
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)dataStorePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"DataStore.sqlite"];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator == nil) {
        NSURL *storeURL = [NSURL fileURLWithPath:[self dataStorePath]];
        
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error;
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Error adding persistent store %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            managedObjectContext = [[NSManagedObjectContext alloc] init];
            [managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return managedObjectContext;
}






@end