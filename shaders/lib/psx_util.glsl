vec4 PixelSnap(vec4 pos, float inaccuracy) {
	inaccuracy += 0.1;
	vec2 screenParams = vec2(1080, 1080);
	vec2 hpc = screenParams * 0.75;
	vec4 pixelPos = pos;
	pixelPos.xy = pos.xy / pos.w;
	pixelPos.xy = floor(pixelPos.xy * hpc / inaccuracy) * inaccuracy / hpc;
	pixelPos.xy *= pos.w;
	return pixelPos;
}

vec2 AffineMapping(vec4 aUv, vec4 oUv, vec2 ts, float clampAmt) {
	vec2 bounds = ts * clampAmt;
	return vec2(clamp(aUv.x / aUv.z, oUv.x - bounds.x, oUv.x + ts.x + bounds.x), clamp(aUv.y / aUv.z, oUv.y - bounds.y, oUv.y + ts.y + bounds.y));
}