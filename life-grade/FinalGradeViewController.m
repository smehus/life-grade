//
//  FinalGradeViewController.m
//  life-grade
//
//  Created by scott mehus on 5/30/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "FinalGradeViewController.h"

@interface FinalGradeViewController ()

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
    
    float avg = [self.finalGradeValue floatValue];
    avg = avg/10;
    
    NSLog(@"final grade %f total %@", avg, self.finalGradeValue);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
