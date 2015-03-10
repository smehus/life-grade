//
//  TrackingProgressViewController.m
//  life-grade
//
//  Created by scott mehus on 9/24/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "TrackingProgressViewController.h"
#import "MainAppDelegate.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QuartzCore/QuartzCore.h"
#import <MGBoxKit/MGBoxKit.h>
#import "AttainableViewController.h"
#import "ProgressMethods.h"
#import "Answers.h"


@interface TrackingProgressViewController ()

@property (nonatomic, strong) NSMutableArray *progressMethods;
@property (nonatomic, strong) Answers *fetchedAnswers;
@property (nonatomic, strong) ProgressMethods *focusFactor;
@property (nonatomic, strong) NSMutableArray *generalFactors;

@property (nonatomic, strong) NSMutableArray *selectedMethods;

@end

@implementation TrackingProgressViewController {
    MainAppDelegate *del;
    MGBox *container;
    NSString *avFont;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedMethods = [[NSMutableArray alloc] initWithCapacity:3];
    self.progressMethods = [[NSMutableArray alloc] initWithCapacity:16];
    self.generalFactors = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self addMethods];
    [self getGenerals];
    [self performFetch];

    avFont = AVENIR_BLACK;

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.managedObjectContext) {
        self.managedObjectContext = del.managedObjectContext;
    }
    
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    [self setTitleView];

    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIColor *grey = GREY_COLOR;
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    [barBtnItem setTintColor:grey];
    self.navigationItem.backBarButtonItem = barBtnItem;
    
    int sub = 0;
    int ret = 0;
    if ([self isIpad]|| IS_IPHONE4) {
        sub = 0;
        ret = 0;
    } else {
        sub = 10;
        ret = 40;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sub, self.view.frame.size.width, 50)];
    titleLabel.text = self.focusFactor.group;
    titleLabel.font = FONT_AMATIC_BOLD(24);
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
    
    
    UILabel *trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, self.view.frame.size.width, 25)];
    trackLabel.text = @"Track Your Progress";
    trackLabel.font = [UIFont fontWithName:avFont size:24];
    trackLabel.numberOfLines = 0;
    trackLabel.textAlignment = NSTextAlignmentCenter;
    trackLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:trackLabel];
    
    UILabel *instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(trackLabel.frame)+ ret, self.view.frame.size.width, 50)];
    instructLabel.text = @"Select Three Techniques";
    instructLabel.backgroundColor = BLUE_COLOR;
    instructLabel.font = [UIFont fontWithName:avFont size:20];
    instructLabel.numberOfLines = 0;
    instructLabel.textAlignment = NSTextAlignmentCenter;
    instructLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:instructLabel];
    

    [self setupGrid];
    [self addNextButton];
    
}

- (BOOL)isIpad {
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"] || [deviceType isEqualToString:@"iPhone Simulator"])
    {
        return NO;
    } else {
        return YES;
    }
}

- (void)performFetch {
    
    del = (MainAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Answers"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answers" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"***CORE_DATA_ERROR*** %@", error);
        
        
        return;
    }
    
    self.fetchedAnswers = [foundObjects lastObject];
    [self getFocus:self.fetchedAnswers.focusFactor];
    
    
    
    NSLog(@"question bitch %@", self.fetchedAnswers);
    
}

- (void)getFocus:(NSString *)focus {
    
    
    [self.progressMethods enumerateObjectsUsingBlock:^(ProgressMethods *obj, NSUInteger idx, BOOL *stop) {
        
        if ([focus isEqualToString:obj.group]) {
            
            self.focusFactor = obj;
        }
    }];
}

- (void)getGenerals {
    
    [self.progressMethods enumerateObjectsUsingBlock:^(ProgressMethods *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.group isEqualToString:@"general"]) {
            

            
            [self.generalFactors addObject:obj];
            
            
        }
    }];
}

