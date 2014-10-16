//
//  FactorDescriptionViewController.m
//  life-grade
//
//  Created by scott mehus on 10/15/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "FactorDescriptionViewController.h"

@interface FactorDescriptionViewController ()
@property (nonatomic, strong) NSString *factorDescription;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation FactorDescriptionViewController

- (id)initWithDescription:(NSString *)description {
    if (self = [super init]) {
        self.factorDescription = description;
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height - 10)];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.text = self.factorDescription;
        [self.view addSubview:self.descriptionLabel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
