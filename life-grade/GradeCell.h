//
//  GradeCell.h
//  life-grade
//
//  Created by scott mehus on 5/17/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
