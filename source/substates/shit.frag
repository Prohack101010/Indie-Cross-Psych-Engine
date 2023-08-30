// Fork of "Side transition" by maksasj. https://shadertoy.com/view/DlVGzR
// 2023-07-11 05:59:42


const float subBlockSize = 0.08;

//#define CIRCLE_BLOCK 1.0


vec4 transitionCircle(vec2 uv, vec4 color, float progression) {
    float r = iResolution.x/iResolution.y;
    vec2 suv = uv / subBlockSize;
    suv.x *= r;
    
    vec2 oDistance = abs(fract(suv) - 0.5);
    if (dot(oDistance, oDistance) + length(uv) < progression*2.0) {
        color = vec4(0.0, 0.0, 0.0, 1.0);
    }
    
    return color;
}

vec4 transitionDiamond(vec2 uv, vec4 color, float progression) {
    float r = iResolution.x/iResolution.y;
    vec2 suv = uv / (subBlockSize*2.0);
    suv.x *= r;

    vec2 oDistance = abs(fract(suv) - 0.5);
    if (oDistance.x + oDistance.y + length(uv) < progression*2.5) {
        color = vec4(0.0, 0.0, 0.0, 1.0);
    }

    return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = 2.0*fragCoord.xy / iResolution.xy - 1.0;
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

    float progression = (sin(iTime) + 1.0) / 2.0;
    #ifdef CIRCLE_BLOCK
        color = transitionCircle(uv, color, progression);
    #else
        color = transitionDiamond(uv, color, progression);
    #endif
    color = fragColor;
   // fragColor = color;
}