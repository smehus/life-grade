//
//  MyActionViewController.h
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActionViewController : UIViewController

@property (nonatomic, strong) NSNumber * finalGradeValue;
@property (nonatomic, strong) NSArray *finalGrades;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
