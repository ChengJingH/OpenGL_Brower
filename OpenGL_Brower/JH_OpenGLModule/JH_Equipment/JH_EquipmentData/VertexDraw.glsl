attribute vec2 position;
uniform int positionColorFlag;

varying lowp vec4 varyPositionColor;      //顶点颜色

void main()
{
    //顶点颜色
    if (positionColorFlag == 0) {
        varyPositionColor = vec4(1.0, 0.0, 0.0, 1.0);
    } else if (positionColorFlag == 1) {
        varyPositionColor = vec4(0.0, 1.0, 0.0, 1.0);
    } else if (positionColorFlag == 2) {
        varyPositionColor = vec4(0.0, 0.0, 1.0, 1.0);
    }
    
    //顶点数据（OpenGL 主列矩阵）
    vec4 vec4position = vec4(position.x, position.y, 0.0, 1.0);
    
    gl_PointSize = 10.0;
    gl_Position = vec4position;
}
