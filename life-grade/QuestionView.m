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
@property (nonatomic, strong) UIButton *nextButton;

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
    self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0f];
    
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
    
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 375, self.frame.size.width, 50)];
    [self.nextButton setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setTitle:@"Next Question" forState:UIControlStateNormal];
    [self addSubview:self.nextButton];
    
    
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

- (void)nextPressed {
    
    NSLog(@"NEXT PRESSED");
    [self.delegate didPickAnswer:self.theIndexPath];
}

@end
