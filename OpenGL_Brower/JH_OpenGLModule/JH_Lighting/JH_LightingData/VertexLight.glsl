attribute vec3 position;
attribute vec3 positionColor;

attribute vec3 positionNormal;   //顶点法线向量

uniform mat4 projectMatrix;      //平截体矩阵
uniform mat4 modelViewMatrix;    //视图矩阵

varying lowp vec3 varyPositionColor;

void main()
{
    varyPositionColor = positionColor;
    
    vec4 vertexP = vec4(position, 1.0);
    gl_Position = projectMatrix * modelViewMatrix * vertexP;
}
