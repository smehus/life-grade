//
//  Attributes.h
//  life-grade
//
//  Created by scott mehus on 9/4/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answers;

@interface Attributes : NSManagedObject

@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) Answers *answers;

@end
