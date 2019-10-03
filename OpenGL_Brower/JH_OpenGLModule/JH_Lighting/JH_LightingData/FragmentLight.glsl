uniform lowp vec3 illuminantColor;

void main()
{
    gl_FragColor = vec4(illuminantColor, 1.0);
}
