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

- (id)initWithDescription:(NSString *)description andSize:(CGSize)s {
    if (self = [super init]) {
        
        self.factorDescription = description;
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 225, s.height)];
        self.descriptionLabel.font = FONT_AMATIC_BOLD(24);
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
