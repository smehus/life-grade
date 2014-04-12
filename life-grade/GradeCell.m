//
//  GradeCell.m
//  life-grade
//
//  Created by scott mehus on 4/12/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "GradeCell.h"

@interface GradeCell ()

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@end

@implementation GradeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    
    
    self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressDetected:)];
    self.pressRecognizer.numberOfTapsRequired = 0;
    self.pressRecognizer.minimumPressDuration = 0.1;
    [self addGestureRecognizer:self.pressRecognizer];
}

- (void)pressDetected:(id)sender {
    
    
    if (self.pressRecognizer.state == UIGestureRecognizerStateBegan) {
     
        
    }
    
    
    if (self.pressRecognizer.state == UIGestureRecognizerStateChanged) {
        
        
        
    }
    
    
    //9
    if (self.pressRecognizer.state == UIGestureRecognizerStateEnded) {
        
        
       
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
