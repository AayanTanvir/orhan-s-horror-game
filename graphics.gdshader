shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float color_aberration : hint_range(0.0, 0.01) = 0.002;
uniform vec4 tint_color : source_color = vec4(1.0, 0.96, 0.85, 1.0); // Warm yellow/vhs tint
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Smooth Chromatic Aberration (Color Bleed without pixelation)
    float r = texture(SCREEN_TEXTURE, uv + vec2(color_aberration, 0.0)).r;
    float g = texture(SCREEN_TEXTURE, uv).g;
    float b = texture(SCREEN_TEXTURE, uv - vec2(color_aberration, 0.0)).b;
    vec3 col = vec3(r, g, b);
    
    // Apply warm atmospheric tint
    col *= tint_color.rgb;
    
    // Smooth Vignette (darkened edges)
    vec2 center = uv - vec2(0.5);
    float dist = length(center);
    col *= smoothstep(0.8, 0.2, dist * vignette_intensity);
    
    COLOR = vec4(col, 1.0);
}