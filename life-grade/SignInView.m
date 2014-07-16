//
//  SignInView.m
//  life-grade
//
//  Created by scott mehus on 7/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SignInView.h"
#import <POP/POP.h>

@implementation SignInView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withBlock:(FinishedBlock)FinishedBlock {
    
    self = [super initWithFrame:frame];
    if (self) {

        self.thisBlock = FinishedBlock;
        [self setupView];
        
        
    }
    return self;
}

- (void)setupView {
    
    self.bgView = [[UIView alloc] initWithFrame:self.frame];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.8f;
    [self addSubview:self.bgView];
    
    self.theView = [[UIView alloc] initWithFrame:CGRectMake(0, -475, self.frame.size.width, self.frame.size.height*.6)];
    self.theView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.theView];
    
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.velocity = @(1000.);
    [self.theView.layer pop_addAnimation:anim forKey:@"slide"];
    
    [self setupTextFields];
}

- (void)setupTextFields {
    
    UILabel *greeting = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 30)];
    greeting.text = @"Sign In";
    greeting.textAlignment = NSTextAlignmentCenter;
    greeting.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];

    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(greeting.frame), self.frame.size.width, 30)];
    userLabel.text = @"Email";
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(userLabel.frame) + 5, self.frame.size.width - 10, 40)];
    self.emailTextField.layer.borderWidth = 1.0f;
    self.emailTextField.placeholder = @"E-mail address";
    UIColor *greyC = GREY_COLOR;
    self.emailTextField.layer.borderColor = greyC.CGColor;
    
    UILabel *pwLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emailTextField.frame) + 5, self.frame.size.width, 30)];
    pwLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
    pwLabel.textAlignment = NSTextAlignmentCenter;
    pwLabel.text = @"Password";

    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.emailTextField.frame) + 5, self.frame.size.width - 10, 40)];
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.placeholder = @"LifeGrade Password";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.layer.borderColor = greyC.CGColor;
    
    self.signIn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordTextField.frame) + 15, self.frame.size.width, 50)];
    [self.signIn setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.signIn addTarget:self action:@selector(signMeIn) forControlEvents:UIControlEventTouchUpInside];
    [self.signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exit.clipsToBounds = NO;
    [exit setFrame:CGRectMake(0, CGRectGetMaxY(self.signIn.frame) + 15, self.theView.frame.size.width, 20)];
    [exit setTitle:@"exit" forState:UIControlStateNormal];
    [exit.titleLabel setTextAlignment:NSTextAlignmentCenter];
    exit.titleLabel.textColor = GREY_COLOR;
    [exit.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20]];
    exit.userInteractionEnabled = YES;
    [exit addTarget:self action:@selector(exitScreen) forControlEvents:UIControlEventTouchUpInside];
    

    [self.theView addSubview:greeting];
    [self.theView addSubview:self.signIn];
    [self.theView addSubview:exit];
//    [self.theView addSubview:userLabel];
//    [self.theView addSubview:pwLabel];
    [self.theView addSubview:self.emailTextField];
    [self.theView addSubview:self.passwordTextField];
    
}

- (void)exitScreen {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0.0f;

    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];

    
    
  
    

}

- (void)signMeIn {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        self.thisBlock(self.emailTextField.text, self.passwordTextField.text);
        
    }];


    
}



@end
