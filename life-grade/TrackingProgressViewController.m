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

@end

@implementation TrackingProgressViewController {
    MainAppDelegate *del;
    MGBox *container;
    NSString *avFont;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 100)];
    titleLabel.text = self.focusFactor.group;
    titleLabel.font = [UIFont fontWithName:avFont size:24];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];

    [self setupGrid];
    [self addNextButton];
    
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
    [self.progressMethods addObject:m1];
    
    ProgressMethods *m2 = [[ProgressMethods alloc] initWithMethod:@"Make 'Task' and 'To Do' Lists" andKey:@"general"];
    [self.progressMethods addObject:m2];
    
    ProgressMethods *m3 = [[ProgressMethods alloc] initWithMethod:@"Post reminders in Workplace" andKey:@"general"];
    [self.progressMethods addObject:m3];
    
    ProgressMethods *m4 = [[ProgressMethods alloc] initWithMethod:@"Journal or blog about it" andKey:@"general"];
    [self.progressMethods addObject:m4];
    
    ProgressMethods *m5 = [[ProgressMethods alloc] initWithMethod:@"Utilize a Calendar" andKey:@"general"];
    [self.progressMethods addObject:m5];
    
    ProgressMethods *m6 = [[ProgressMethods alloc] initWithMethod:@"Make Mini Goals" andKey:@"general"];
    [self.progressMethods addObject:m6];
    
    ProgressMethods *m7 = [[ProgressMethods alloc] initWithMethod:@"Use An App On Your Phone" andKey:@"general"];
    [self.progressMethods addObject:m7];
    
    ProgressMethods *m8 = [[ProgressMethods alloc] initWithMethod:@"Find a Professional" andKey:@"general"];
    [self.progressMethods addObject:m8];
    
    ProgressMethods *m9 = [[ProgressMethods alloc] initWithMethod:@"One Week Summary Worksheet" andKey:@"general"];
    [self.progressMethods addObject:m9];
    
    ProgressMethods *m10 = [[ProgressMethods alloc] initWithMethod:@"Track My Behaviors" andKey:@"Emotional Well-Being"];
    [self.progressMethods addObject:m10];
    
    ProgressMethods *m11 = [[ProgressMethods alloc] initWithMethod:@"“Try One New Thing Hobby Journal" andKey:@"Hobbies & Interests"];
    [self.progressMethods addObject:m11];
    
    ProgressMethods *m12 = [[ProgressMethods alloc] initWithMethod:@"Food and/or Exercise Diary" andKey:@"Physical Health"];
    [self.progressMethods addObject:m12];
    
    ProgressMethods *m13 = [[ProgressMethods alloc] initWithMethod:@"“My Needs” Worksheet" andKey:@"Genuine, Intimate, and Deep Relationships"];
    [self.progressMethods addObject:m13];
    
    ProgressMethods *m14 = [[ProgressMethods alloc] initWithMethod:@"Who’s Got My Back Worksheet" andKey:@"Social Support & Social Networks"];
    [self.progressMethods addObject:m14];
    
    ProgressMethods *m15 = [[ProgressMethods alloc] initWithMethod:@"Contribution Bucket List Activity" andKey:@"Contribution & Giving Back"];
    [self.progressMethods addObject:m15];
    
    ProgressMethods *m16 = [[ProgressMethods alloc] initWithMethod:@"Thought Countering Worksheet" andKey:@"Positive Thinking"];
    [self.progressMethods addObject:m16];

    
    
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
    
    container = [MGBox boxWithSize:CGSizeMake(self.view.size.width, 200)];
    container.frame = CGRectMake(0, 150, self.view.frame.size.width, 200);
    container.contentLayoutMode = MGLayoutGridStyle;
    
    [self.view addSubview:container];
    
    for (int i = 0; i < 6; i++) {
        MGBox *box = [MGBox boxWithSize:CGSizeMake(96, 96)];
        box.leftMargin = 5.0f;
        box.rightMargin = 5.0f;
        box.topMargin = 5.0f;
        box.bottomMargin = 5.0f;
        box.backgroundColor = [UIColor whiteColor];
        box.layer.borderWidth = 1.0f;
        box.layer.borderColor = greenColor.CGColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, box.frame.size.height/2-50, box.frame.size.width-10, 100)];
        ProgressMethods *m;
        if (i == 0) {
            m = self.focusFactor;
            
            box.backgroundColor = GREEN_COLOR;
        } else {
            m = self.generalFactors[i];
        }
        label.text = m.method;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = FONT_AMATIC_BOLD(24);
        label.textAlignment = NSTextAlignmentCenter;
        [box addSubview:label];
        
        box.onTap = ^{
            NSLog(@"SHITFAG");
            
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
        AttainableViewController *controller = [[AttainableViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.view addSubview:button];
    
}

@end
