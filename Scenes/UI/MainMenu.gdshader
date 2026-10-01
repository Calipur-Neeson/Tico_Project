shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightness : hint_range(0.5, 1.5) = 1.0;

void fragment() {
    vec3 screen_color = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
    COLOR = vec4(screen_color * brightness, 1.0);
}