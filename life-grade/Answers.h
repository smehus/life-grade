//
//  Answers.h
//  life-grade
//
//  Created by scott mehus on 9/4/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attributes;

@interface Answers : NSManagedObject

@property (nonatomic, retain) NSString * actionOne;
@property (nonatomic, retain) NSString * actionThree;
@property (nonatomic, retain) NSString * actionTwo;
@property (nonatomic, retain) NSString * firstSupport;
@property (nonatomic, retain) NSString * secondSupport;
@property (nonatomic, retain) NSString * thirdSupport;
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
@property (nonatomic, retain) NSSet *attributes;
@property (nonatomic, retain) NSString * focusFactor;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * completionDate;
@property (nonatomic) BOOL stageQuestionOne;
@property (nonatomic) BOOL stageQuestionTwo;
@property (nonatomic) BOOL stageQuestionThree;
@property (nonatomic) BOOL stageQuestionFour;
@property (nonatomic, retain) NSString * specificFocus;
@property (nonatomic, retain) NSString *trackingProgressOne;
@property (nonatomic, retain) NSString *trackingProgressTwo;
@property (nonatomic, retain) NSString *trackingProgressThree;
@property (nonatomic, retain) NSDate * endDate;


@end

@interface Answers (CoreDataGeneratedAccessors)

- (void)addAttributesObject:(Attributes *)value;
- (void)removeAttributesObject:(Attributes *)value;
- (void)addAttributes:(NSSet *)values;
- (void)removeAttributes:(NSSet *)values;

@end
