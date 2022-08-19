#version 120
/* DRAWBUFFERS:01 */
#extension GL_EXT_gpu_shader4 : enable
#extension GL_ARB_shader_texture_lod : enable

#define gbuffers_solid
#include "/shaders.settings"

varying vec4 texcoord;
varying vec4 lmcoord;
varying vec4 color;
varying vec4 blockColor;
varying vec4 normalMat;

#include "/lib/psx_util.glsl"

uniform sampler2D texture;
uniform sampler2D lightmap;

void main() {
	vec3 normal = normalMat.xyz;

	vec4 data0 = texture2D(texture, texcoord.xy) * color * (texture2D(lightmap, lmcoord.st) * 0.8 + 0.2);
	
	gl_FragData[0] = data0;
}
