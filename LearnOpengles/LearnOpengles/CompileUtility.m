//
//  CompileUtility.m
//  LearnOpengles
//
//  Created by gaojian on 2017/11/3.
//  Copyright © 2017年 gaojian. All rights reserved.
//

#import "CompileUtility.h"

@implementation CompileUtility

+ (GLint)createProgram:(NSString *)vertexName fragment:(NSString *)fragmentName {
    
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

+ (GLint)compileShader:(NSString *)shaderName type:(GLenum)type {
    
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

@end
