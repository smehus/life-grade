//
//  OpeningViewController.m
//  life-grade
//
//  Created by scott mehus on 3/23/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "OpeningViewController.h"
#import "SWRevealViewController.h"


@interface OpeningViewController ()
@property (nonatomic, strong) SWRevealViewController *myRevealController;
@property (strong, nonatomic) IBOutlet UILabel *LifeLabel;
@property (strong, nonatomic) IBOutlet UILabel *GradeLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation OpeningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
      self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *3, self.view.frame.size.height);

    self.myRevealController = [self revealViewController];
    [self.view addGestureRecognizer:self.myRevealController.panGestureRecognizer];
    
    self.scrollView.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    
    self.LifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 50)];
    self.LifeLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
    self.LifeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat fontSize = self.LifeLabel.font.pointSize;
    self.LifeLabel.frame = CGRectMake(50, 50, 150, fontSize);
    self.LifeLabel.text = @"Life";
    
    self.GradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.LifeLabel.frame.size.width + 50,
                                                                self.LifeLabel.frame.size.height + 60, 150, 50)];
    self.GradeLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f];
    self.GradeLabel.text = @"Grade";
    self.GradeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:90];
    CGFloat gradeSize = self.GradeLabel.font.pointSize;
    self.GradeLabel.frame = CGRectMake(self.LifeLabel.frame.origin.x + 25,
                                       self.LifeLabel.frame.size.height + 60, 320, gradeSize);
    
    
    
    
    
  
    
    [self.scrollView addSubview:self.LifeLabel];
    [self.scrollView addSubview:self.GradeLabel];
    
    
    
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
