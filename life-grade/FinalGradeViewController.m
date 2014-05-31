//
//  FinalGradeViewController.m
//  life-grade
//
//  Created by scott mehus on 5/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "FinalGradeViewController.h"
#import "SWRevealViewController.h"


@interface FinalGradeViewController ()
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;

@end

@implementation FinalGradeViewController

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
    
    self.title = @"My Grade";
    
    
    float avg = [self.finalGradeValue floatValue];
    avg = avg/10;
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    
    
    
    NSLog(@"final grade %f total %@", avg, self.finalGradeValue);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
