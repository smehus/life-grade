//
//  MyDesiredGradeViewController.m
//  life-grade
//
//  Created by scott mehus on 5/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "ActionPlanViewController.h"
#import "FinalGradeViewController.h"
#import "SWRevealViewController.h"

@interface ActionPlanViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@end

@implementation ActionPlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(0, 0, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    self.title = @"Desired Grade";
    
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    
    
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    
    
    [self setupTextFields];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)setupTextFields {
    
    
    UITextField *firstDesire = [[UITextField alloc] initWithFrame:CGRectMake(10, 50 + 64, self.view.frame.size.width - 20, 75)];
    firstDesire.placeholder = @"First Desire";
    firstDesire.layer.borderColor = [UIColor lightGrayColor].CGColor;
    firstDesire.layer.borderWidth = 1.0f;
    firstDesire.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstDesire];
    
    UITextField *secondDesire = [[UITextField alloc] initWithFrame:CGRectMake(10, firstDesire.frame.origin.y + firstDesire.frame.size.height + 20, self.view.frame.size.width - 20, 75)];
    secondDesire.placeholder = @"Second Desire";
    secondDesire.layer.borderColor = [UIColor lightGrayColor].CGColor;
    secondDesire.layer.borderWidth = 1.0f;
    secondDesire.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondDesire];
    
    UITextField *thirdDesire = [[UITextField alloc] initWithFrame:CGRectMake(10, secondDesire.frame.origin.y + secondDesire.frame.size.height + 20, self.view.frame.size.width - 20, 75)];
    thirdDesire.placeholder = @"Third Desire";
    thirdDesire.layer.borderColor = [UIColor lightGrayColor].CGColor;
    thirdDesire.layer.borderWidth = 1.0f;
    thirdDesire.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thirdDesire];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, thirdDesire.frame.size.height + thirdDesire.frame.origin.y + 20, self.view.frame.size.width, 50)];
    [nextButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"Finish" forState:UIControlStateNormal];
    
    [self.view addSubview:nextButton];
    
}

- (void)nextButtonPressed {
    
    FinalGradeViewController *finalGradeController = [[FinalGradeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalGradeController];
    [self.revealViewController setFrontViewController:nav];
    
}



@end
