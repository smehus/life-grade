//
//  Answers.h
//  life-grade
//
//  Created by scott mehus on 7/19/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answers : NSManagedObject

@property (nonatomic, retain) NSNumber * desiredGrade;
@property (nonatomic, retain) NSNumber * finalGrade;
@property (nonatomic, retain) NSNumber * questionEight;
@property (nonatomic, retain) NSNumber * questionFive;
@property (nonatomic, retain) NSNumber * questionFour;
@property (nonatomic, retain) NSNumber * questionNine;
@property (nonatomic, retain) NSNumber * questionOne;
@property (nonatomic, retain) NSNumber * questionSeven;
@property (nonatomic, retain) NSNumber * questionSix;
@property (nonatomic, retain) NSNumber * questionTen;
@property (nonatomic, retain) NSNumber * questionThree;
@property (nonatomic, retain) NSNumber * questionTwo;
@property (nonatomic, retain) NSString * actionOne;
@property (nonatomic, retain) NSString * actionTwo;
@property (nonatomic, retain) NSString * actionThree;

@end
