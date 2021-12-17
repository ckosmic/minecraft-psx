#version 120
#extension GL_EXT_gpu_shader4 : enable

#define composite
#include "/shaders.settings"

#define DITHER_COLORS 128
varying vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D gaux4;
uniform vec2 texelSize;
uniform float viewWidth;
uniform float viewHeight;
uniform float aspectRatio;

vec3 GetDither(vec2 pos, vec3 c, float intensity) {
	int DITHER_THRESHOLDS[16] = int[]( -4, 0, -3, 1, 2, -2, 3, -1, -3, 1, -4, 0, 3, -1, 2, -2 );
	int index = (int(pos.x) & 3) * 4 + (int(pos.y) & 3);

	c.xyz = clamp(c.xyz * (DITHER_COLORS-1) + DITHER_THRESHOLDS[index] * (intensity * 100), vec3(0), vec3(DITHER_COLORS-1));

	c /= DITHER_COLORS;
	return c;
}

void main() {
	vec2 baseRes = vec2(viewWidth, viewHeight);
	vec2 dsRes = baseRes * resolution_scale;
	float pixelSize = dsRes.x / baseRes.x;
	vec2 downscale = floor(texcoord * (dsRes - 1) + 0.5) / (dsRes - 1);

    vec3 col = texture2D(colortex0,downscale).rgb;

	col = clamp(1.2 * (col - 0.5) + 0.5, 0, 1);
	col = GetDither(vec2(downscale.x, downscale.y / aspectRatio) * dsRes.x, col, dither_amount);
	col = clamp(floor(col * color_depth) / color_depth, 0.0, 1.0);
	
	gl_FragColor.rgb = col;
}
