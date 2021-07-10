#version 120

varying vec4 color;
varying vec2 texcoord;

void main() {
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
	color = gl_Color;

	gl_Position = ftransform();
}
