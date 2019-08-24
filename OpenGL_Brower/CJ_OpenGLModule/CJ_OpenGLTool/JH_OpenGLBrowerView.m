//
//  CJ_OpenGLBrowerView.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/12.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLBrowerView.h"
#import "JH_AttributeMesh.h"
#import "JH_AttributeStruct.h"

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@interface JH_OpenGLBrowerView ()

@property (nonatomic, strong)EAGLContext *gl_context;
@property (nonatomic, strong)CAEAGLLayer *gl_layer;

@property (nonatomic, assign)GLuint framebuffers;
@property (nonatomic, assign)GLuint renderbuffers;
@property (nonatomic, assign)GLuint depthBuffer;


@property (nonatomic, assign)GLuint vertexbuffers;
@property (nonatomic, assign)GLuint texturebuffers;
@property (nonatomic, assign)GLuint indexbuffers;

@property (nonatomic, assign)GLuint program;

//模型变换
@property (nonatomic, assign)GLuint modelViewMatrix;


//记录原来的视距
@property (nonatomic,assign)GLfloat originViewDistant;

@end


@implementation JH_OpenGLBrowerView

@synthesize program = program;

//+ (Class)layerClass
//{
//    return CAEAGLLayer.class;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor lightGrayColor];
        
        //设置上下文
        self.gl_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:self.gl_context];
        
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
        
//        //剔除后面
//        glCullFace(GL_BACK);
        
        //创建缓存区
        [self createRenderBuffer];
        [self createFrameBuffer];
        
        //加载着色器
        [self loadShader];
        
        //加载顶点数据
        [self loadVertexData];
        
        //加载纹理
//        [self loadTextureBuffer];
        
    }
    return self;
}

//帧缓存区
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

//渲染缓存区
- (void)createRenderBuffer
{
    glGenRenderbuffers(1, &_renderbuffers);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffers);
    [self.gl_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.gl_layer];

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
- (void)loadVertexData
{
    //顶点
    glGenBuffers(1, &_vertexbuffers);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexbuffers);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    //顶点赋值
    GLuint position = glGetAttribLocation(self.program, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), NULL);
    glEnableVertexAttribArray(position);

    //顶点颜色
    GLuint positionColor = glGetAttribLocation(self.program, "positionColor");
    glVertexAttribPointer(positionColor, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), 3 * sizeof(GLfloat) + NULL);
    glEnableVertexAttribArray(positionColor);

    //纹理
    GLuint texturePosition = glGetAttribLocation(self.program, "texturePosition");
    glVertexAttribPointer(texturePosition, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), 6 * sizeof(GLfloat) + NULL);
    glEnableVertexAttribArray(texturePosition);
    
    //模型矩阵（NDC z轴向内为 +）
    self.modelViewMatrix = glGetUniformLocation(self.program, "modelViewMatrix");
    GLKMatrix4 mv_Matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 0.0);
    glUniformMatrix4fv(self.modelViewMatrix, 1, GL_FALSE, &mv_Matrix.m[0]);
    
    //投影矩阵
    GLuint projectMatrix = glGetUniformLocation(self.program, "projectMatrix");
    float aspect = self.frame.size.width / self.frame.size.height;
    GLKMatrix4 p_Matrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(M_PI/2.0), aspect, 0.1, 100.0);
//    GLKMatrix4 p_Matrix = GLKMatrix4MakeLookAt(0, 0, 1,
//                                               0, 0, 0,
//                                               0, 1, 0);

    glUniformMatrix4fv(projectMatrix, 1, GL_FALSE, &p_Matrix.m[0]);
    
}

- (void)glEnableAttribute
{
    
}

//纹理缓存
- (void)loadTextureBuffer
{
    UIImage *textureIMG = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpeg"]];
    CGImageRef textureImgRef = textureIMG.CGImage;
    
    size_t width = CGImageGetWidth(textureImgRef);
    size_t height = CGImageGetHeight(textureImgRef);
    
    GLbyte *spriteData = (GLbyte *)malloc(width * height * 4 * sizeof(GLbyte));
    CGContextRef contextRef = CGBitmapContextCreate(spriteData, width, height, 8, width * 4 , CGImageGetColorSpace(textureImgRef), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), textureImgRef);
    
    glGenTextures(1, &_texturebuffers);
    glBindBuffer(GL_TEXTURE_2D, _texturebuffers);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (float)width, (float)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    glBindBuffer(GL_TEXTURE_2D, _texturebuffers);
    glActiveTexture(GL_TEXTURE_2D);
    
    free(spriteData);
    CGContextRelease(contextRef);
}

//着色器
- (void)loadShader
{
    GLuint vertexShader,fragmentShader;
    vertexShader = [self complieShader:@"Vertex" andShaderType:GL_VERTEX_SHADER];
    fragmentShader = [self complieShader:@"Fragment" andShaderType:GL_FRAGMENT_SHADER];
    
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
    
#pragma mark -- private methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

//更新数据
- (void)updateData
{
    static int frameCount = 0;
    frameCount ++;
    smoothCount ++;
    
    GLKMatrix4 mv_Matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 0.0);
    mv_Matrix = GLKMatrix4Translate(mv_Matrix, 0.0, 0.0, [self smoothAnimal]);
    mv_Matrix = GLKMatrix4RotateX(mv_Matrix, GLKMathDegreesToRadians(frameCount * 1));
    glUniformMatrix4fv(self.modelViewMatrix, 1, GL_FALSE, &mv_Matrix.m[0]);

}


static int smoothCount = 0;
- (void)setCurrentViewDistant:(GLfloat)currentViewDistant
{
    _currentViewDistant = currentViewDistant;
    smoothCount = 0;
}

- (CGFloat)smoothAnimal
{
    //https://blog.csdn.net/libing_zeng/article/details/68924521
    //平滑过渡函数 smoothStep(x) = 3x^2 - 2x^3 = x^2(3 - 2x)
    if (smoothCount > 50) {
        self.originViewDistant = self.currentViewDistant;
        return -self.currentViewDistant;
    }
    
    CGFloat offset_x = self.currentViewDistant - self.originViewDistant;
    CGFloat periodX = smoothCount * 0.02;
    CGFloat smoothY = offset_x * periodX * periodX * (3 - 2 * periodX) + self.originViewDistant;
    NSLog(@"过渡视距 ~ %f",-smoothY);
    return -smoothY;
}

//渲染
- (void)renderGLView
{
    //模型刷新
    [self updateData];
    
    //开启深度测试
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);


    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertexData)/sizeof(GLfloat)/8);
    [self.gl_context presentRenderbuffer:GL_RENDERBUFFER];
}



@end
