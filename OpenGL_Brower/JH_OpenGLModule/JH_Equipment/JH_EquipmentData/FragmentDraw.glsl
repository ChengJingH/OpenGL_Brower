//uniform sampler2D colorMaps;  //一张图片绑定sampler2D

varying lowp vec4 varyPositionColor;       //顶点颜色

void main()
{
    //    gl_FragColor = texture2D(colorMaps,varyTextCoordinate);
    gl_FragColor = varyPositionColor;
}