- (void)addMethods {
    

    ProgressMethods *m1 = [[ProgressMethods alloc] initWithMethod:@"Track My Patterns" andKey:@"general"];
    m1.methodDescription = @"Grab a pen and paper, use your computer, or just grab your phone and start your detective work! Use this method of tracking progress by recording your troublesome behaviors, your feelings and thoughts associated with them, and the results of all this! Good detective work will illuminate problem areas and potential places to focus on.";
    [self.progressMethods addObject:m1];
    
    ProgressMethods *m2 = [[ProgressMethods alloc] initWithMethod:@"Make 'Task' and 'To Do' Lists" andKey:@"general"];
    m2.methodDescription = @"Keeping lists can save lives! Seriously, just as your doctor, they survive on keeping well organized lists. When making your list make sure to organize, prioritize, and keep the items manageable and specific. This technique will keep you on task and";
    [self.progressMethods addObject:m2];
    
    ProgressMethods *m3 = [[ProgressMethods alloc] initWithMethod:@"Post reminders in Workplace" andKey:@"general"];
    m3.methodDescription = @"Whether you like to admit or not, we all need reminders here and there. Use post-its, color coded paper, or whatever you can get your hands on to remind you that big things need to be happening! A reminder doesn’t mean you have a bad memory or that you are a bad person, it simply means you care about getting your stuff done.";
    [self.progressMethods addObject:m3];
    
    ProgressMethods *m4 = [[ProgressMethods alloc] initWithMethod:@"Journal or blog about it" andKey:@"general"];
    m4.methodDescription = @"Sometimes emotions can get the best of us, so writing or blogging about your change can not only be therapeutic but can actually help you track your own thoughts and behaviors. Open up that notebook or computer of yours and starting getting those thoughts down!";
    [self.progressMethods addObject:m4];
    
    ProgressMethods *m5 = [[ProgressMethods alloc] initWithMethod:@"Utilize a Calendar" andKey:@"general"];
    m5.methodDescription = @"There’s a reason why when you were growing up there was always a calendar in the kitchen. It was your parent’s way to remember weekly plans, food shopping, birthdays, and soccer practice. Now it is your turn to use that fancy cell phone calendar or the old fashion one. Right in important dates, deadlines, events, and reminders each week to keep your change moving forward and from a different perspective. Use this for both long-term and short term goals.";
    [self.progressMethods addObject:m5];
    
    ProgressMethods *m6 = [[ProgressMethods alloc] initWithMethod:@"Make Mini Goals" andKey:@"general"];
    m6.methodDescription = @"Sometimes we bite off more than we can chew, and trust me that isn’t always a good thing. Look at your goal and ask yourself if you can break it down into smaller chunks that are more manageable and less time consuming. This will provide you with the smaller process goals that lead you up that staircase to success!";
    [self.progressMethods addObject:m6];
    
    ProgressMethods *m7 = [[ProgressMethods alloc] initWithMethod:@"Use An App On Your Phone" andKey:@"general"];
    m7.methodDescription = @"Grab that mighty iPhone of yours and get searching! Use your absurdly capable phones to help you with your change. There are great apps out there that help you move towards your goal by sending reminders, helping you organize your “to do” lists, or even sending some motivation over your way. Also, there are many free options out there. Okay, what are you waiting for? Start downloading!";
    [self.progressMethods addObject:m7];
    
    ProgressMethods *m8 = [[ProgressMethods alloc] initWithMethod:@"Find a Professional" andKey:@"general"];
    m8.methodDescription = @"Nothing replaces help directly from another human. There are so many resources out there on your computer, phone, or in the bookstore that may help but are not for everybody. Working with a professional on your goals is a great way to get the support, feedback, and direction you need. You have already made a positive step towards your goal, keep the momentum moving.";
    [self.progressMethods addObject:m8];
    
    ProgressMethods *m9 = [[ProgressMethods alloc] initWithMethod:@"One Week Summary Worksheet" andKey:@"general"];
    m9.methodDescription = @"Life is a roller coaster and sometimes we need to sit down and see what our week actually provided us. It may be tough at first to see the progress you desire, don’t get discouraged this is normal. Make genuine efforts by jotting what you did from each week in this worksheet. Trust me, you may see more progress than you would think. Alway remember, that success whether big or small breeds more confidence and success.";
    [self.progressMethods addObject:m9];
    
    ProgressMethods *m10 = [[ProgressMethods alloc] initWithMethod:@"Track My Behaviors" andKey:@"Emotional Well-Being"];
    m10.methodDescription = @"Now it is time to be a detective. Are you a fan of CSI, Law and Order, or Chicago PD? If so, you have the first step down, but if not no worries! Grab a pen and paper or your computer and track your trouble behaviors relevant to your goal. Jot down what the behavior is (be specific), when did it happen, what were the triggers, and what were the consequences. Play detective and track this for 5 days for a greater understanding of your troubling behaviors.";
    [self.progressMethods addObject:m10];
    
    ProgressMethods *m11 = [[ProgressMethods alloc] initWithMethod:@"Try One New Thing Hobby Journal" andKey:@"Hobbies & Interests"];
    m11.methodDescription = @"Life is driven by emotions and experiences. Whether it is with a group, one other person, or by yourself try to expand those healthy experiences by trying new things. Use this worksheet as a way to keep experiencing new hobbies and interests.";
    [self.progressMethods addObject:m11];
    
    ProgressMethods *m12 = [[ProgressMethods alloc] initWithMethod:@"Food and/or Exercise Diary" andKey:@"Physical Health"];
    m12.methodDescription = @"Are you a midnight cereal eater, a fantasy football couch potato, or both? Fear not, you are making positive steps to change. Use these worksheets to organize your thoughts and actions to keep things manageable for yourself. Awareness is the first step and tracking your food and exercise will help guide you to a healthier you!";
    [self.progressMethods addObject:m12];
    
    ProgressMethods *m13 = [[ProgressMethods alloc] initWithMethod:@"“My Needs” Worksheet" andKey:@"Genuine, Intimate, and Deep Relationships"];
    m13.methodDescription = @"Humans are needy people! Whether we are meeting our own needs or another persons we are constantly trying to fulfill them. Sometimes we do this in healthy ways and sometimes not so healthy. One thing is for sure, it drives many of the decisions we make and for that we should take a closer look. Use this worksheet to examine your own needs and how you meet them around your goal.";
    [self.progressMethods addObject:m13];
    
    ProgressMethods *m14 = [[ProgressMethods alloc] initWithMethod:@"Who’s Got My Back Worksheet" andKey:@"Social Support & Social Networks"];
    m14.methodDescription = @"Social support is undeniably one of the most important factors in accomplishing your goals. You have already identified three people to be on your support team, now let’s figure out how they can support you. Use this worksheet to understand how your support team will help you on your road to change.";
    [self.progressMethods addObject:m14];
    
    ProgressMethods *m15 = [[ProgressMethods alloc] initWithMethod:@"Contribution Bucket List Activity" andKey:@"Contribution & Giving Back"];
    m15.methodDescription = @"Research shows that giving back outside of yourself and contributing is one sure fire way to experience fulfillment in life. A bucket list will gather the things you have always wanted to do, which will help add to your life’s fulfillment. Enjoy using this worksheet and adding serious value to your life";
    [self.progressMethods addObject:m15];
    
    ProgressMethods *m16 = [[ProgressMethods alloc] initWithMethod:@"Thought Countering Worksheet" andKey:@"Positive Thinking"];
    m16.methodDescription = @"Turn that frown upside down, well something like that. Positive thinking has a major impact on your happiness and the outcome of your goal. Let’s be honest, you can’t be positive all the time but you can try a counter some of that negative thinking with this handy worksheet. ";
    [self.progressMethods addObject:m16];

    ProgressMethods *m17 = [[ProgressMethods alloc] initWithMethod:@"Who's got my back worksheet" andKey:@"Job Happiness"];
    m17.methodDescription = @"Social support is undeniably one of the most important factors in accomplishing your goals. You have already identified three people to be on your support team, now let’s figure out how they can support you. Use this worksheet to understand how your support team will help you on your road to change.";
    [self.progressMethods addObject:m17];
    
    ProgressMethods *m18 = [[ProgressMethods alloc] initWithMethod:@"Try one new thing worksheet" andKey:@"Productivity Level"];
    m18.methodDescription = @"Life is driven by emotions and experiences. Whether it is with a group, one other person, or by yourself try to expand those healthy experiences by trying new things. Use this worksheet as a way to keep experiencing new hobbies and interests.";
    [self.progressMethods addObject:m18];
    
    ProgressMethods *m19 = [[ProgressMethods alloc] initWithMethod:@"My needs worksheet" andKey:@"Being Engaged at Work & at Play"];
    m19.methodDescription = @"Humans are needy people! Whether we are meeting our own needs or another persons we are constantly trying to fulfill them. Sometimes we do this in healthy ways and sometimes not so healthy. One thing is for sure, it drives many of the decisions we make and for that we should take a closer look. Use this worksheet to examine your own needs and how you meet them around your goal.";
    [self.progressMethods addObject:m19];
    
}

