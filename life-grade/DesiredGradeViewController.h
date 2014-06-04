//
//  DesiredGradeViewController.h
//  SWReveal
//
//  Created by scott mehus on 6/24/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionView;

@interface DesiredGradeViewController : UIViewController 

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
