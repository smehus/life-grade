//
//  ChecklistViewController.h
//  life-grade
//
//  Created by scott mehus on 9/10/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(void);

@interface ChecklistViewController : UIViewController

@property (nonatomic, strong) CompletionBlock completionBlock;


- (id)initWithChecklist:(int)index andCompletionBlock:(CompletionBlock)doneBlock;

@end
