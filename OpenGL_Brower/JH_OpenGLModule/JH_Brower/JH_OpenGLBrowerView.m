//
//  JH_OpenGLBrowerView.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/28.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLBrowerView.h"
#import "JH_BrowerAttributeMesh.h"

@interface JH_OpenGLBrowerView ()

//模型变换
@property (nonatomic, assign)GLuint modelViewMatrix;

//记录原来的视距
@property (nonatomic, assign)GLfloat originViewDistant;

@end

@implementation JH_OpenGLBrowerView
@synthesize vertexbuffers = _vertexbuffers;


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //加载着色器
        [self.gl_effect loadShader:@"Vertex" fragment:@"Fragment"];
        
        [self loadVertexData];
        
        
        //加载纹理
        //        [self loadTextureBuffer];
    }
    return self;
}

- (void)loadVertexData
{
    //    //顶点数组赋值
    //    GLfloat *vertexBuffer = (GLfloat *)calloc(count, sizeof(GLfloat));
    //    memcpy(vertexBuffer, vertexData, count * sizeof(GLfloat));
    //
    ////    vertexDataBuffer = realloc(vertexDataBuffer, count * sizeof(GLfloat));
    //    for (int i = 0; i < count; i ++) {
    //        vertexDataBuffer[i] = vertexBuffer[i];
    //        NSLog(@"%f",vertexDataBuffer[i]);
    //    }
    
    glGenBuffers(1, &_vertexbuffers);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexbuffers);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    //顶点赋值
    GLuint position = glGetAttribLocation(self.gl_effect.program, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), NULL);
    glEnableVertexAttribArray(position);
    
    //顶点颜色
    GLuint positionColor = glGetAttribLocation(self.gl_effect.program, "positionColor");
    glVertexAttribPointer(positionColor, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), 3 * sizeof(GLfloat) + NULL);
    glEnableVertexAttribArray(positionColor);
    
    //纹理
    GLuint texturePosition = glGetAttribLocation(self.gl_effect.program, "texturePosition");
    glVertexAttribPointer(texturePosition, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), 6 * sizeof(GLfloat) + NULL);
    glEnableVertexAttribArray(texturePosition);
    
    //模型矩阵（NDC z轴向内为 +）
    self.modelViewMatrix = glGetUniformLocation(self.gl_effect.program, "modelViewMatrix");
    GLKMatrix4 mv_Matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 0.0);
    glUniformMatrix4fv(self.modelViewMatrix, 1, GL_FALSE, &mv_Matrix.m[0]);
    
    //投影矩阵
    GLuint projectMatrix = glGetUniformLocation(self.gl_effect.program, "projectMatrix");
    float aspect = self.frame.size.width / self.frame.size.height;
    GLKMatrix4 p_Matrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(M_PI/2.0), aspect, 0.1, 100.0);
    //    GLKMatrix4 p_Matrix = GLKMatrix4MakeLookAt(0, 0, 1,
    //                                               0, 0, 0,
    //                                               0, 1, 0);
    
    glUniformMatrix4fv(projectMatrix, 1, GL_FALSE, &p_Matrix.m[0]);
    
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

//平滑过渡函数
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
    return -smoothY;
}


- (void)renderGLView:(JH_ColorRGBA)color
{
    //模型刷新
    [self updateData];
    
    //开启深度测试
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    
    glClearColor(color.red, color.green, color.blue, color.alpha);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertexData)/sizeof(GLfloat)/8);
    [self.gl_effect.gl_context presentRenderbuffer:GL_RENDERBUFFER];

}

@end
