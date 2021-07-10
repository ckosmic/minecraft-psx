#version 120
#extension GL_EXT_gpu_shader4 : enable
#include "/lib/psx_util.glsl"

#define gbuffers_solid
#define gbuffers_hand
#include "/shaders.settings"

varying vec4 texcoord;
varying vec4 lmcoord;
varying vec4 color;
varying vec4 normalMat;
varying vec4 lightLevels;

attribute vec4 mc_Entity;
uniform vec2 texelSize;

#define diagonal3(m) vec3((m)[0].x, (m)[1].y, m[2].z)
#define projMAD(m, v) (diagonal3(m) * (v) + (m)[3].xyz)
vec4 toClipSpace3(vec3 viewSpacePosition) {
    return vec4(projMAD(gl_ProjectionMatrix, viewSpacePosition),-viewSpacePosition.z);
}

void main() {
	texcoord.xy = (gl_MultiTexCoord0).xy;
	texcoord.zw = gl_MultiTexCoord1.xy/255.0;
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
	vec4 position4 = mat4(gl_ModelViewMatrix) * vec4(gl_Vertex) + gl_ModelViewMatrix[3].xyzw;
	vec3 position = PixelSnap(position4, vertex_inaccuracy_hand).xyz;

	color = gl_Color;
	
	gl_Position = toClipSpace3(position);
}
