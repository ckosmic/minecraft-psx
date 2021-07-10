#version 120
/* DRAWBUFFERS:5 */

varying vec4 color;
varying vec2 texcoord;

uniform sampler2D texture;

void main() {
	gl_FragData[0] = texture2D(texture,texcoord.xy) * color;
}
