shader_type spatial;
render_mode unshaded;

uniform vec3 albedo1 : source_color;
uniform vec3 albedo2 : source_color;
uniform sampler3D noise_tex;

void fragment() {
	vec4 noise = texture(noise_tex, vec3(UV, TIME * 0.05));
	ALBEDO = mix(albedo1, albedo2, noise.r);
}
