//
//  Grade.h
//  life-grade
//
//  Created by scott mehus on 5/17/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grade : NSObject

@property (nonatomic, strong) NSString *grade;
@property (nonatomic, assign) BOOL buttonHidden;
@property (nonatomic, assign) BOOL gradeSelected;

@property (nonatomic, strong) NSString *question;

@end
