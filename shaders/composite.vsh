#version 120

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

uniform vec3 sunPosition;
uniform vec3 upPosition;
uniform int worldTime;
uniform float rainStrength;
uniform mat4 gbufferProjection;

const vec3 ToD[7] = vec3[7](  vec3(0.58597,0.16,0.005),
								vec3(0.58597,0.31,0.08),
								vec3(0.58597,0.45,0.16),
								vec3(0.58597,0.5,0.35),
								vec3(0.58597,0.5,0.36),
								vec3(0.58597,0.5,0.37),
								vec3(0.58597,0.5,0.38));

void main() {
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0.xy;
	
	
	sunVec = normalize(sunPosition);
	upVec = normalize(upPosition);
	
	SdotU = dot(sunVec,upVec);
	sunVisibility = pow(clamp(SdotU+0.15,0.0,0.15)/0.15,4.0);
	moonVisibility = pow(clamp(-SdotU+0.15,0.0,0.15)/0.15,4.0);
	
	float hour = max(mod(worldTime/1000.0+2.0,24.0)-2.0,0.0);  //-0.1
	float cmpH = max(-abs(floor(hour)-6.0)+6.0,0.0); //12
	float cmpH1 = max(-abs(floor(hour)-5.0)+6.0,0.0); //1

	vec3 temp = ToD[int(cmpH)];
	vec3 temp2 = ToD[int(cmpH1)];

	sunlight = mix(temp,temp2,fract(hour));

	vec2 trCalc = min(abs(worldTime-vec2(23000.0,12700.0)),750.0);
	tr = max(min(trCalc.x,trCalc.y)/375.0-1.0,0.0);	
	/*--------------------------------*/
	float tr2 = clamp(min(min(distance(float(worldTime),23000.0),750.0),min(distance(float(worldTime),12700.0),800.0))/800.0-0.5,0.0,1.0)*2.0;

	vec4 bounced = vec4(0.5,0.66,1.3,0.27);
	vec3 sun_ambient = bounced.w * (vec3(0.25,0.62,1.32)-rainStrength*vec3(0.1,0.47,1.17))*(1.0+rainStrength*7.0) + sunlight*(bounced.x + bounced.z)*(1.0-rainStrength*0.95);

	const vec3 moonlight = vec3(0.0016, 0.00288, 0.00448);
	rawAvg = (sun_ambient*sunVisibility + 8.0*moonlight*moonVisibility)*(0.05+tr2*0.15)*4.7+0.0002;

	float truepos = sign(sunPosition.z)*1.0;		//1 -> sun / -1 -> moon
	lightColor = mix(vec3(0)*sunVisibility+0.00001,12.*moonlight*moonVisibility+0.00001,(truepos+1.0)/2.);
	if (length(lightColor)>0.001)lightColor = mix(lightColor,normalize(vec3(0.3,0.3,0.3))*pow(normalize(lightColor),vec3(0.4))*length(lightColor)*0.03,rainStrength)*(0.25+0.25*tr2);

	float mcosS = max(SdotU,0.0);
	vec3 sunlight04 = pow(sunlight,vec3(0.454));
	
	float skyMult = max(SdotU*0.1+0.1,0.0)/0.2*(1.0-rainStrength*0.6)*0.7;
	nsunlight = normalize(pow(mix(sunlight04,5.*sunlight04*sunVisibility*(1.0-rainStrength*0.95)+vec3(0.3,0.3,0.35),rainStrength),vec3(2.2)))*0.6*skyMult;

	vec3 sky_color = vec3(0.05, 0.32, 1.);
	sky_color = normalize(mix(sky_color,2.*sunlight04*sunVisibility*(1.0-rainStrength*0.95)+vec3(0.3,0.3,0.3)*length(sunlight04),rainStrength)); //normalize colors in order to don't change luminance

	sky1 = sky_color*0.6*skyMult;
	sky2 = mix(sky_color,mix(nsunlight,sky_color,rainStrength*0.9),1.0-max(mcosS-0.2,0.0)*0.5)*0.6*skyMult;
	
	avgAmbient2 = (sun_ambient*sunVisibility + 6.0*1.0*moonVisibility)*1.0 *(0.27+tr*0.65)+0.0002;
	avgAmbient2 /= sqrt(3.0);
}