//
//  SimpleCoverFlowLayout.m
//  life-grade
//
//  Created by scott mehus on 3/27/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SimpleCoverFlowLayout.h"
#import <QuartzCore/QuartzCore.h>

#define ITEM_SIZE 70

static const CGFloat kMaxDistancePercentage = 0.3f;
static const CGFloat kMaxRotation = (CGFloat)(50.0 * (M_PI / 360));
static const CGFloat kMaxZoom = 0.3f;

@implementation SimpleCoverFlowLayout

- (id)init {
    if ((self = [super init])) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 10.0f;
    }
    return self;
}

- (void)prepareLayout {
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.5;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(_center.x + _radius * sinf(2 * path.item * M_PI / _cellCount),
                                    _center.y + _radius * cosf(2 * path.item * M_PI / _cellCount));
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1
    CGRect visibleRect =
	(CGRect){.origin = self.collectionView.contentOffset,
		.size = self.collectionView.bounds.size};
    
    
    CGFloat maxDistance = visibleRect.size.height;
    //visibleRect.size.width * kMaxDistancePercentage;
    int centerIndex;
    
    
    // 2
    NSMutableArray *array =
	[super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        // 3
        CGFloat distance =
		CGRectGetMidY(visibleRect) - attributes.center.y;
        
        // 4
        CGFloat normalizedDistance = distance / maxDistance;
        normalizedDistance = MIN(normalizedDistance, 1.0f);
        normalizedDistance = MAX(normalizedDistance, -1.0f);
        
        // 5
        CGFloat rotation = normalizedDistance * kMaxRotation;
        //CGFloat rotation = normalizedDistance;
        CGFloat zoom = 1.0f +
		((1.0f - ABS(normalizedDistance)) * kMaxZoom);
        
        // 6
        // center varies because its  scroll view
        CGPoint cnt = CGPointMake(
                                  self.collectionView.center.x + self.collectionView.contentOffset.x,
                                  self.collectionView.center.y + self.collectionView.contentOffset.y);
        
        CATransform3D transform = CATransform3DIdentity;
        
        if (attributes.center.y > cnt.y) {
            
            //transform.m24 = 1.0 / -1000.0;
            //transform.m34 = 1.0 / -1000.0;
            transform = CATransform3DRotate(transform,
                                            rotation,
                                            0.0f,
                                            0.0f,
                                            rotation);
        } else {
            
            // transform.m24 = 1.0 / -1000.0;
            //transform.m34 = 1.0 / -1000.0;
            transform = CATransform3DRotate(transform,
                                            -rotation,
                                            0.0f,
                                            0.0f,
                                            rotation);
            
        }
        
        
        /* transform = CATransform3DScale(transform,
         zoom,
         zoom,
         0.0f);
         */
        
        
        attributes.transform3D = transform;
        
        // THIS IS A COOL EFFECT
        //attributes.center = CGPointMake(attributes.center.x, attributes.center.y - distance);
        
        
        
        //THIS WORKS
        if (distance < 0) {
            attributes.center = CGPointMake(attributes.center.x + distance/16, attributes.center.y);
        } else if (distance > 0) {
            attributes.center = CGPointMake(attributes.center.x - distance/16, attributes.center.y);
        }
        
        
        
        
        // rotate the cells!
        /*
         if (attributes.indexPath.row == 0) {
         attributes.transform = CGAffineTransformMakeRotation(M_PI / 2.5f);
         } else if (attributes.indexPath.row == 1) {
         attributes.transform = CGAffineTransformMakeRotation(M_PI / 4.0f);
         }
         
         
         
         for (int i=0; i < self.cellCount; i++) {
         NSIndexPath *path = attributes.indexPath;
         attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
         attributes.center = CGPointMake(_center.x + _radius * cosf(2 * path.item * M_PI / _cellCount),
         _center.y + _radius * sinf(2 * path.item * M_PI / _cellCount));
         }
         */
        
    }
    
    
    // 7
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(_center.x, _center.y);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(_center.x, _center.y);
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}


@end
