//
//  MainAppDelegate.h
//  life-grade
//
//  Created by scott mehus on 3/23/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpeningViewController.h"
#import <CoreData/CoreData.h>
#import "SWRevealViewController.h"

@interface MainAppDelegate : UIResponder <UIApplicationDelegate, SWRevealViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) OpeningViewController *openingViewController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;



@end
