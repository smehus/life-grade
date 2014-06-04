//
//  CollectionCell.h
//  SWReveal
//
//  Created by scott mehus on 7/19/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *text;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *checkmark;
@end
