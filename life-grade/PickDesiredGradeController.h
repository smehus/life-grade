//
//  PickDesiredGradeController.h
//  life-grade
//
//  Created by scott mehus on 5/19/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface PickDesiredGradeController : UIViewController

@property (nonatomic, strong) NSNumber * finalGradeValue;
@property (nonatomic, strong) NSArray *finalGrades;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
