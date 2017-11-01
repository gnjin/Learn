#version 300 es
layout(location = 0) in vec4 a_Color;
layout(location = 1) in vec4 a_Position;
out vec4 v_Color;
void main(void) {
    gl_Position = a_Position;
    v_Color = a_Color;
}
