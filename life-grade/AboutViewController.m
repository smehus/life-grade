//
//  AboutViewController.m
//  life-grade
//
//  Created by scott mehus on 7/23/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"

@interface AboutViewController ()
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) UIImageView *aboutImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWebView *webView;

@end


#define NAVBAR_HEIGHT 66

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    

    UIColor *barColour = GREEN_COLOR;
    self.navigationController.navigationBar.barTintColor = barColour;
    
    
//    UIImage *bgImage = [UIImage imageNamed:@"Lined-Paper-"];
//    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
//    bg.frame = CGRectMake(-20, -10, self.view.frame.size.width + 50, self.view.frame.size.height);
//    [self.view addSubview:bg];
//    [self.view sendSubviewToBack:bg];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *barbut = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
    [barbut setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barbut;
    
    self.revealButton = barbut;
    self.title = @"YouTime Coaching";

//    [self addImage];
//    [self addScrollView];
    [self createWebView];
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    

}

- (void)createWebView {
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    self.webView.scalesPageToFit = YES;
    
    NSString *url= [NSString stringWithFormat:@"http://www.youtimecoach.com/#!what-is-the-lifegrade/c1xvg"];
    
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    [self.view addSubview:self.webView];
    
}

- (void)addImage{
    
    self.aboutImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 200)];
    UIImage *img = [UIImage imageNamed:@"jonsafag"];
    self.aboutImage.image = img;

    CGSize size = img.size;
    self.aboutImage.frame = CGRectMake(10, 10, size.width*.5, size.height*.5);
    
    
    
    [self.view addSubview:self.aboutImage];
    
}

- (void)addScrollView {
    
    NSString *aboutString = @"Meet Jonathan, your YouTime Coach! Thirty seconds of paralysis is all it took to force Jonathan into the world of Sport and Performance Psychology. Following a neck injury sustained in a senior year Varsity baseball game, Jonathan battled the mental and physical rigors of returning to play competitive baseball again. Overcoming the adversity, Jonathan was invited to pitch at a competitive Division I school, and this is where his passion for working with individuals on their ability to be resilient and thrive began. The YouTime Coach brings years of Life Coaching experience working with adolesence, adults, athletes, business executives, actors, and many other backgrounds throughout the country and internationally. Jonathan is passionate and genuine in his work with other individuals and does everything possible to see they succeed. Jonathan attended the University of Rhode Island to obtain a degree in Kinesiology and Psychology before coming up to Boston to earn his Master's Degree in Counseling and Sport Psychology from Boston University. In addition to his work as a Life Coach, Jonathan serves as a Consultant for a private psychiatric facility in Boston where he runs life coaching groups, is a 1st degree black belt, actively contributes to his blog Guidance for the Field of Life, and is currently developing a life coaching and happiness app. The YouTime Coach currently resides in the historic North End District of Boston and loves going out to new restaurants, trying new things in Boston, traveling with his wife and spending time with his dog Bipsy";
    
    UITextView *bioView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.aboutImage.frame) + 5, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.aboutImage.frame) - NAVBAR_HEIGHT)];
    bioView.text = aboutString;
    bioView.editable = NO;
    
    [self.view addSubview:bioView];
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}




@end
