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

@property (nonatomic,assign)CGPoint startP;
@property (nonatomic,assign)CGPoint endP;

@property (nonatomic,assign)GLuint modelViewUniform; //模型矩阵
@end

@implementation JH_OpenGLLightView
@synthesize vertexbuffers = _vertexbuffers;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //开启背面剔除
//        glCullFace(GL_BACK);

        //加载着色器
        [self.gl_effect loadShader:@"VertexLight" fragment:@"FragmentLight"];
        
        //材质反光性设置
        GLfloat mat_specular[4] = { 1.0, 1.0, 1.0, 1.0 };  //镜面反射参数
        GLfloat mat_shininess[1] = { 50.0 };               //高光指数
        GLfloat white_light[4] = { 1.0, 1.0, 1.0, 1.0 };   //灯位置(1,1,1), 最后1-开关
        GLfloat Light_Model_Ambient[4] = { 0.2, 0.2, 0.2, 1.0 }; //环境光参数
        GLfloat light_Position[4] = {1.0, 1.0, -0.6, 1.0};
        
        glClearColor(0.0, 0.0, 0.0, 0.0);  //背景色
        glShadeModel(GL_SMOOTH);           //多变性填充模式
        
        //材质属性
        glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
        glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
        
        
        //        //设置灯光（坏境光源）
        //        glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
        //        glEnable(GL_LIGHT0);   // #允许GL_LIGHT0灯的使用
        
        //设置光源位置
        glLightfv(GL_LIGHT0, GL_POSITION, light_Position);
        
        //漫反射
        glLightfv(GL_LIGHT0, GL_DIFFUSE, white_light);
        
        //镜面光
        glLightfv(GL_LIGHT0, GL_SPECULAR, white_light);
        glLightModelfv(GL_LIGHT_MODEL_AMBIENT, Light_Model_Ambient);
        
        glEnable(GL_LIGHTING); // #开灯
        glEnable(GL_LIGHT0);
        glEnable(GL_DEPTH_TEST);
        
        [self loadVertexData];
    }
    return self;
}

//加载顶点数据
- (void)loadVertexData
{
    glGenBuffers(1, &_vertexbuffers);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexbuffers);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexLightData), vertexLightData, GL_STATIC_DRAW);
    
    GLuint positionBuffer = glGetAttribLocation(self.gl_effect.program, "position");
    glVertexAttribPointer(positionBuffer, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, 0 + NULL);
    glEnableVertexAttribArray(positionBuffer);
    
    GLuint positionColorBuffer = glGetAttribLocation(self.gl_effect.program, "positionColor");
    glVertexAttribPointer(positionColorBuffer, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, 3 * sizeof(GLfloat) + NULL);
    glEnableVertexAttribArray(positionColorBuffer);

    _modelViewUniform = glGetUniformLocation(self.gl_effect.program, "modelViewMatrix");
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 0.0);
    glUniformMatrix4fv(_modelViewUniform, 1, GL_FALSE, &modelViewMatrix.m[0]);
    
    GLuint projectUniform = glGetUniformLocation(self.gl_effect.program, "projectMatrix");
    float wh_rate = JH_ScreenWidth / JH_ScreenHeight;
    GLKMatrix4 projectMatrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(M_PI/2.0), wh_rate, 0.1, 100.0);
    glUniformMatrix4fv(projectUniform, 1, GL_FALSE, &projectMatrix.m[0]);
}

- (void)updateSenceData
{
    //转换为旋转角
    float rotateAngle = M_PI * 2 / JH_ScreenHeight * (det_y + move_y);
    NSLog(@"旋转角 ~ %f",rotateAngle);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 0.0);
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0, -0.1, 0.3);
    
    //左乘旋转矩阵
    GLKMatrix4 rm = GLKMatrix4MakeXRotation(rotateAngle);
    modelViewMatrix = GLKMatrix4Multiply(rm, modelViewMatrix);

    GLKMatrix4 t_matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.1, -0.6);
    modelViewMatrix = GLKMatrix4Multiply(t_matrix, modelViewMatrix);
    glUniformMatrix4fv(_modelViewUniform, 1, GL_FALSE, &modelViewMatrix.m[0]);
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
    [self updateSenceData];
    
//    GL_STENCIL_BUFFER_BIT(模板缓存区)
    glClearColor(color.red, color.green, color.blue, color.alpha);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

    //开启混合模式
    glEnable(GL_BLEND);
    //源颜色 ~ 目标颜色  源颜色因子sf 目标颜色因子df
    //颜色混合 （sr*sf + dr*df, sg*sf + dg*df, sb*sf + db*df, sa*sf + da*df）
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertexLightData)/sizeof(GLfloat)/8);
    [self.gl_effect.gl_context presentRenderbuffer:GL_RENDERBUFFER];
    
}



@end
