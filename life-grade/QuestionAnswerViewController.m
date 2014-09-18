//
//  QuestionAnswerViewController.m
//  life-grade
//
//  Created by Paddy on 9/18/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "QuestionAnswerViewController.h"

@interface QuestionAnswerViewController ()

@end

@implementation QuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    
    [self setupScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupScreen {
    
    NSString *liteFont = LIGHT_FONT;
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
    firstLabel.text = [NSString stringWithFormat:@"I: %@", @"This is the first"];
    firstLabel.font = [UIFont fontWithName:liteFont size:30];
    [self.view addSubview:firstLabel];
    
    
    
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLabel.frame) + 150, self.view.frame.size.width, 30)];
    secondLabel.text = [NSString stringWithFormat:@"II: %@", @"This is the second"];
    secondLabel.font = [UIFont fontWithName:liteFont size:30];
    [self.view addSubview:secondLabel];
    
    
    
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondLabel.frame) + 150, self.view.frame.size.width, 30)];
    thirdLabel.text = [NSString stringWithFormat:@"III: %@", @"This is the third"];
    thirdLabel.font = [UIFont fontWithName:liteFont size:30];
    [self.view addSubview:thirdLabel];
}



@end
