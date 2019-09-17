varying lowp vec3 varyPositionColor;

void main()
{
    gl_FragColor = vec4(varyPositionColor, 1.0);
}
