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
    BOOL _isNormal;
    BOOL _needChange;
    GLuint _bufferHandles[3];
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
    
    _isNormal = YES;
    
    _program = [self createProgram:@"vertexShader.vsh" fragment:@"fragmentShader.fsh"];
    
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    
    glUseProgram(_program);

    _bufferHandles[0] = 0;
    _bufferHandles[1] = 0;
    _bufferHandles[2] = 0;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_program);
    
    if (0 == _bufferHandles[0]) {
        
        GLfloat vertexPos[3 * 3] = {
            0.0,  0.5,  0.0,
            -0.5, -0.5, 0.0,
            0.5,  -0.5, 0.0,
        };
        
        GLfloat color[3 * 4] = {
            0.0, 0.0, 1.0, 1.0,
            0.0, 0.0, 1.0, 1.0,
            0.0, 0.0, 1.0, 1.0
        };

        glGenBuffers(3, _bufferHandles);

        glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[0]);
        glBufferData(GL_ARRAY_BUFFER, 3*3*sizeof(GLfloat), vertexPos, GL_STATIC_DRAW);

        glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[1]);
        glBufferData(GL_ARRAY_BUFFER, 3*4*sizeof(GLfloat), color, GL_STATIC_DRAW);

        GLushort indexs[] = {0, 1, 2};

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferHandles[2]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, 3*sizeof(GLushort), indexs, GL_STATIC_DRAW);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }
    
    if (_needChange) {
        
        _needChange = NO;
        GLfloat vertexPos[3 * 3] = {
            0.0,  0.5,  0.0,
            -0.5, -0.5, 0.0,
            0.5,  -0.5, 0.0,
        };
        
        GLfloat color[3 * 4] = {
            0.0, 0.0, 1.0, 1.0,
            0.0, 0.0, 1.0, 1.0,
            0.0, 0.0, 1.0, 1.0
        };
        GLfloat vertexPos1[3 * 3] = {
            0.0,  -0.5,  0.0,
            -0.5, 0.5, 0.0,
            0.5,  0.5, 0.0,
        };
        
        GLfloat color1[3 * 4] = {
            1.0, 0.0, 0.0, 1.0,
            1.0, 0.0, 0.0, 1.0,
            1.0, 0.0, 0.0, 1.0
        };
        
        glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[0]);
        glBufferData(GL_ARRAY_BUFFER, 3*3*sizeof(GLfloat), _isNormal ? vertexPos : vertexPos1, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[1]);
        glBufferData(GL_ARRAY_BUFFER, 3*4*sizeof(GLfloat), _isNormal ? color : color1, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[0]);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferHandles[1]);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), 0);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferHandles[2]);
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, 0);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
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
    _isNormal = !_isNormal;
    _needChange = YES;
}

@end

