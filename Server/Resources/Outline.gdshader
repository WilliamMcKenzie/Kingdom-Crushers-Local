shader_type canvas_item;

uniform float max_line_width = -1.0;
uniform float min_line_width = -1.0;
uniform float freq = 0.0;
uniform float block_size = 12.0;
uniform vec4 starting_colour = vec4(0,0,0,1);
uniform vec4 ending_colour = vec4(0,0,0,0);

uniform sampler2D helmetTexture;
uniform sampler2D bodyTexture;
uniform sampler2D weaponTexture;

uniform bool helmetTextureActive = false;
uniform bool bodyTextureActive = false;
uniform bool weaponTextureActive = false;

uniform vec4 helmetDarkOrigin:hint_color = vec4(33, 53, 23, 0.2);
uniform vec4 helmetDarkNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 helmetMediumOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 helmetMediumNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 helmetLightOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 helmetLightNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bodyDarkOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bodyDarkNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bodyMediumOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bodyMediumNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bodyLightOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bodyLightNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bandOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bandNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 buckleOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 buckleNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 weaponOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 weaponNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 weaponSecondaryOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 weaponSecondaryNew:hint_color= vec4(33, 53, 23, 0.2);

const float pi = 3.1415;
const int ang_res = 16;
const int grad_res = 8;

float hash(vec2 p, float s) {
	return fract(35.1 * sin(dot(vec3(112.3, 459.2, 753.2), vec3(p, s))));
}

float noise(vec2 p, float s) {
	vec2 d = vec2(0, 1);
	vec2 b = floor(p);
	vec2 f = fract(p);
	return mix(
		mix(hash(b + d.xx, s), hash(b + d.yx, s), f.x),
		mix(hash(b + d.xy, s), hash(b + d.yy, s), f.x), f.y);
}

float getLineWidth(vec2 p, float s) {
	p /= block_size;
	float w = 0.0;
	float intensity = 1.0;
	for (int i = 0; i < 3; i++) {
		w = mix(w, noise(p, s), intensity);
		p /= 2.0;
		intensity /= 2.0;
	}
	
	return mix(max_line_width, min_line_width, w);
}

bool pixelInRange(sampler2D text, vec2 uv, vec2 dist) {
	float alpha = 0.0;
	for (int i = 0; i < ang_res; i++) {
		float angle = 2.0 * pi * float(i) / float(ang_res);
		vec2 disp = dist * vec2(cos(angle), sin(angle));
		if (texture(text, uv + disp).a > 0.0) return true;
	}
	return false;
}

float getClosestDistance(sampler2D text, vec2 uv, vec2 maxDist) {
	if (!pixelInRange(text, uv, maxDist)) return -1.0;
	
	float hi = 1.0; float lo = 0.0;
	
	for (int i = 1; i <= grad_res; i++) {
		float curr = (hi + lo) / 2.0;
		if (pixelInRange(text, uv, curr * maxDist)) {
			hi = curr;
		}
		else {
			lo = curr;
		}
	}
	return hi;
	
}

void fragment() {
	float timeStep = floor(freq * TIME);
	vec2 scaledDist = TEXTURE_PIXEL_SIZE;
	scaledDist *= getLineWidth(UV / TEXTURE_PIXEL_SIZE, timeStep);
	float w = getClosestDistance(TEXTURE, UV, scaledDist);
	
	if (( w > 0.0) && (texture(TEXTURE, UV).a < 0.2)) {
		COLOR = mix(starting_colour, ending_colour, tanh(3.0*w));
	}
	else {
		COLOR = texture(TEXTURE, UV);
	}
	
	vec4 current_pixel = texture(TEXTURE, UV);
	vec2 scaled_uv = fract(UV * 150.0);

	if(helmetTextureActive == true && (current_pixel == helmetDarkOrigin || current_pixel == helmetLightOrigin || current_pixel == helmetMediumOrigin))
		COLOR = texture(helmetTexture, scaled_uv);
	else {
		if(current_pixel == helmetDarkOrigin)
			COLOR = helmetDarkNew;
		if(current_pixel == helmetLightOrigin)
			COLOR = helmetLightNew;
		if(current_pixel == helmetMediumOrigin)
			COLOR = helmetMediumNew;
	}
	
	if(bodyTextureActive == true && (current_pixel == bodyDarkOrigin || current_pixel == bodyLightOrigin || current_pixel == bodyMediumOrigin))
		COLOR = texture(bodyTexture, scaled_uv);
	else {
		if(current_pixel == bodyLightOrigin)
			COLOR = bodyLightNew;

		if(current_pixel == bodyMediumOrigin)
			COLOR = bodyMediumNew;
		
		if(current_pixel == bodyDarkOrigin)
			COLOR = bodyDarkNew;
	}

	if(current_pixel == bandOrigin)
		COLOR = bandNew;

	if(current_pixel == buckleOrigin)
		COLOR = buckleNew;

	if(weaponTextureActive == true && (current_pixel == weaponOrigin))
		COLOR = texture(weaponTexture, scaled_uv);
	else if(current_pixel == weaponOrigin)
			COLOR = weaponNew;
	if(current_pixel == weaponSecondaryOrigin)
			COLOR = weaponSecondaryNew;
}