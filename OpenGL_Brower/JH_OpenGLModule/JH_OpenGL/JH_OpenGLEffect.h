//
//  JH_OpenGLEffect.h
//  OpenGL_Brower
//
//  Created by walen on 2019/8/27.
//  Copyright © 2019 CJH. All rights reserved.
//

#import <Foundation/Foundation.h>
//矩阵函数
#import <GLKit/GLKit.h>

//OpenGL ES函数
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "JH_OpenGLAttribute.h"


NS_ASSUME_NONNULL_BEGIN

@interface JH_OpenGLEffect : NSObject

@property (nonatomic, assign)GLuint program;
@property (nonatomic, assign)GLKMatrix4 projectMatrix4;
@property (nonatomic, assign)GLKMatrix4 modelViewMatrix4;

@property (nonatomic,strong)JH_OpenGLAttribute *objAttribute;
@property (nonatomic,strong)JH_OpenGLAttribute *lightAttribute;


//- (void)genFrameBuffer;
//- (void)genRenderBuffer:(id)gl_layer;




/**
 @param vertexFile 顶点着色器文件
 @param fragmentFile 片段着色器文件
 */
- (void)loadShader:(NSString *)vertexFile fragment:(NSString *)fragmentFile;

/**
 加载纹理
 */
- (void)loadTextureBuffer;

@end

NS_ASSUME_NONNULL_END
