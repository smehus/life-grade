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
#import "AttributesViewController.h"
#import "MainAppDelegate.h"
#import "Answers.h"

@interface ActionPlanViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@property (nonatomic, strong) UITextField *firstDesire;
@property (nonatomic, strong) UITextField *secondDesire;
@property (nonatomic, strong) UITextField *thirdDesire;
@property (nonatomic, strong) Answers *fetchedAnswers;


@end

@implementation ActionPlanViewController {
    
    MainAppDelegate *del;
    
}

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
    
    [self performFetch];
    
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

- (void)performFetch {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Answers"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answers" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"***CORE_DATA_ERROR*** %@", error);
        
        
        return;
    }
    
    self.fetchedAnswers = [foundObjects lastObject];
    NSLog(@"question bitch %@", self.fetchedAnswers.questionEight);
    
}

- (void)setupTextFields {
    
    
    self.firstDesire = [[UITextField alloc] initWithFrame:CGRectMake(10, 50 + 64, self.view.frame.size.width - 20, 75)];
    self.firstDesire.placeholder = @"First Desire";
    self.firstDesire.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.firstDesire.layer.borderWidth = 1.0f;
    self.firstDesire.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.firstDesire];
    
    self.secondDesire = [[UITextField alloc] initWithFrame:CGRectMake(10, self.firstDesire.frame.origin.y + self.firstDesire.frame.size.height + 20, self.view.frame.size.width - 20, 75)];
    self.secondDesire.placeholder = @"Second Desire";
    self.secondDesire.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.secondDesire.layer.borderWidth = 1.0f;
    self.secondDesire.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.secondDesire];
    
    self.thirdDesire = [[UITextField alloc] initWithFrame:CGRectMake(10, self.secondDesire.frame.origin.y + self.secondDesire.frame.size.height + 20, self.view.frame.size.width - 20, 75)];
    self.thirdDesire.placeholder = @"Third Desire";
    self.thirdDesire.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.thirdDesire.layer.borderWidth = 1.0f;
    self.thirdDesire.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.thirdDesire];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.thirdDesire.frame.size.height + self.thirdDesire.frame.origin.y + 20, self.view.frame.size.width, 50)];
    [nextButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"Finish" forState:UIControlStateNormal];
    
    [self.view addSubview:nextButton];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)nextButtonPressed {
    
//    FinalGradeViewController *finalGradeController = [[FinalGradeViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:finalGradeController];
    
    
    self.fetchedAnswers.actionOne = self.firstDesire.text;
    self.fetchedAnswers.actionTwo = self.secondDesire.text;
    self.fetchedAnswers.actionThree = self.thirdDesire.text;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    
    AttributesViewController *attributes = [[AttributesViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:attributes];
    [self.revealViewController setFrontViewController:nav];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}



@end
