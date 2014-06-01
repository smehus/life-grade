//
//  Answers.h
//  life-grade
//
//  Created by scott mehus on 6/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answers : NSManagedObject

@property (nonatomic, retain) NSDictionary * questionOne;
@property (nonatomic, retain) NSDictionary * questionTwo;
@property (nonatomic, retain) NSDictionary * questionThree;
@property (nonatomic, retain) NSDictionary * questionFour;
@property (nonatomic, retain) NSDictionary * questionFive;
@property (nonatomic, retain) NSDictionary * questionSix;
@property (nonatomic, retain) NSDictionary * questionSeven;
@property (nonatomic, retain) NSDictionary * questionEight;
@property (nonatomic, retain) NSDictionary * questionNine;
@property (nonatomic, retain) NSDictionary * questionTen;

@end
