//
//  SignInView.m
//  life-grade
//
//  Created by scott mehus on 7/1/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "SignInView.h"

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
    
    self.theView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/8, self.frame.size.width, self.frame.size.height*.5)];
    self.theView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.theView];
    
    [self setupTextFields];
}

- (void)setupTextFields {
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 30)];
    userLabel.text = @"Email";
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(userLabel.frame) + 5, self.frame.size.width - 10, 40)];
    self.emailTextField.layer.borderWidth = 1.0f;
    self.emailTextField.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *pwLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emailTextField.frame) + 5, self.frame.size.width, 30)];
    pwLabel.text = @"Password";

    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(pwLabel.frame) + 5, self.frame.size.width - 10, 40)];
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.signIn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordTextField.frame) + 30, self.frame.size.width, 50)];
    [self.signIn setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    [self.signIn addTarget:self action:@selector(signMeIn) forControlEvents:UIControlEventTouchUpInside];
    [self.signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    

    
    [self.theView addSubview:self.signIn];
    [self.theView addSubview:userLabel];
    [self.theView addSubview:pwLabel];
    [self.theView addSubview:self.emailTextField];
    [self.theView addSubview:self.passwordTextField];
    
}

- (void)signMeIn {
    
    self.thisBlock(self.emailTextField.text, self.passwordTextField.text);
    [self removeFromSuperview];
    
}



@end
