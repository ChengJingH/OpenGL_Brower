#  OpenGL 的三种变量类型（uniform、attributes、Textrue Data）

(如图 - OpenGL_CS.png)

1.uniform变量
    1)uniform变量是外部application程序传递给（vertex和fragment）shader的变量。因此它是application通过函数glUniform**（）函数赋值的。在（vertex和fragment）shader程序内部，uniform变量就像是C语言里面的常量（const ），它不能被shader程序修改。（shader只能用，不能改）
    2)如果uniform变量在vertex和fragment两者之间声明方式完全一样，则它可以在vertex和fragment共享使用。（相当于一个被vertex和fragment shader共享的全局变量）
    3)uniform是一种分配在硬件上的储存常量值的空间，储存空间是固定的。在程序中uniform的数量是受限的。这个限制能通过读gl_MaxVertexUniformVectors 和gl_MaxFragmentUniformVectors编译变量得出。（ 或者用GL_MAX_VERTEX_UNIFORM_VECTORS 或GL_MAX_FRAGMENT_UNIFORM_ VECTORS 为参数调用glGetIntegerv）OpenGL 必须至少提供256个顶点着色器uniform和224个片段着色器uniform。

uniform变量一般用来表示：变换矩阵，材质，光照参数和颜色等信息。
    以下是例子：
    uniform mat4 viewProjMatrix;    //投影+视图矩阵
    uniform mat4 viewMatrix;        //视图矩阵
    uniform vec3 lightPosition;     //光源位置


2.attribute变量
    1)attribute变量是只能在vertex shader中使用的变量。（它不能在fragment shader中声明attribute变量，也不能被fragment shader中使用）
    2)一般用attribute变量来表示一些顶点的数据，如：顶点坐标，法线，纹理坐标，顶点颜色等。
    3)在application中，一般用函数glBindAttribLocation（）来绑定每个attribute变量的位置，然后用函数glVertexAttribPointer（）为每个attribute变量赋值。


3.varying变量
    1)varying变量是vertex和fragment shader之间做数据传递用的。一般vertex shader修改varying变量的值，然后fragment shader使用该varying变量的值。因此varying变量在vertex和fragment shader二者之间的声明必须是一致的。application不能使用此变量。
    以下是例子：
    
    // Vertex shader
    varying lowp vec2 varyTextCoordinate;     //纹理坐标    
    void main()
    {
        //纹理坐标
        varyTextCoordinate = texturePosition;
    }

    // Fragment shader
    varying lowp vec2 varyTextCoordinate;     //纹理坐标
    
    void main()
    {
        gl_FragColor = texture2D(colorMaps,varyTextCoordinate);
    }

# 纹理

通过纹理坐标获取纹理颜色叫采样

纹理的四种环绕方式  (如图 OpenGL_Texture.png)
GL_REPEAT           重复纹理图像
GL_MIRRORED_REPEAT  和GL_REPEAT一样，每次图形是镜像放置的.
GL_CLAMP_TO_EDGE    纹理坐标会被约束在0-1之前，超出的部份会重复纹理坐标的边缘，产生一种边缘被拉伸的效果
GL_CLAMP_TO_BORDER  超出的坐标为用户指定的边缘颜色。



