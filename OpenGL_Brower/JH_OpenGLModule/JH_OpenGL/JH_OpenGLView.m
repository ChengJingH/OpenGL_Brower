//
//  CJ_OpenGLBrowerView.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/12.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLView.h"

@implementation JH_OpenGLView
//+ (Class)layerClass
//{
//    return CAEAGLLayer.class;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        //设置上下文
        self.gl_effect = [[JH_OpenGLEffect alloc] init];
        [self.gl_effect setCurrentContext];
        
        self.gl_layer = [[CAEAGLLayer alloc] init];
        self.gl_layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.gl_layer.drawableProperties = @{kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyRetainedBacking:[NSNumber numberWithBool:NO]};
        self.gl_layer.opaque = YES;
        [self.layer addSublayer:self.gl_layer];
        
        CGFloat scale = 1; //获取视图放大倍数，可以把scale设置为1试试
//        glViewport(self.frame.origin.x * scale, (self.frame.size.height * scale - self.frame.size.width * scale)/2.0 , self.frame.size.width * scale, self.frame.size.width * scale); //设置视口大小
        glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale , self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
        
        glClearColor(0.5, 0.5, 0.5, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        //剔除后面
//        glCullFace(GL_BACK);
        
        //创建缓存区
        [self createRenderBuffer];
        [self createFrameBuffer];

    }
    return self;
}

- (void)createFrameBuffer
{
    glGenFramebuffers(1, &_framebuffers);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffers);
    
    //帧缓存区 （后帧 --> 前帧渲染）
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderbuffers);
    //关联深度缓冲到帧缓冲区
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffers);
    
    GLenum frameStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameStatus == GL_FALSE) {
        NSLog(@"frameBuffer error");
    }
}

- (void)createRenderBuffer
{
    glGenRenderbuffers(1, &_renderbuffers);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffers);
    [self.gl_effect.gl_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.gl_layer];
    
    //创建深度缓存区
    GLint width;
    GLint height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    //和颜色缓冲不同的就是使用glRenderbufferStorage()函数进行分配的时候，需要指定缓冲区的宽高。其中第二个参数表示计算精度，值越高越平滑，当然内存也消耗的更大。
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    
    //     清除深度缓冲区的默认值是1.0，表示最大的深度值，深度值的范围在[0,1]之间，值越小表示越靠近观察者，值越大表示远离观察者。
    glEnable(GL_DEPTH_TEST);
}


//顶点数据
- (void)loadVertexData{}

//渲染
- (void)renderGLView:(JH_ColorRGBA)color{}



@end
