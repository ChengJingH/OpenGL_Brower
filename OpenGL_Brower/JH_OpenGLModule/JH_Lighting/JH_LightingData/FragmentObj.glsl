// precision mediump float;     //默认精度修饰符
uniform lowp vec3 lightColor;        //光源颜色
uniform lowp vec3 lightPosition;     //光源位置
uniform lowp vec3 cameraPosition;    //摄像机位置

varying lowp vec3 worldPosition;     //世界坐标位置
varying lowp vec3 varyPositionColor; //物体颜色
varying lowp vec3 varyNormal;        //顶点法向量

//物体材质：坏境光、漫反射光、镜面光、反光度
struct Material {
    lowp vec3 ambientColor;
    lowp vec3 diffuseColor;
    lowp vec3 specularColor;
    lowp float shininess; //镜面高光的散射/半径。
};

uniform Material material;           //物体材质

struct Light {
    lowp vec3 lightPosition;//光源位置
    
    lowp vec3 ambientColor;
    lowp vec3 diffuseColor;
    lowp vec3 specularColor;
};

lowp vec3 normalizeVector(mediump vec3 vector)
{
    mediump float q = sqrt(pow(abs(vector.x),2.0) + pow(abs(vector.y), 2.0) + pow(abs(vector.z), 2.0));
    return vec3(vector.x/q, vector.y/q, vector.z/q);
}

lowp float dotCross(lowp vec3 l_vector, lowp vec3 r_vector)
{
    //后面平面光照不到（所以最大值取0.0）
    return max(l_vector.x * r_vector.x + l_vector.y * r_vector.y + l_vector.z * r_vector.z, 0.0);
}

void main()
{
    //坏境光照
    lowp float ambientStrength = 0.1;
    lowp vec3 ambient = ambientStrength * lightColor;
    lowp vec3 result = ambient;
    
    //漫反射光
    lowp vec3 diffuseLightVector = normalizeVector(lightPosition - worldPosition);
    lowp vec3 diffuseLight = lightColor * dotCross(diffuseLightVector, varyNormal);
    result = result + diffuseLight;
    
    //镜面光
    lowp float specularStrength = 0.5;//（镜面光强度）
    lowp vec3 observerVector = normalizeVector(cameraPosition - worldPosition);
    lowp vec3 specularLightVector = reflect(normalizeVector(worldPosition - lightPosition), varyNormal); //reflect函数求反射光（函数要求第一个向量是从光源指向片段位置的向量）
    mediump vec3 specularLight = lightColor * pow(dotCross(specularLightVector, observerVector),32.0) * specularStrength;
    result = (result + specularLight) * varyPositionColor;
    
    gl_FragColor = vec4(result, 1.0);
}

