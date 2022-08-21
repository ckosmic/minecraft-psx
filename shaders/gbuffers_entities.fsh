#version 120
/* DRAWBUFFERS:01 */
#extension GL_EXT_gpu_shader4 : enable
#extension GL_ARB_shader_texture_lod : enable

#define gbuffers_solid
#include "/shaders.settings"

varying vec4 texcoord;
varying vec4 texcoordAffine;
varying vec4 lmcoord;
varying vec4 color;
varying vec4 normalMat;

uniform float viewWidth;
uniform float viewHeight;
uniform sampler2D texture;
uniform sampler2D lightmap;
uniform vec4 entityColor;
uniform vec3 skyColor;

#include "/lib/psx_util.glsl"


void main() {
	#ifdef affine_mapping
	#ifdef affine_clamp_enabled
	vec2 texelSize = vec2(1.0/viewWidth, 1.0/viewHeight);
	vec2 affine = AffineMapping(texcoordAffine, texcoord, texelSize, affine_clamp * 4.0);
	#else
	vec2 affine = texcoordAffine.xy / texcoordAffine.z;
	#endif
	#else 
	vec2 affine = texcoord.xy;
	#endif

	vec4 col = texture2D(texture, affine) * color * texture2D(lightmap, lmcoord.st);
	col.rgb = mix(col.rgb, entityColor.rgb, entityColor.a);
	
	gl_FragData[0] = col;


}
