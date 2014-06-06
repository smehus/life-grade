//
//  MyDesiredGradeViewController.h
//  life-grade
//
//  Created by scott mehus on 5/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionPlanViewController : UIViewController


@property (nonatomic, strong) NSNumber * finalGradeValue;
@property (nonatomic, strong) NSArray *finalGrades;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
