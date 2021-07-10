#version 120
#extension GL_EXT_gpu_shader4 : enable
#include "/lib/psx_util.glsl"

#define gbuffers_solid
#define gbuffers_terrain
#include "/shaders.settings"

varying vec4 texcoord;
varying vec4 texcoordAffine;
varying vec4 lmcoord;
varying vec4 color;
varying vec4 normal;
varying vec3 tangent;
varying vec3 binormal;

attribute vec4 mc_Entity;
uniform vec2 texelSize;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform sampler2D lightmap;
uniform float far;

#define diagonal3(m) vec3((m)[0].x, (m)[1].y, m[2].z)
#define projMAD(m, v) (diagonal3(m) * (v) + (m)[3].xyz)
vec4 toClipSpace3(vec3 viewSpacePosition) {
    return vec4(projMAD(gl_ProjectionMatrix, viewSpacePosition),-viewSpacePosition.z);
}

void main() {
	texcoord = gl_MultiTexCoord0;
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
	vec4 ftrans = ftransform();
	float depth = clamp(ftrans.w, 0.001, 1000);
	float sqrtDepth = sqrt(depth);
	
	vec4 position4 = PixelSnap(ftrans, vertex_inaccuracy_terrain / sqrtDepth);
	vec3 position = position4.xyz;
	
	float wVal = (mat3(gl_ProjectionMatrix) * position).z;
	wVal = clamp(wVal, -10000.0, 0.0);
	texcoordAffine = vec4(texcoord.xy * wVal, wVal, 0);

	color = gl_Color;
	
	normal.a = 0.02;
	normal.xyz = normalize(gl_NormalMatrix * gl_Normal);
	
	gl_Position = position4;
	
	mat3 tbnMatrix = mat3(tangent.x, binormal.x, normal.x,
                          tangent.y, binormal.y, normal.y,
                          tangent.z, binormal.z, normal.z);
}
