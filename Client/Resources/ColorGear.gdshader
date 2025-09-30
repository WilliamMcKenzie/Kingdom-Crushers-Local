shader_type canvas_item;

uniform vec4 color : hint_color = vec4(0,0,0,1);
uniform float width : hint_range(0, 10) = 0.4;
uniform int pattern : hint_range(0, 2) = 2; // diamond, circle, square
uniform bool inside = false;
uniform bool add_margins = false; // only useful when inside is false

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

void vertex() {
	if (add_margins) {
		VERTEX += (UV * 2.0 - 1.0) * width;
	}
}

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset;
		
		if (pattern == 0) {
			offset = width - abs(x);
		} else if (pattern == 1) {
			offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
		} else if (pattern == 2) {
			offset = width;
		}
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a <= 0.0) == inside) {
				return true;
			}
		}
	}
	
	return false;
}

void fragment() {
	vec2 uv = UV;
	
	if (add_margins) {
		vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(width * 2.0));
		
		uv = (uv - texture_pixel_size * width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;
		
		if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
			COLOR.a = 0.0;
		} else {
			COLOR = texture(TEXTURE, uv);
		}
	} else {
		COLOR = texture(TEXTURE, uv);
	}
	
	if ((COLOR.a > 0.0) == inside && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		COLOR.rgb = inside ? mix(COLOR.rgb, color.rgb, color.a) : color.rgb;
		COLOR.a += (1.0 - COLOR.a) * color.a;
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