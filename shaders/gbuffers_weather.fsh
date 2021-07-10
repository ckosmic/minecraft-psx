#version 120
/* DRAWBUFFERS:7 */

varying vec4 color;

varying vec2 texcoord;
varying float lmcoord;

uniform sampler2D texture;

void main() {

	vec4 tex = texture2D(texture, texcoord.xy)*color;

	gl_FragData[0] = vec4(vec3(1.0,lmcoord,1.0),tex.a*length(tex.rgb)/1.732);
}
