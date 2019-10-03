attribute vec3 lightPosition;

uniform mat4 projectMatrix;      //透视矩阵
uniform mat4 modelViewMatrix;    //视图矩阵

void main()
{
    vec4 vertexP = vec4(lightPosition, 1.0);
    gl_Position = projectMatrix * modelViewMatrix * vertexP;
}
