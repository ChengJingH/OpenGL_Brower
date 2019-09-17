attribute vec3 lightPosition;
attribute vec3 lightPositionColor;

uniform mat4 lightProjectMatrix;      //平截体矩阵
uniform mat4 lightModelViewMatrix;    //视图矩阵

varying lowp vec3 varyLightPositionColor;

void main()
{
    varyLightPositionColor = lightPositionColor;
    
    vec4 vertexP = vec4(lightPosition, 1.0);
    gl_Position = lightProjectMatrix * lightModelViewMatrix * vertexP;
}
