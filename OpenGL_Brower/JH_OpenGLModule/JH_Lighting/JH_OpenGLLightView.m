//
//  JH_OpenGLLightView.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/30.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLLightView.h"
#import "JH_LightAttributeMesh.h"
#import <GLKit/GLKit.h>

@interface JH_OpenGLLightView ()
{
    float det_y;
    float move_y;
}
@property (nonatomic,assign)GLuint objVAO;
@property (nonatomic,assign)GLuint lightVAO;

@property (nonatomic,assign)CGPoint startP;
@property (nonatomic,assign)CGPoint endP;

@property (nonatomic,assign)GLuint modelViewObjUniform;   //Obj模型矩阵
@property (nonatomic,assign)GLuint modelViewLightUniform; //Lighting模型矩阵
@property (nonatomic,assign)GLuint projectObjUniform;
@property (nonatomic,assign)GLuint projectLightUniform;

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
        [self loadVertexObjData];

        //加载灯光数据
        [self loadVertexLightData];
    }
    return self;
}

//加载顶点数据
- (void)loadVertexObjData
{
    glGenVertexArraysOES(1, &_objVAO);
    
    glGenBuffers(1, &_vertexbuffers);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexbuffers);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexObjData), vertexObjData, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(_objVAO);
    
    GLuint positionBuffer = glGetAttribLocation(self.gl_effect.program, "position");
    glVertexAttribPointer(positionBuffer, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, 0 + NULL);
    glEnableVertexAttribArray(positionBuffer);
    
    GLuint positionColorBuffer = glGetAttribLocation(self.gl_effect.program, "positionColor");
    glVertexAttribPointer(positionColorBuffer, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, 3 * sizeof(GLfloat) + NULL);
    glEnableVertexAttribArray(positionColorBuffer);
}

//加载顶点数据
- (void)loadVertexLightData
{
    //VAO
    glGenVertexArraysOES(1, &_lightVAO);
    
    //VBO
    glGenBuffers(1, &_lightbuffers);
    glBindBuffer(GL_ARRAY_BUFFER, _lightbuffers);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexLightData), vertexLightData, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(_lightVAO);
    
    GLuint lightPositionBuffer = glGetAttribLocation(self.gl_lightEffect.program, "lightPosition");
    glVertexAttribPointer(lightPositionBuffer, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, 0 + NULL);
    glEnableVertexAttribArray(lightPositionBuffer);
    
    GLuint lightPositionColorBuffer = glGetAttribLocation(self.gl_lightEffect.program, "lightPositionColor");
    glVertexAttribPointer(lightPositionColorBuffer, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, 3 * sizeof(GLfloat) + NULL);
    glEnableVertexAttribArray(lightPositionColorBuffer);

//    GLuint lightColorBuffer = glGetUniformLocation(self.gl_lightEffect.program, "lightColor");
//    glUniform3f(lightColorBuffer, 1.0, 1.0, 1.0);
    
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
    
    _modelViewObjUniform = glGetUniformLocation(self.gl_effect.program, "modelViewMatrix");
    glUniformMatrix4fv(_modelViewObjUniform, 1, GL_FALSE, &modelViewMatrix.m[0]);
    
    _projectObjUniform = glGetUniformLocation(self.gl_effect.program, "projectMatrix");
    float wh_rate = JH_ScreenWidth / JH_ScreenHeight;
    GLKMatrix4 projectMatrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(M_PI/2.0), wh_rate, 0.1, 100.0);
    glUniformMatrix4fv(_projectObjUniform, 1, GL_FALSE, &projectMatrix.m[0]);
}


- (void)updateLightSenceData
{
    float rotateAngle = M_PI * 2 / JH_ScreenHeight * (det_y + move_y);
    //    NSLog(@"旋转角 ~ %f",rotateAngle);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    GLKMatrix4 t_matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 0.5);
    modelViewMatrix = GLKMatrix4Multiply(t_matrix, modelViewMatrix);
    
    //左乘旋转矩阵
    GLKMatrix4 r_matrix = GLKMatrix4MakeXRotation(rotateAngle);
    modelViewMatrix = GLKMatrix4Multiply(r_matrix, modelViewMatrix);

    t_matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 2.0, -4.0);
    modelViewMatrix = GLKMatrix4Multiply(t_matrix, modelViewMatrix);
    
    GLKMatrix4 s_matrix = GLKMatrix4MakeScale(0.1, 0.1, 0.1);
    modelViewMatrix = GLKMatrix4Multiply(s_matrix, modelViewMatrix);
    
    //需重新传递modelview project矩阵
    _modelViewLightUniform = glGetUniformLocation(self.gl_lightEffect.program, "lightModelViewMatrix");
    glUniformMatrix4fv(_modelViewLightUniform, 1, GL_FALSE, &modelViewMatrix.m[0]);
    
    _projectLightUniform = glGetUniformLocation(self.gl_lightEffect.program, "lightProjectMatrix");
    float wh_rate = JH_ScreenWidth / JH_ScreenHeight;
    GLKMatrix4 projectMatrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(M_PI/2.0), wh_rate, 0.1, 100.0);
    glUniformMatrix4fv(_projectLightUniform, 1, GL_FALSE, &projectMatrix.m[0]);
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
    
    //obj
    glUseProgram(self.gl_effect.program);

    //模型变换
    [self updateObjSenceData];

    glBindVertexArrayOES(_objVAO);
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertexObjData)/sizeof(GLfloat)/8);

    //光照
    glUseProgram(self.gl_lightEffect.program);
    //模型变换
    [self updateLightSenceData];

    glBindVertexArrayOES(_lightVAO);
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertexLightData)/sizeof(GLfloat)/6);
    
    //渲染 后帧 -> 前帧
    [self.gl_context presentRenderbuffer:GL_RENDERBUFFER];

}



@end
