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

uniform int sphere_count;
uniform vec3 sphere_centers[32];
uniform float sphere_radii[32];
uniform vec3 sphere_colors[32];

uniform vec3 main_center;
uniform float main_radius;
uniform vec3 main_color;

struct Sphere{
    vec3 center;
    float radius;
    vec3 color;
};

struct Ray {
    vec3 origin;
    vec3 dir;
};

Sphere get_sphere(int x){
    Sphere s;
    s.center = sphere_centers[x];
    s.radius = sphere_radii[x];
    s.color = sphere_colors[x];
    return s;
}

bool hit_sphere(Sphere sphere, Ray ray){
    vec3 oc = sphere.center - ray.origin;
    float a = dot(ray.dir, ray.dir);
    float b = -2.0 * dot(ray.dir, oc);
    float c = (dot(oc,oc) - sphere.radius * sphere.radius);
    float discrimy = b*b - 4.0*a*c;
    return (discrimy >= 0.0);
}

vec3 ray_color(Ray ray, Sphere sphere){
    if(hit_sphere(sphere, ray))
        return sphere.color;
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
    Sphere sphere = get_sphere(0);

    ALBEDO = ray_color(ray, sphere);

}

