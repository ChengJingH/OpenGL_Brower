//
//  JH_OpenGLDrawView.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/28.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLDrawView.h"

#define JH_ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define JH_ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface JH_OpenGLDrawView ()

@property (nonatomic, strong)NSMutableData *vertexData;

@end

@implementation JH_OpenGLDrawView
@synthesize vertexbuffers = vertexbuffers;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //加载着色器
        [self.gl_effect loadShader:@"VertexDraw" fragment:@"FragmentDraw"];
        
        [self loadVertexData];
        
        
        //加载纹理
        //        [self loadTextureBuffer];
    }
    return self;
}

- (void)loadVertexData
{
    //绑定顶点缓存数据
    glGenBuffers(1, &vertexbuffers);
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffers);
    glBufferData(GL_ARRAY_BUFFER, _vertexData.length, _vertexData.bytes, GL_DYNAMIC_DRAW);

    GLuint point = glGetAttribLocation(self.gl_effect.program, "position");
    glVertexAttribPointer(point, 2, GL_FLOAT, GL_FALSE, sizeof(JH_VertexPoint), offsetof(JH_VertexPoint, x) + NULL);
    glEnableVertexAttribArray(point);
}


#pragma mark - 渲染
- (void)renderGLView:(JH_ColorRGBA)color
{
    glClearColor(color.red, color.green, color.blue, color.alpha);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    //传输数据
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffers);
    glBufferData(GL_ARRAY_BUFFER, _vertexData.length, _vertexData.bytes, GL_DYNAMIC_DRAW);

    //顶点
    GLuint point = glGetAttribLocation(self.gl_effect.program, "position");
    glVertexAttribPointer(point, 2, GL_FLOAT, GL_FALSE, sizeof(JH_VertexPoint), offsetof(JH_VertexPoint, x) + NULL);
    glEnableVertexAttribArray(point);
    
    //顶点颜色
    GLuint pointColorFlag = glGetUniformLocation(self.gl_effect.program, "positionColorFlag");
    glUniform1i(pointColorFlag, self.colorFlag);
    
    glDrawArrays(GL_POINTS, 0, (int32_t)_vertexData.length/sizeof(JH_VertexPoint));
    [self.gl_context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - private method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *beganTouch = touches.allObjects.firstObject;
    JH_VertexPoint beganPoint = [self convertScreenToNDC:[beganTouch locationInView:self]];
    NSLog(@"x ~ %f;y ~ %f",beganPoint.x,beganPoint.y);

    NSData *pointData = [NSData dataWithBytes:&beganPoint length:sizeof(beganPoint)];
    [self.vertexData appendData:pointData];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *moveTouch = touches.allObjects.firstObject;
    JH_VertexPoint curPoint = [self convertScreenToNDC:[moveTouch locationInView:self]];
    NSLog(@"x ~ %f;y ~ %f",curPoint.x,curPoint.y);

    NSData *pointData = [NSData dataWithBytes:&curPoint length:sizeof(curPoint)];
    [self.vertexData appendData:pointData];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}

- (JH_VertexPoint)convertScreenToNDC:(CGPoint)point
{
    GLfloat widthRate = (2*point.x - JH_ScreenWidth)/JH_ScreenWidth;
    GLfloat heightRate = (JH_ScreenHeight - 2*point.y)/JH_ScreenHeight;
    return JH_VertexPointMake(widthRate, heightRate);
}

#pragma mark - property
- (NSMutableData *)vertexData
{
    if (!_vertexData) {
        _vertexData = [[NSMutableData alloc] init];
    }
    return _vertexData;
}





@end
