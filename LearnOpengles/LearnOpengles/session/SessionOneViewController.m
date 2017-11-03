//
//  SessionOneViewController.m
//  LearnOpengles
//
//  Created by gaojian on 2017/10/29.
//  Copyright © 2017年 gaojian. All rights reserved.
//

#import "SessionOneViewController.h"
#import <OpenGLES/ES3/gl.h>
#import "CompileUtility.h"

@interface SessionOneViewController () {
    
    GLuint _program;
    BOOL _isNormal;
    BOOL _needChange;
    GLuint _bufferHandles[5];
    GLuint _vertexArray[2];
}

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
    
    [EAGLContext setCurrentContext:self.context];
    
    GLint result = [CompileUtility createProgram:@"vertexShader.vsh" fragment:@"fragmentShader.fsh"];
    if (result < 0) {
        return;
    }
    _program = result;
    
    [self dataSetup];
}

- (void)dataSetup {
    
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    
    _isNormal = YES;
    
    GLfloat vertex[3 * (3 + 4)] = {
        0.0,  0.5,  0.0,
        0.0, 0.0, 1.0, 1.0,
        -0.5, -0.5, 0.0,
        0.0, 0.0, 1.0, 1.0,
        0.5,  -0.5, 0.0,
        0.0, 0.0, 1.0, 1.0,
    };
    
    GLfloat vertex1[3 * (3 + 4)] = {
        0.0,  -0.5,  0.0,
        1.0, 0.0, 0.0, 1.0,
        -0.5, 0.5, 0.0,
        1.0, 0.0, 0.0, 1.0,
        0.5,  0.5, 0.0,
        1.0, 0.0, 0.0, 1.0,
    };
    
    glUseProgram(_program);
    
    glGenBuffers(3, _bufferHandles);
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[0]);
    glBufferData(GL_ARRAY_BUFFER, 3*(3 + 4)*sizeof(GLfloat), vertex, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[1]);
    glBufferData(GL_ARRAY_BUFFER, 3*(3 + 4)*sizeof(GLfloat), vertex1, GL_STATIC_DRAW);
    
    GLushort indexs[] = {0, 1, 2};
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferHandles[2]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 3*sizeof(GLushort), indexs, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glGenVertexArrays(2, _vertexArray);
    
    glBindVertexArray(_vertexArray[0]);
    
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[0]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferHandles[2]);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 + 4)*sizeof(GLfloat), 0);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, (3 + 4)*sizeof(GLfloat), (const void *)(3*sizeof(GLfloat)));
    
    glBindVertexArray(_vertexArray[1]);
    
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[1]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferHandles[2]);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 + 4)*sizeof(GLfloat), 0);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, (3 + 4)*sizeof(GLfloat), (const void *)(3*sizeof(GLfloat)));
    
    glBindVertexArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_program);
    
    glBindVertexArray(_isNormal ? _vertexArray[0] : _vertexArray[1]);
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, 0);
    glBindVertexArray(0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _isNormal = !_isNormal;
    _needChange = YES;
}

@end

