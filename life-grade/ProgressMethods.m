//
//  ProgressMethods.m
//  life-grade
//
//  Created by scott mehus on 11/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "ProgressMethods.h"

@implementation ProgressMethods

- (id)initWithMethod:(NSString *)method andKey:(NSString *)key {
    if (self = [super init]) {
        
        self.method = method;
        self.group = key;
        
        
    }
    return self;
}

@end
