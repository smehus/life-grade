//
//  InstructionsViewController.m
//  life-grade
//
//  Created by scott mehus on 9/10/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "InstructionsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PickDesiredGradeController.h"
#import "AttributesViewController.h"
#import "ActionPlanViewController.h"

@interface InstructionsViewController ()

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation InstructionsViewController {
    Class localClass;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithViewController:(Class)theClass andCompletionBlock:(CompletionBlock)doneBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = doneBlock;
        localClass = theClass;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Life+Grade";
    UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    NSString *blah = LIGHT_FONT;
    titelLabel.font = [UIFont fontWithName:blah size:30];

    
    if (localClass == [PickDesiredGradeController class]) {
       
        titelLabel.text = @"Desired Grade";
        
    } else if (localClass == [AttributesViewController class]) {
        titelLabel.text = @"Attributes";
        
    } else if (localClass == [ActionPlanViewController class]) {
        titelLabel.text = @"Action Plan";
        
    }
    
    [self.view addSubview:titelLabel];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton setFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 44)];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
