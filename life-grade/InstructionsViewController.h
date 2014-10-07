//
//  InstructionsViewController.h
//  life-grade
//
//  Created by scott mehus on 9/10/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(void);

@interface InstructionsViewController : UIViewController

@property (nonatomic, strong) CompletionBlock completionBlock;
@property (nonatomic, strong) UILabel *instructLabel;

- (id)initWithViewController:(Class)theClass andCompletionBlock:(CompletionBlock)doneBlock;

@end
