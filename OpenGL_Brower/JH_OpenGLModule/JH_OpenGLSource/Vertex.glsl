attribute vec3 position;
attribute vec3 positionColor;
attribute vec2 texturePosition;

uniform lowp mat4 modelViewMatrix;       //模型变换矩阵
uniform lowp mat4 projectMatrix;         //平截体矩阵


varying lowp vec4 varyPositionColor;      //顶点颜色
varying lowp vec2 varyTextCoordinate;     //纹理坐标

void main()
{
    //纹理坐标
    varyTextCoordinate = texturePosition;
    
    //顶点颜色
    varyPositionColor = vec4(positionColor,1.0);
    
    //顶点数据（OpenGL 主列矩阵）
    vec4 vec4position = vec4(position,1.0);
    
    //世界坐标模型变换 -> 裁剪变换 -> 归一化（NDC）
    gl_Position = projectMatrix * modelViewMatrix * vec4position;
}
