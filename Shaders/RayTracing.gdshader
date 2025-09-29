shader_type spatial;
render_mode unshaded;

uniform vec3 cam_origin;
uniform vec2 screen_size;
uniform float aspect_ratio;
uniform float viewport_width;
uniform float viewport_height;
uniform vec3 pixel_delta_u;
uniform vec3 pixel_delta_v;
uniform vec3 viewport_upper_left;
uniform vec3 pixel00_loc;

struct Ray {
    vec3 origin;
    vec3 dir;
};

vec3 ray_color(Ray ray){
    vec3 unit_dir = normalize(ray.dir);
    float a = (unit_dir.y + 1.0) * 0.5;
    return mix(vec3(1.0,1.0,1.0), vec3(0.5,0.7,1.0), a);
}

void fragment() {
    vec2 pixel_coords = SCREEN_UV * screen_size;
    vec2 pixel_index = floor(pixel_coords);

    vec3 pixel_center = pixel00_loc + (pixel_index.x * pixel_delta_u) + (pixel_index.y * pixel_delta_v);

    vec3 ray_direction = pixel_center - cam_origin;

    Ray ray;
    ray.origin = cam_origin;
    ray.dir = ray_direction;

    ALBEDO = ray_color(ray);

}

