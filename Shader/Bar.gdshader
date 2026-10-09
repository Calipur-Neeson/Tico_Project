shader_type spatial;

uniform float percent = 3.3;

void fragment() {
    if (UV.x > percent) 
	{
        discard;
    }
	
	vec3 orange = vec3(1.0, 0.35, 0.0);
    vec3 blue   = vec3(0.0, 0.4, 1.0);
	
	vec3 color = mix(blue, orange, percent);
	ALBEDO = color;
}
