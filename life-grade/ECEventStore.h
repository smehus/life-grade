//
//  ECEventStore.h
//  EZCalendar
//
//  Created by scott mehus on 12/3/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

typedef void (^EventStoreAccessedCompletionHandler)(NSMutableArray *events);

@interface ECEventStore : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;


+ (id)sharedInstance;

- (void)accessEventStore:(EKEventStore *)eventStore WithCompletion:(EventStoreAccessedCompletionHandler)completion;
- (EKEventStore *)getThisEventStore;
@end
