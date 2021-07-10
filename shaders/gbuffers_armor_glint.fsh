#version 120
/* DRAWBUFFERS:01 */
#extension GL_EXT_gpu_shader4 : enable
#extension GL_ARB_shader_texture_lod : enable

#define gbuffers_solid
#include "/shaders.settings"

uniform sampler2D texture;

varying vec4 color;
varying vec4 texcoord;
varying vec4 texcoordAffine;

uniform int worldTime;
uniform ivec2 eyeBrightnessSmooth;
uniform float rainStrength;
uniform vec2 texelSize;
uniform float frameTimeCounter;

float night = clamp((worldTime-13000.0)/300.0,0.0,1.0)-clamp((worldTime-22800.0)/200.0,0.0,1.0);
float cavelight = pow(eyeBrightnessSmooth.y / 255.0, 6.0f) * 1.0 + (0.7 + 0.5*night);

#include "/lib/psx_util.glsl"

void main() {
	#ifdef affine_mapping
	#ifdef affine_clamp_enabled
	vec2 affine = AffineMapping(texcoordAffine, texcoord, texelSize, affine_clamp);
	#else
	vec2 affine = texcoordAffine.xy / texcoordAffine.z;
	#endif
	#else 
	vec2 affine = texcoord.xy;
	#endif

	vec4 col = texture2D(texture, affine + vec2(frameTimeCounter/8.0)) * color;

	//Fix minecrafts way of handling enchanted effects and turn it into a somewhat consistent effect across day/night/cave/raining
	vec3 lighting = vec3(1.0+ (0.4*rainStrength - 0.4*rainStrength*night));
	lighting /= 0.8 - 0.5*night;
	lighting /= cavelight;

	col.rgb = pow(col.rgb*0.5, lighting);

	gl_FragData[0] = col;
}
