#version 120
/* DRAWBUFFERS:0 */
#extension GL_EXT_gpu_shader4 : enable
#extension GL_ARB_shader_texture_lod : enable

varying vec4 texcoord;
varying vec4 texcoordAffine;
varying vec4 lmcoord;
varying vec4 color;
varying vec4 normalMat;

#include "/lib/psx_util.glsl"

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform float viewWidth;
uniform float viewHeight;

void main() {
	vec2 texelSize = vec2(1.0/viewWidth, 1.0/viewHeight);
	vec2 affine = AffineMapping(texcoordAffine, texcoord, texelSize, 2);

	vec4 col = texture2D(texture, texcoord.xy) * color * (texture2D(lightmap, lmcoord.st) * 0.8 + 0.2);
	
	gl_FragData[0] = col;
}
