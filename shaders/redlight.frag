// Pure red-light filter for Hyprland.
// Output is only red and black: no green, no blue.

#version 300 es
precision mediump float;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 pix = texture(tex, v_texcoord);
    float luma = dot(pix.rgb, vec3(0.299, 0.587, 0.114));
    luma = clamp(luma, 0.0, 1.0);
    fragColor = vec4(luma, 0.0, 0.0, pix.a);
}
