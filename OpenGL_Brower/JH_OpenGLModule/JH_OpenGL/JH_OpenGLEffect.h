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
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


NS_ASSUME_NONNULL_BEGIN

@interface JH_OpenGLEffect : NSObject

@property (nonatomic, strong)EAGLContext *gl_context;
@property (nonatomic, assign, readonly)GLuint program;

- (void)setCurrentContext;
//- (void)genFrameBuffer;
//- (void)genRenderBuffer:(id)gl_layer;
//
//- (void)genVertexBuffer:(GLfloat *)vertexDatas
//                  usage:(GLenum)usage;
//
//- (void)enableVertexAttribArray:(GLint)indx
//                     vertexSize:(GLint)v_size
//                   vertexStride:(GLsizei)v_stride
//                   vertexOffset:(const GLvoid *)ptr;
//
//


/**
 @param vertexFile 顶点着色器文件
 @param fragmentFile 片段着色器文件
 */
- (void)loadShader:(NSString *)vertexFile fragment:(NSString *)fragmentFile;
- (void)loadTextureBuffer;

@end

NS_ASSUME_NONNULL_END
