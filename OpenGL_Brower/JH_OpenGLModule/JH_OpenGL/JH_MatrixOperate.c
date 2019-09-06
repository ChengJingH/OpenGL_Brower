//
//  JH_MatrixOperate.c
//  OpenGL_Brower
//
//  Created by walen on 2019/9/4.
//  Copyright © 2019 CJH. All rights reserved.
//

#include "JH_MatrixOperate.h"

//平移
JH_Matrix matrixTransfer(JH_Matrix m)
{
    return m;
}


//叉乘
JH_Vector3 vectorMutilCross(JH_Vector3 left_vec, JH_Vector3 right_vec)
{
    JH_Vector3 c_vector;
    c_vector.x = left_vec.y * right_vec.z - right_vec.y * left_vec.z;
    c_vector.y = left_vec.z * right_vec.x - right_vec.z * left_vec.x;
    c_vector.z = left_vec.x * right_vec.y - right_vec.x * left_vec.y;
    return c_vector;
}
