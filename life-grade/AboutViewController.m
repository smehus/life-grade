//
//  AboutViewController.m
//  life-grade
//
//  Created by scott mehus on 7/23/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"

@interface AboutViewController ()
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;

@end

@implementation AboutViewController

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
    

    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    
//    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
//    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
//    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
//    [self.view addSubview:bg];
//    [self.view sendSubviewToBack:bg];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    
    
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}




@end
