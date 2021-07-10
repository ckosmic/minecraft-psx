#version 120

varying vec4 color;
varying vec2 texcoord;
varying float lmcoord;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;

void main() {

	vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
	gl_Position = gl_ProjectionMatrix * gbufferModelView * position;
	
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).s;
	color = gl_Color;

}
