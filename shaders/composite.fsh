#version 120

// Skybox and rain shader code from Sildurs Vibrant Shaders

#define composite
#include "/shaders.settings"

varying vec2 texcoord;

varying vec3 lightColor;
varying vec3 sunVec;
varying vec3 upVec;
varying vec3 sky1;
varying vec3 sky2;

varying float tr;

varying vec2 lightPos;

varying vec3 sunlight;
varying vec3 nsunlight;

varying vec3 rawAvg;

varying float SdotU;
varying float sunVisibility;
varying float moonVisibility;

varying vec3 avgAmbient2;

uniform vec3 skyColor;
uniform mat4 gbufferProjectionInverse;
uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D gaux2;
uniform sampler2D gaux3;
uniform sampler2D gaux4;
uniform vec2 texelSize;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;
uniform float rainStrength;
uniform int worldTime;
uniform int isEyeInWater;
uniform float playerMood;

vec3 getSkyColor(vec3 fposition) {
	const vec3 moonlightS = vec3(0.00575, 0.0105, 0.014);
	vec3 sVector = normalize(fposition);

	float invRain07 = 1.0-rainStrength*0.4;
	float cosT = dot(sVector,upVec);
	float mCosT = max(cosT,0.0);
	float absCosT = 1.0-max(cosT*0.82+0.26,0.2);
	float cosY = dot(sunVec,sVector);
	float Y = acos(cosY);

	const float a = -1.0;
	const float b = -0.22;
	const float c = 3.0;
	const float d = -6.5;
	const float e = 0.3;

	//luminance
	float L =  (1.0+a*exp(b/(mCosT)));
	float A = 1.0+e*cosY*cosY;

	//gradient
	vec3 grad1 = mix(sky1,sky2,absCosT*absCosT);
	float sunscat = max(cosY,0.0);
	vec3 grad3 = mix(grad1,nsunlight*(1.0-isEyeInWater),sunscat*sunscat*(1.0-mCosT)*(0.9-rainStrength*0.5*0.9)*(clamp(-(SdotU)*4.0+3.0,0.0,1.0)*0.65+0.35)+0.1);

	float Y2 = 3.14159265359-Y;
	float L2 = L * (8.0*exp(d*Y2)+A);

	const vec3 moonlight2 = pow(normalize(moonlightS),vec3(3.0))*length(moonlightS);
	const vec3 moonlightRain = normalize(vec3(0.25,0.3,0.5))*length(moonlightS) + 0.45;

	vec3 gradN = mix(moonlightS,moonlight2,1.-L2/2.0) + 0.35;
	gradN = mix(gradN,moonlightRain,rainStrength);
	return pow(L*(c*exp(d*Y)+A),invRain07)*sunVisibility *length(rawAvg) * (0.85+rainStrength*0.425)*grad3+ 0.2*pow(L2*1.2+1.2,invRain07)*moonVisibility*gradN;
}

void main() {
	float depth = texture2D(depthtex0, texcoord).r;
	float depth1 = texture2D(depthtex1, texcoord).r;
	
	bool sky = depth >= 1.0;
	bool skyNoClouds = depth1 >= 1.0;
	
	#ifdef fog_enabled
	float fogDepth = depth * fog_distance - (fog_distance-1);
	fogDepth = clamp(fogDepth, 0.0, 1.0);
	#else
	float fogDepth = (sky) ? 1.0 : 0.0;
	#endif
	vec3 col = texture2D(colortex0, texcoord).rgb;
	
	vec4 fragpos = gbufferProjectionInverse * (vec4(texcoord, depth1, 1.0) * 2.0 - 1.0);
	fragpos /= fragpos.w;
	vec3 normalfragpos = normalize(fragpos.xyz);
	
	vec3 skyCol;
	if (texcoord.x < 1.0 && texcoord.y < 1.0 && texcoord.x > 0.0 && texcoord.y > 0.0 && fogDepth > 0.0) {
		skyCol = getSkyColor(fragpos.xyz);
	}
	
	vec4 sunmoon = texture2D(gaux2, texcoord);
	vec4 clouds = texture2D(gaux3, texcoord);
	
	sunmoon *= (1.0-rainStrength);
	
	vec3 fogColor = skyColor + skyCol;
	if(clouds.r > 0.0001) {
		clouds.rgb = mix(col*0.8, clouds.rgb, 0.75) + 0.1;
		float cloudsDepth = depth * 1000 - 999.2;
		cloudsDepth = clamp(cloudsDepth, 0.0, 1.0);
		col = mix(clouds.rgb, fogColor, cloudsDepth);
		col += sunmoon.rgb/2 * vec3(skyNoClouds?1.0:0.0);
	} else {
		col = mix(col, fogColor, fogDepth);
		col += sunmoon.rgb * vec3(sky?1.0:0.0);
	}
	
	vec4 rain = texture2D(gaux4, texcoord);
	if (rain.r > 0.0001 && rainStrength > 0.01 && !(depth1 < texture2D(depthtex2, texcoord).x)){
		float rainRGB = 0.25;
		float rainA = rain.r;

		float torch_lightmap = 12.0 - min(rain.g/rain.r * 12.0,11.0);
		torch_lightmap = 0.5 / torch_lightmap / torch_lightmap - 0.010595;

		const vec3 moonlight = vec3(0.0025, 0.0045, 0.007);
		vec3 rainC = rainRGB*(pow(max(dot(normalfragpos, sunVec)*0.1+0.9,0.0),6.0)*(0.1+tr*0.9)*pow(sunlight,vec3(0.25))*sunVisibility+pow(max(dot(normalfragpos, -sunVec)*0.05+0.95,0.0),6.0)*48.0*moonlight*moonVisibility)*0.04 + 0.05*rainRGB*length(avgAmbient2);
		rainC += torch_lightmap*vec3(1.0,1.0,0.5);
		col = ((1.0-rainA*0.3)+rainC*1.5*rainA)*0.3;
	}
	
	if(isEyeInWater > 0) {
		col *= vec3(0.5, 0.6902, 1.0);
	}

	gl_FragData[0] = vec4(col, 1.0);
}
