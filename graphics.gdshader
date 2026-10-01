shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_nearest;

uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 4.0;
uniform float color_levels : hint_range(4.0, 64.0, 1.0) = 32.0;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.6;
uniform float saturation : hint_range(0.0, 1.5) = 0.9;
uniform float contrast : hint_range(0.5, 1.5) = 1.05;
uniform vec3 tint : source_color = vec3(1.0, 1.0, 1.0);
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.35;

const float BAYER[16] = float[16](
	0.0, 8.0, 2.0, 10.0,
	12.0, 4.0, 14.0, 6.0,
	3.0, 11.0, 1.0, 9.0,
	15.0, 7.0, 13.0, 5.0
);

void fragment() {
	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;

	// Pixelate: snap to big pixel cells, one texture fetch per pixel
	vec2 cell = floor(SCREEN_UV * res / pixel_size);
	vec2 uv = (cell + 0.5) * pixel_size / res;
	vec3 col = texture(screen_tex, uv).rgb;

	// Color grading
	float l = dot(col, vec3(0.299, 0.587, 0.114));
	col = mix(vec3(l), col, saturation);
	col = (col - 0.5) * contrast + 0.5;
	col *= tint;

	// Vignette
	float d = distance(SCREEN_UV, vec2(0.5));
	col *= 1.0 - smoothstep(0.35, 0.95, d) * vignette_strength;

	// Bayer dither + PS1-style color reduction
	int idx = int(mod(cell.x, 4.0)) + int(mod(cell.y, 4.0)) * 4;
	float dth = (BAYER[idx] / 16.0 - 0.5) * dither_strength / color_levels;
	col = floor((col + dth) * color_levels + 0.5) / color_levels;

	COLOR = vec4(clamp(col, 0.0, 1.0), 1.0);
}