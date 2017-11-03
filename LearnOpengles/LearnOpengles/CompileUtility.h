//
//  CompileUtility.h
//  LearnOpengles
//
//  Created by gaojian on 2017/11/3.
//  Copyright © 2017年 gaojian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

@interface CompileUtility : NSObject

+ (GLint)createProgram:(NSString *)vertexName fragment:(NSString *)fragmentName;
+ (GLint)compileShader:(NSString *)shaderName type:(GLenum)type;

@end
