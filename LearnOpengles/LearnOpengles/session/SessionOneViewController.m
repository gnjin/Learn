//
//  SessionOneViewController.m
//  LearnOpengles
//
//  Created by gaojian on 2017/10/29.
//  Copyright © 2017年 gaojian. All rights reserved.
//

#import "SessionOneViewController.h"

@interface SessionOneViewController ()

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation SessionOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!self.context) {
        NSLog(@"fail to creat context");
        return;
    }
    
    GLKView *view = (GLKView *)self.view;
    [view setContext:self.context];
    
    self.preferredFramesPerSecond = 60;
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

}

@end
