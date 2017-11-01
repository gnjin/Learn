//
//  SessionOneViewController.m
//  LearnOpengles
//
//  Created by gaojian on 2017/10/29.
//  Copyright © 2017年 gaojian. All rights reserved.
//

#import "SessionOneViewController.h"

@interface SessionOneViewController () {
    
    GLuint _program;
    GLfloat *_vertexPos;
    GLfloat *_color;
    BOOL _isNormal;
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
    
    GLfloat posTemp[3 * 3] = {
        0.0,  0.5,  0.0,
        -0.5, -0.5, 0.0,
        0.5,  -0.5, 0.0
    };
    _vertexPos = posTemp;
    
    GLfloat colorTemp[4] = {
        0.0, 0.0, 1.0, 1.0
    };
    _color = colorTemp;
    
    _isNormal = YES;
    
    _program = [self createProgram:@"vertexShader.vsh" fragment:@"fragmentShader.fsh"];
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_program);
    glVertexAttrib4fv(0, _color);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, _vertexPos);
    glEnableVertexAttribArray(1);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(1);
}

- (GLint)createProgram:(NSString *)vertexName fragment:(NSString *)fragmentName {
    
    GLint vertexShader = [self compileShader:vertexName type:GL_VERTEX_SHADER];
    GLint fragmentShader = [self compileShader:fragmentName type:GL_FRAGMENT_SHADER];
    if (vertexShader < 0 || fragmentShader < 0) {
        
        NSLog(@"create shader failed");
        return -1;
    }
    
    GLuint programHandle = glCreateProgram();
    if (GL_FALSE == programHandle) {
        
        NSLog(@"create program failed");
        return -1;
    }
    
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkStatus = 0;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkStatus);
    if (GL_FALSE == linkStatus) {
        
        GLint infoLength = 0;
        glGetProgramiv(programHandle, GL_INFO_LOG_LENGTH, &infoLength);
        
        GLsizei buffsize = infoLength;
        GLsizei length = 0;
        GLchar *info = malloc(sizeof(char) * infoLength);;
        glGetProgramInfoLog(programHandle, buffsize, &length, info);
        NSLog(@"link error : %s", info);
        free(info);
    }
    
    return programHandle;
}

- (GLint)compileShader:(NSString *)shaderName type:(GLenum)type {
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:shaderName ofType:nil];
    NSError *error = nil;
    NSString *shaderCode = [NSString stringWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        
        NSLog(@"load shader code failed : %@", error);
        return -1;
    }
    
    GLuint shaderHandle = glCreateShader(type);
    if (GL_FALSE == shaderHandle) {
        
        NSLog(@"create shader failed");
        return  -1;
    }
    
    const GLchar *code = shaderCode.UTF8String;
    GLint codeLenght = (GLint)(shaderCode.length);
    glShaderSource(shaderHandle, 1, &code, &codeLenght);
    
    glCompileShader(shaderHandle);
    
    GLint compileStatus = 0;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileStatus);
    if (GL_FALSE == compileStatus) {
        
        GLint infoLength = 0;
        glGetShaderiv(shaderHandle, GL_INFO_LOG_LENGTH, &infoLength);
        
        GLsizei buffsize = infoLength;
        GLsizei length = 0;
        GLchar *info = malloc(sizeof(char) * infoLength);;
        glGetShaderInfoLog(shaderHandle, buffsize, &length, info);
        NSLog(@"compile error : %s", info);
        free(info);
    }
    
    return shaderHandle;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    GLfloat posTemp[3 * 3] = {
        0.0,  -0.5,  0.0,
        -0.5, 0.5, 0.0,
        0.5,  0.5, 0.0
    };
    _vertexPos = posTemp;
    if (_isNormal) {
        GLfloat posTemp[3 * 3] = {
            0.0,  0.5,  0.0,
            -0.5, -0.5, 0.0,
            0.5,  -0.5, 0.0
        };
        _vertexPos = posTemp;
    }
    
    GLfloat colorTemp[4] = {
        1.0, 0.0, 0.0, 1.0
    };
    _color = colorTemp;
    if (_isNormal) {
        GLfloat colorTemp[4] = {
            0.0, 0.0, 1.0, 1.0
        };
        _color = colorTemp;
    }
}

@end

