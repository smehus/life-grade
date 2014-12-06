//
//  ECEventStore.m
//  EZCalendar
//
//  Created by scott mehus on 12/3/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECEventStore.h"


@implementation ECEventStore



+ (id)sharedInstance {
    
    static dispatch_once_t p = 0;
    
    __strong static id _instance = nil;
    
    dispatch_once(&p, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (EKEventStore *)getThisEventStore {
    
    if (!self.eventStore) {
        self.eventStore = [[EKEventStore alloc] init];
        return self.eventStore;
    }
    return self.eventStore;
}

- (void)accessEventStore:(EKEventStore *)eventStore WithCompletion:(EventStoreAccessedCompletionHandler)completion {
    
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if (granted) {
            NSLog(@"ACCESS GRANTED");
    
            
            EKCalendar *calendar = [eventStore defaultCalendarForNewEvents];
            NSTimeInterval secondsPerDay = 24 * 60 * 60;
            
            

            NSDate *startDate = [NSDate date];
            NSDate *eightWeeks = [startDate dateByAddingTimeInterval:secondsPerDay*120];
            NSArray *calendars = @[calendar];
            
            NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:eightWeeks calendars:calendars];
            
            //ARRAY OF EVENTS
            NSArray *events = [eventStore eventsMatchingPredicate:predicate];
            NSMutableArray *muteArray = [NSMutableArray arrayWithArray:events];
            completion(muteArray);
            
        } else {
            
            NSLog(@"ACCESS DENIED");
            [self accessDenied];

        }
    }];

}

- (void)accessDenied {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"You will need to allow access to your calendars" delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

@end
