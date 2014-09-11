//
//  InstructionsViewController.m
//  life-grade
//
//  Created by scott mehus on 9/10/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "InstructionsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface InstructionsViewController ()

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation InstructionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithViewController:(UIViewController *)controller andCompletionBlock:(CompletionBlock)doneBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = doneBlock;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton setFrame:CGRectMake(0, self.view.frame.size.height - 66, self.view.frame.size.width, 44)];
    UIColor *color = GREEN_COLOR;
    [self.nextButton setBackgroundColor:color];
    [self.nextButton setTitle:@"Get Started" forState:UIControlStateNormal];
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        self.completionBlock();
    }];
    
    [self.view addSubview:self.nextButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
