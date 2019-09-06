//
//  JH_AttributeStruct.h
//  OpenGL_Brower
//
//  Created by walen on 2019/8/19.
//  Copyright © 2019 CJH. All rights reserved.
//


struct JH_MeshPoint {
    float position[3];
    float postionColor[3];
    float texture[2];
};

struct JH_VertexPoint {
    float x;
    float y;
};
typedef struct JH_VertexPoint JH_VertexPoint;
static inline JH_VertexPoint JH_VertexPointMake(float x,float y)
{
    JH_VertexPoint p;p.x = x;p.y = y;return p;
}

struct JH_ColorRGBA {
    float red;
    float green;
    float blue;
    float alpha;
};
typedef struct JH_ColorRGBA JH_ColorRGBA; //定义别名
static inline JH_ColorRGBA JH_ColorRGBAMake(float r,float g,float b,float a)
{
    JH_ColorRGBA p; p.red = r; p.green = g; p.blue = b; p.alpha = a; return p;
};

