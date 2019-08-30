//
//  JH_AttributeStruct.h
//  OpenGL_Brower
//
//  Created by walen on 2019/8/19.
//  Copyright © 2019 CJH. All rights reserved.
//


#import <GLKit/GLKit.h>

struct JH_MeshPoint {
    GLfloat position[3];
    GLfloat postionColor[3];
    GLfloat texture[2];
};

struct JH_VertexPoint {
    GLfloat x;
    GLfloat y;
};
typedef struct JH_VertexPoint JH_VertexPoint;
CG_INLINE JH_VertexPoint JH_VertexPointMake(GLfloat x,GLfloat y)
{
    JH_VertexPoint p;p.x = x;p.y = y;return p;
}


struct JH_ColorRGBA {
    GLfloat red;
    GLfloat green;
    GLfloat blue;
    GLfloat alpha;
};
typedef struct JH_ColorRGBA JH_ColorRGBA; //定义别名
CG_INLINE JH_ColorRGBA JH_ColorRGBAMake(CGFloat r,CGFloat g,CGFloat b,CGFloat a)
{
    JH_ColorRGBA p; p.red = r; p.green = g; p.blue = b; p.alpha = a; return p;
};

