#version 300 es
precision mediump float;
in vec4 v_Color;
out vec4 o_Color;
void main(void) {
    o_Color = v_Color;
}
