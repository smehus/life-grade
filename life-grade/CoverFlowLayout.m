//
//  CoverFlowLayout.m
//  SWReveal
//
//  Created by scott mehus on 7/21/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "CoverFlowLayout.h"
#import <QuartzCore/QuartzCore.h>


static const CGFloat kMaxDistancePercentage = 0.3f;
static const CGFloat kMaxRotation = (CGFloat)(50.0 * (M_PI / 180.0));
static const CGFloat kMaxZoom = 0.3f;

@implementation CoverFlowLayout

- (id)init {
    
    if ((self = [super init])) {
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 1000.0f;
    }
    return self;
}

/*

 THIS IS MY EDITED VERSION
 
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset,
        .size = self.collectionView.bounds.size};
    
    CGFloat maxDistance = visibleRect.size.width * kMaxDistancePercentage;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        
        CGFloat normalizedDistance = distance / maxDistance;
        normalizedDistance = MIN(normalizedDistance, 1.0f);
        normalizedDistance = MAX(normalizedDistance, -1.0f);
        
        CGFloat rotation = normalizedDistance *kMaxRotation;
        CGFloat zoom = 1.0 + ((1.0f - abs(normalizedDistance)) *kMaxZoom);
        
        CATransform3D transform  = CATransform3DIdentity;
        transform.m34 = 1.0 / -1000.0;
        transform = CATransform3DRotate(transform, rotation, 0.0f, 1.0f, 0.0f);
        transform = CATransform3DScale(transform, zoom, zoom, 0.0f);
        attributes.transform3D = transform;
    }
    return array;
}
 
 */


// THIS IS THE ORIGINAL VERSION

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1
    CGRect visibleRect =
	(CGRect){.origin = self.collectionView.contentOffset,
		.size = self.collectionView.bounds.size};
    CGFloat maxDistance =
	visibleRect.size.width * kMaxDistancePercentage;
    int centerIndex;
    
    // 2
    NSArray *array =
	[super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        // 3
        CGFloat distance =
		CGRectGetMidX(visibleRect) - attributes.center.x;
        
        // 4
        CGFloat normalizedDistance = distance / maxDistance;
        normalizedDistance = MIN(normalizedDistance, 1.0f);
        normalizedDistance = MAX(normalizedDistance, -1.0f);
        
        // 5
        CGFloat rotation = normalizedDistance * kMaxRotation;
        CGFloat zoom = 1.0f +
		((1.0f - ABS(normalizedDistance)) * kMaxZoom);
        
        // 6
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / -1000.0;
        transform = CATransform3DRotate(transform,
                                        rotation,
                                        0.0f,
                                        1.0f,
                                        0.0f);
        transform = CATransform3DScale(transform,
                                       zoom,
                                       zoom,
                                       0.0f);
        

        
                attributes.transform3D = transform;
        
        // rotate the cells!
        /*
        if (attributes.indexPath.row == 0) {
            attributes.transform = CGAffineTransformMakeRotation(M_PI / 2.5f);
        } else if (attributes.indexPath.row == 1) {
            attributes.transform = CGAffineTransformMakeRotation(M_PI / 4.0f);
        }
        */
    
    }
    // 7
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

/*
 
 MY EDITED VERSION

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0f);
    
    //2
    CGRect targetRect = CGRectMake(proposedContentOffset.x + 100, 0.0f,
                                   self.collectionView.bounds.size.width,
                                   self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        
        //3
        CGFloat distanceFromCenter = layoutAttributes.center.x - horizontalCenter;
        
        if (ABS(distanceFromCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = distanceFromCenter;
        }
    }
    
    //4
    //return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    
    return CGPointMake(proposedContentOffset.x - 50, proposedContentOffset.y);
}
*/

- (CGPoint)targetContentOffsetForProposedContentOffset:
(CGPoint)proposedContentOffset
								 withScrollingVelocity:(CGPoint)velocity
{
    // 1
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    CGFloat horizontalCenter = proposedContentOffset.x +
	(CGRectGetWidth(self.collectionView.bounds) / 2.0f);
    
    // 2
    CGRect targetRect =
	CGRectMake(proposedContentOffset.x,
			   0.0f,
			   self.collectionView.bounds.size.width,
			   self.collectionView.bounds.size.height);
    NSArray *array =
	[super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes
         in array)
    {
        // 3
        CGFloat distanceFromCenter =
		layoutAttributes.center.x - horizontalCenter;
        // 4
        if (ABS(distanceFromCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = distanceFromCenter;
        }
    }
	
    // 6
    return CGPointMake(
					   proposedContentOffset.x + offsetAdjustment,
					   proposedContentOffset.y);
}
 
 



@end
