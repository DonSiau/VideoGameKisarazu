shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);  // White flash color
uniform float flash_value : hint_range(0.0, 1.0, 0.1) = 0.0;  // Default to 0.0

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    COLOR = mix(texture_color, flash_color, flash_value);  // Mix with the flash color
    COLOR.a = texture_color.a;  // Preserve the original alpha
}
