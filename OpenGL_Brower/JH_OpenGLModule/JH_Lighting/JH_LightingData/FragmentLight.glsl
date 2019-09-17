uniform lowp vec3 lightColor;        //光源颜色

varying lowp vec3 varyLightPositionColor;

void main()
{
    gl_FragColor = vec4(varyLightPositionColor, 1.0);
}
