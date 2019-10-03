//
//  JH_OpenGLAttribute.m
//  OpenGL_Brower
//
//  Created by walen on 2019/9/25.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLAttribute.h"

@interface JH_OpenGLAttribute ()

@property (nonatomic, assign)GLuint name;

@end


@implementation JH_OpenGLAttribute

- (void)genVertexBufferWithAttribStride:(GLsizeiptr)size
                                  bytes:(const GLvoid *)bytes
                                  usage:(GLenum)usage
{
    NSParameterAssert(bytes != NULL);

    glGenBuffers(1, &_name);
    glBindBuffer(GL_ARRAY_BUFFER, _name);
    glBufferData(GL_ARRAY_BUFFER,
                 size,
                 bytes,
                 usage);
}

- (void)enableVertexBufferWithAttribArray:(GLuint)indx
                                     size:(GLint)size
                                   stride:(GLsizei)stride
                             vertexOffset:(const GLvoid *)offset
{
    glBindBuffer(GL_ARRAY_BUFFER, _name);
    glVertexAttribPointer(indx,
                          size,
                          GL_FLOAT,
                          GL_FALSE,
                          stride,
                          offset);
    glEnableVertexAttribArray(indx);
}

- (void)prepareToDrawStartVertexIndex:(GLint)first numberVertex:(GLsizei)number
{
    glDrawArrays(GL_TRIANGLES, first, number);
}



@end
