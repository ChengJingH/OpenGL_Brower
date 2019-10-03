//
//  JH_OpenGLAttribute.h
//  OpenGL_Brower
//
//  Created by walen on 2019/9/25.
//  Copyright © 2019 CJH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JH_OpenGLAttribute : NSObject


- (void)genVertexBufferWithAttribStride:(GLsizeiptr)size
                                  bytes:(const GLvoid *)bytes
                                  usage:(GLenum)usage;

- (void)enableVertexBufferWithAttribArray:(GLuint)indx
                                     size:(GLint)size
                                   stride:(GLsizei)stride
                             vertexOffset:(const GLvoid *)offset;

/**
 帧绘制
 */
- (void)prepareToDrawStartVertexIndex:(GLint)first numberVertex:(GLsizei)number;

@end

NS_ASSUME_NONNULL_END
