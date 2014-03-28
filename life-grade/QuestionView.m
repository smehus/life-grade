//
//  QuestionView.m
//  life-grade
//
//  Created by scott mehus on 3/25/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "QuestionView.h"
#import "CollectionCell.h"
#import "SimpleCoverFlowLayout.h"

@interface QuestionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SimpleCoverFlowLayout *simpleLayout;

@end

@implementation QuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setUpView {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    label.text = @"works";
    [self addSubview:label];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    UICollectionViewFlowLayout *coverFlow = [[UICollectionViewFlowLayout alloc] init];
    
    self.simpleLayout = [[SimpleCoverFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, 100) collectionViewLayout:self.simpleLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [self addSubview:self.collectionView];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
   CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.text.text = @"A++";
    return cell;
    
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(50.0f, 20.0f, 50.0f, 20.0f);
}



@end
