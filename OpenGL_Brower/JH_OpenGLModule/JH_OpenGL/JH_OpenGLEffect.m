//
//  JH_OpenGLEffect.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/27.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLEffect.h"

@interface JH_OpenGLEffect ()



@end

@implementation JH_OpenGLEffect

@synthesize program = program,vertexShader = vertexShader,fragmentShader = fragmentShader;

//- (void)genFrameBuffer
//{
//    glGenFramebuffers(1, &framebuffers);
//    glBindFramebuffer(GL_FRAMEBUFFER, framebuffers);
//    
//    //帧缓存区 （后帧 --> 前帧渲染）
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffers);
//    //关联深度缓冲到帧缓冲区
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffers);
//    
//    GLenum frameStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
//    if (frameStatus == GL_FALSE) {
//        NSLog(@"frameBuffer error");
//    }
//}
//
//- (void)genRenderBuffer:(id)gl_layer
//{
//    glGenRenderbuffers(1, &renderbuffers);
//    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffers);
//    [self.gl_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)gl_layer];
//    
//    //创建深度缓存区
//    GLint width;
//    GLint height;
//    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
//    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
//    
//    glGenRenderbuffers(1, &depthBuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
//    //和颜色缓冲不同的就是使用glRenderbufferStorage()函数进行分配的时候，需要指定缓冲区的宽高。其中第二个参数表示计算精度，值越高越平滑，当然内存也消耗的更大。
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
//    
//    //     清除深度缓冲区的默认值是1.0，表示最大的深度值，深度值的范围在[0,1]之间，值越小表示越靠近观察者，值越大表示远离观察者。
//    glEnable(GL_DEPTH_TEST);
//}

//- (void)genVertexBuffer:(GLfloat *)vertexDatas
//                  usage:(GLenum)usage
//{
//    glGenBuffers(1, &vertexbuffers);
//    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffers);
//    glBufferData(GL_ARRAY_BUFFER,
//                 sizeof(vertexData),
//                 vertexData,
//                 usage);
//}

//- (void)enableVertexAttribArray:(GLint)indx
//                     vertexSize:(GLint)v_size
//                   vertexStride:(GLsizei)v_stride
//                   vertexOffset:(const GLvoid *)ptr
//{
//    glVertexAttribPointer(indx,
//                          v_size,
//                          GL_FLOAT,
//                          GL_FALSE,
//                          v_stride,
//                          ptr);
//
//    glEnableVertexAttribArray(indx);
//}



//纹理缓存
- (void)loadTextureBuffer
{
//    UIImage *textureIMG = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpeg"]];
//    CGImageRef textureImgRef = textureIMG.CGImage;
//
//    size_t width = CGImageGetWidth(textureImgRef);
//    size_t height = CGImageGetHeight(textureImgRef);
//
//    GLbyte *spriteData = (GLbyte *)malloc(width * height * 4 * sizeof(GLbyte));
//    CGContextRef contextRef = CGBitmapContextCreate(spriteData, width, height, 8, width * 4 , CGImageGetColorSpace(textureImgRef), kCGImageAlphaPremultipliedLast);
//    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), textureImgRef);
//
//    glGenTextures(1, &_texturebuffers);
//    glBindBuffer(GL_TEXTURE_2D, _texturebuffers);
//
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (float)width, (float)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
//
//    glBindBuffer(GL_TEXTURE_2D, _texturebuffers);
//    glActiveTexture(GL_TEXTURE_2D);
//
//    free(spriteData);
//    CGContextRelease(contextRef);
}

//着色器
- (void)loadShader:(NSString *)vertexFile fragment:(NSString *)fragmentFile
{
    vertexShader = [self complieShader:vertexFile andShaderType:GL_VERTEX_SHADER];
    fragmentShader = [self complieShader:fragmentFile andShaderType:GL_FRAGMENT_SHADER];
    
    program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    //释放不需要的shader
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    glLinkProgram(program);
    //检查链接
    GLint linkStatus;
    glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
    if (linkStatus == GL_FALSE) {
        GLsizei bufsize = 0;
        GLchar infolog[256];
        glGetShaderInfoLog(program, 256, &bufsize, infolog);
        NSString *infoStr = [NSString stringWithFormat:@"%s",infolog];
        NSLog(@"%@",infoStr);
    }else{
        glUseProgram(program);
    }
}

- (GLuint)complieShader:(NSString *)shaderFile andShaderType:(GLenum)shaderType
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:shaderFile ofType:@"glsl"];
    
    NSError *error;
    NSString *shaderStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"加载shader错误");
    }
    
    const char *utf8_Str = shaderStr.UTF8String;
    
    GLuint shader;
    shader = glCreateShader(shaderType);
    // glShaderSource 不明确
    glShaderSource(shader, 1, &utf8_Str, NULL);
    glCompileShader(shader);
    
    //检查编译
    GLint compileStatus;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
    if (compileStatus == GL_FALSE) {
        GLsizei bufsize = 0;
        GLchar infolog[256];
        glGetShaderInfoLog(shader, 256, &bufsize, infolog);
        NSString *infoStr = [NSString stringWithFormat:@"%s",infolog];
        NSLog(@"%@",infoStr);
    }
    return shader;
}

@end
