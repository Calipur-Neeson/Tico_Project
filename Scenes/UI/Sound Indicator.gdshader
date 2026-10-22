shader_type canvas_item;

uniform float proximity : hint_range(0.0, 1.0) = 0.0;
uniform float inner_radius : hint_range(0.1, 0.45) = 0.27;

void fragment() {
    vec2 from_center = UV - vec2(0.5);
    float radius = length(from_center);

    if (radius < inner_radius) {
        COLOR = texture(TEXTURE, UV);
    } else {
        float angle = atan(from_center.y, from_center.x);

        // घेराका फरक ठाउँका bars फरक समयमा चल्ने
        float wave = 0.5 + 0.5
            * sin(angle * 8.0 + TIME * 4.0)
            * sin(angle * 13.0 - TIME * 3.0);

        float growth = mix(
            0.35,
            1.0 + wave * 0.55,
            proximity
        );

        float source_radius =
            inner_radius + (radius - inner_radius) / growth;

        vec2 source_uv =
            vec2(0.5) + normalize(from_center) * source_radius;

        if (
            source_uv.x < 0.0 || source_uv.x > 1.0 ||
            source_uv.y < 0.0 || source_uv.y > 1.0
        ) {
            COLOR = vec4(0.0);
        } else {
            COLOR = texture(TEXTURE, source_uv);
        }
    }
}