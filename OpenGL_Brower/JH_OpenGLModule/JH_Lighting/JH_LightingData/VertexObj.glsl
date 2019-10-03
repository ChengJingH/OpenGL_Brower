attribute vec3 position;
attribute vec3 positionColor;
attribute vec3 positionNormal;   //顶点法线向量

uniform mat4 projectMatrix;      //透视矩阵
uniform mat4 modelViewMatrix;    //视图矩阵
uniform mat4 normalMatrix;       //法线矩阵

varying lowp vec3 varyPositionColor;
varying lowp vec3 varyNormal;            //顶点法向量
varying lowp vec3 worldPosition;         //世界坐标位置

void main()
{
    varyPositionColor = positionColor;
    
    //法线向量
    // 1.缩放和旋转变换，位移对法线向量无效
    // 2.等比缩放不会影响到法线向量，不等比缩放会让法线向量偏移
    vec4 normalVector = modelViewMatrix * vec4(positionNormal, 0.0);
    varyNormal = vec3(normalVector.x, normalVector.y, normalVector.z);

    //顶点坐标
    vec4 vertexP = vec4(position, 1.0);
    gl_Position = projectMatrix * modelViewMatrix * vertexP;
    
    //片段坐标
    vec4 tranferPosition = modelViewMatrix * vertexP;
    worldPosition = vec3(tranferPosition.x, tranferPosition.y, tranferPosition.z);
}
