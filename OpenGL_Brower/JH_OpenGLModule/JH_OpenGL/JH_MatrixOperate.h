//
//  JH_MatrixOperate.h
//  OpenGL_Brower
//
//  Created by walen on 2019/9/4.
//  Copyright © 2019 CJH. All rights reserved.
//

#ifndef JH_MatrixOperate_h
#define JH_MatrixOperate_h

#include <stdio.h>


//矩阵(联合体)
//__attribute((aligned (n)))，让所作用的结构成员对齐在n字节自然边界上。如果结构中有成员的长度大于n，则按照最大成员的长度来对齐
union _JH_Matrix{
    struct{
        float m00, m01, m02, m03;
        float m10, m11, m12, m13;
        float m20, m21, m22, m23;
        float m30, m31, m32, m33;
    };
    float m[16];
} __attribute((aligned(16)));
typedef union _JH_Matrix JH_Matrix;

union _JH_Vector3{
    struct{
        float x,y,z;
    };
    float v[3];
} __attribute((aligned(4)));
typedef union _JH_Vector3 JH_Vector3;

//矩阵变换(平移)
JH_Matrix matrixTransfer(JH_Matrix m);

//法线向量
JH_Vector3 vectorMutilCross(JH_Vector3 left_vec, JH_Vector3 right_vec);

#endif /* JH_MatrixOperate_h */