- (void)setTitleView {
    
    // TITLE VIEW SET
    
    UIColor *barColour = BLUE_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,44*4,44)];
    [iv setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = iv;
    UIImage *titleImage = [UIImage imageNamed:@"header_image.png"];
    
    CGFloat imageHeight = 35.0f;
    CGFloat imageWidth = imageHeight * 4;
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    titleImageView.frame = CGRectMake(iv.frame.size.width/2 - imageWidth/2, 3, imageHeight * 4, imageHeight);
    [iv addSubview:titleImageView];
    self.navigationItem.titleView = iv;
    
    
}

- (void)pop {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupGrid {
    UIColor *greenColor = GREEN_COLOR;
    
    int sub = 0;
    if ([self isIpad] || IS_IPHONE4) {
        sub = 125;
    } else {
        sub = 200;
    }
    
    container = [MGBox boxWithSize:CGSizeMake(self.view.size.width, 200)];
    container.frame = CGRectMake(0, sub, self.view.frame.size.width, 200);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self.view addSubview:container];
    
    for (int i = 0; i < 6; i++) {
        MGBox *box = [MGBox boxWithSize:CGSizeMake(96, 96)];
        box.leftMargin = 5.0f;
        box.rightMargin = 5.0f;
        box.topMargin = 5.0f;
        box.bottomMargin = 5.0f;
        box.backgroundColor = [UIColor whiteColor];
        box.layer.borderWidth = 2.0f;
        box.layer.borderColor = greenColor.CGColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, box.frame.size.height/2-50, box.frame.size.width-10, 100)];
        ProgressMethods *m;
        if (i == 0) {
            m = self.focusFactor;
            if (m.isSelected) {
                box.backgroundColor = GREEN_COLOR;
            }
        } else {
            m = self.generalFactors[i];
            if (m.isSelected) {
                box.backgroundColor = GREEN_COLOR;
            }
        }
        label.text = m.method;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = FONT_AMATIC_BOLD(24);
        label.textAlignment = NSTextAlignmentCenter;
        [box addSubview:label];
        __block MGBox *b = box;
        box.onTap = ^{

            if (m.isSelected == YES) {
                b.backgroundColor = [UIColor whiteColor];
                m.isSelected = NO;
                [self.selectedMethods removeObject:m];
            } else {
                if (self.selectedMethods.count < 3) {
                    b.backgroundColor = GREEN_COLOR;
                    m.isSelected = YES;
                    [self.selectedMethods addObject:m];
                }
            }
            
        };
        [container.boxes addObject:box];
    }
    
    [container layoutWithDuration:0.3 completion:nil];
}

- (void)addNextButton {
    UIColor *green = GREEN_COLOR;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(container.frame) + 20, self.view.frame.size.width-20, 40)];
    [button setBackgroundColor:green];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self saveAnswers];
    }];
    [self.view addSubview:button];
    
}

- (void)saveAnswers {

    NSLog(@"%@", self.selectedMethods);
    
    if (self.selectedMethods.count > 2) {
        for (int i = 0; i < 3; i++) {
            
            ProgressMethods *m = self.selectedMethods[i];
            
            switch (i) {
                case 0:
                    self.fetchedAnswers.trackingProgressOne = m.method;
                    break;
                case 1:
                    self.fetchedAnswers.trackingProgressTwo = m.method;
                    break;
                case 2:
                    self.fetchedAnswers.trackingProgressThree = m.method;
                    break;
                default:
                    break;
            }
        }
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error: %@", error);
            
            
            abort();
        }
        
        AttainableViewController *controller = [[AttainableViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                   message:@"Please select three methods"
                                  delegate:nil
                         cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }

}



@end
