#version 120
#extension GL_EXT_gpu_shader4 : enable

varying vec4 texcoord;
varying vec4 color;

uniform vec2 texelSize;

void main() {
	texcoord = gl_MultiTexCoord0;

	color = gl_Color;
	
	gl_Position = ftransform();
}
