//
//  JH_OpenGLLightView.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/30.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLLightView.h"
#import "JH_LightAttributeMesh.h"
#import "JH_OpenGLAttribute.h"

@interface JH_OpenGLLightView ()
{
    float det_y;
    float move_y;
}

@property (nonatomic,assign)GLuint lightVBO;

@property (nonatomic,assign)CGPoint startP;
@property (nonatomic,assign)CGPoint endP;

@property (nonatomic,assign)GLuint normalBuffer;

@property (nonatomic,strong)JH_OpenGLAttribute *vertexAttribute;
@property (nonatomic,strong)JH_OpenGLAttribute *normalAttribute;

@end

@implementation JH_OpenGLLightView

@synthesize vertexbuffers = _vertexbuffers;
@synthesize lightbuffers = _lightbuffers;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //光照着色器
        [self.gl_lightEffect loadShader:@"VertexLight" fragment:@"FragmentLight"];

        //加载着色器
        [self.gl_effect loadShader:@"VertexObj" fragment:@"FragmentObj"];

        //加载Obj数据
        self.vertexAttribute = [[JH_OpenGLAttribute alloc] init];
        self.normalAttribute = [[JH_OpenGLAttribute alloc] init];
        [self loadVertexObjData];

        //加载灯光数据
        [self loadVertexLightData];
    }
    return self;
}

//加载顶点数据
- (void)loadVertexObjData
{
    [self.vertexAttribute genVertexBufferWithAttribStride:sizeof(vertexObjData) bytes:vertexObjData usage:GL_STATIC_DRAW];
    [self.normalAttribute genVertexBufferWithAttribStride:sizeof(vertexObjNormalData) bytes:vertexObjNormalData usage:GL_STATIC_DRAW];
}

//加载顶点数据
- (void)loadVertexLightData
{
    //VAO 绑定顶点属性数据数组
    glGenVertexArraysOES(1, &_lightVBO);

    //VBO
    glGenBuffers(1, &_lightbuffers);
    glBindBuffer(GL_ARRAY_BUFFER, _lightbuffers);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexLightData), vertexLightData, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(_lightVBO);
    
    GLuint lightPositionBuffer = glGetAttribLocation(self.gl_lightEffect.program, "lightPosition");
    glVertexAttribPointer(lightPositionBuffer, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, 0 + NULL);
    glEnableVertexAttribArray(lightPositionBuffer);
}


- (void)updateObjSenceData
{
    //转换为旋转角
    float rotateAngle = M_PI * 2 / JH_ScreenHeight * (det_y + move_y);
//    NSLog(@"旋转角 ~ %f",rotateAngle);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    GLKMatrix4 t_matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, -0.1, 0.3);
    modelViewMatrix = GLKMatrix4Multiply(t_matrix, modelViewMatrix);
    
    //左乘旋转矩阵
    GLKMatrix4 r_matrix = GLKMatrix4MakeXRotation(rotateAngle);
    modelViewMatrix = GLKMatrix4Multiply(r_matrix, modelViewMatrix);

    t_matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.1, -0.6);
    modelViewMatrix = GLKMatrix4Multiply(t_matrix, modelViewMatrix);
    self.gl_effect.modelViewMatrix4 = modelViewMatrix;
    
    float wh_rate = JH_ScreenWidth / JH_ScreenHeight;
    self.gl_effect.projectMatrix4 = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(M_PI/2.0), wh_rate, 0.1, 100.0);
}


- (void)updateLightSenceData
{
//    float rotateAngle = M_PI * 2 / JH_ScreenHeight * (det_y + move_y);
    //    NSLog(@"旋转角 ~ %f",rotateAngle);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    GLKMatrix4 t_matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 0.5);
    modelViewMatrix = GLKMatrix4Multiply(t_matrix, modelViewMatrix);

    t_matrix = GLKMatrix4Translate(GLKMatrix4Identity, 2.0, 4.0, -4.0);
    modelViewMatrix = GLKMatrix4Multiply(t_matrix, modelViewMatrix);
    
    GLKMatrix4 s_matrix = GLKMatrix4MakeScale(0.1, 0.1, 0.1);
    modelViewMatrix = GLKMatrix4Multiply(s_matrix, modelViewMatrix);
    
    //需重新传递modelview project矩阵
    self.gl_lightEffect.modelViewMatrix4 = modelViewMatrix;
    
    float wh_rate = JH_ScreenWidth / JH_ScreenHeight;
    self.gl_lightEffect.projectMatrix4 = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(M_PI/2.0), wh_rate, 0.1, 100.0);
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    self.startP = [touch locationInView:self];
    self.endP = [touch locationInView:self];
    move_y = 0.0;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    self.endP = [touch locationInView:self];
    move_y = self.endP.y - self.startP.y;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    self.endP = [touch locationInView:self];
    det_y += move_y;
    move_y = 0.0;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    self.endP = [touch locationInView:self];
    det_y += move_y;
    move_y = 0.0;
}


#pragma mark - render
- (void)renderGLView:(JH_ColorRGBA)color
{
//    GL_STENCIL_BUFFER_BIT(模板缓存区)
    glClearColor(color.red, color.green, color.blue, color.alpha);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

    //开启混合模式
    glEnable(GL_BLEND);
    //源颜色 ~ 目标颜色  源颜色因子sf 目标颜色因子df
    //颜色混合 （sr*sf + dr*df, sg*sf + dg*df, sb*sf + db*df, sa*sf + da*df）
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    //光照
    glUseProgram(self.gl_lightEffect.program);
    //模型变换
    [self updateLightSenceData];

    glBindVertexArrayOES(_lightVBO);
    GLuint lightColorBuffer1 = glGetUniformLocation(self.gl_lightEffect.program, "illuminantColor");
    glUniform3f(lightColorBuffer1, 1.0, 1.0, 1.0);

    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertexLightData)/sizeof(GLfloat)/3);
    glBindVertexArrayOES(0);

    
    //obj
    glUseProgram(self.gl_effect.program);
    
    GLuint lightColorBuffer0 = glGetUniformLocation(self.gl_effect.program, "lightColor");
    glUniform3f(lightColorBuffer0, 1.0, 1.0, 1.0);
    
    //摄像机位置
    GLuint cameraPositionBuffer = glGetUniformLocation(self.gl_effect.program, "cameraPosition");
    glUniform3f(cameraPositionBuffer, 0.0, 0.0, 0.0);
    
    GLuint positionBuffer = glGetAttribLocation(self.gl_effect.program, "position");
    [self.vertexAttribute enableVertexBufferWithAttribArray:positionBuffer size:3 stride:sizeof(GLfloat) * 8 vertexOffset:0 + NULL];
    
    GLuint positionColorBuffer = glGetAttribLocation(self.gl_effect.program, "positionColor");
    [self.vertexAttribute enableVertexBufferWithAttribArray:positionColorBuffer size:3 stride:sizeof(GLfloat) * 8 vertexOffset:3 * sizeof(GLfloat) + NULL];
    
    GLuint positionNormalBuffer = glGetAttribLocation(self.gl_effect.program, "positionNormal");
    [self.normalAttribute enableVertexBufferWithAttribArray:positionNormalBuffer size:3 stride:sizeof(GLfloat) * 3 vertexOffset:0 + NULL];

    //模型变换
    [self updateObjSenceData];

    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertexObjData)/sizeof(GLfloat)/8);
    
    //渲染 后帧 -> 前帧
    [self.gl_context presentRenderbuffer:GL_RENDERBUFFER];

}



@end
