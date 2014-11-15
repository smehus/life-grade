//
//  ProgressMethods.h
//  life-grade
//
//  Created by scott mehus on 11/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressMethods : NSObject


@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, assign) BOOL isSelected;


- (id)initWithMethod:(NSString *)method andKey:(NSString *)key;

@end
