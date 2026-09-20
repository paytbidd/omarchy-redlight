// Fade in: color -> gray -> red. `time` starts at 0 when this shader is applied.
// Requires debug:damage_tracking = 0 while running.

#version 300 es
precision mediump float;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;
uniform float time;

const float FADE = 0.42;

float smoother(float t) {
    t = clamp(t, 0.0, 1.0);
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

void main() {
    vec4 pix = texture(tex, v_texcoord);
    float luma = dot(pix.rgb, vec3(0.299, 0.587, 0.114));
    luma = clamp(luma, 0.0, 1.0);

    float a = smoother(time / FADE);
    vec3 gray = vec3(luma);
    vec3 red = vec3(luma, 0.0, 0.0);
    vec3 drained = mix(pix.rgb, gray, min(1.0, a * 2.0));
    vec3 outc = mix(drained, red, max(0.0, a * 2.0 - 1.0));

    fragColor = vec4(outc, pix.a);
}
