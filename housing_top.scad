include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = 100;

input_teeth = 8;
output_teeth = 32;
module_size = 1.156;
tooth_width = 8;

input_pitch_radius = (module_size * input_teeth) / 2;
output_pitch_radius = (module_size * output_teeth) / 2;
center_distance = input_pitch_radius + output_pitch_radius + 0.5;
input_outer_radius = (module_size * (input_teeth + 2)) / 2;
output_outer_radius = (module_size * (output_teeth + 2)) / 2;

bearing_inner_diameter = 5;
bearing_outer_diameter = 13;
bearing_thickness = 4;

nema17_hole_spacing = 31;

wall_thickness = 2;
floor_thickness = 2;
bearing_pocket_depth = bearing_thickness + 0.5;
box_height = tooth_width / 2 + bearing_pocket_depth + 5;
clearance = 12;

bearing_pocket_tolerance = 0.3;
boss_diameter = bearing_outer_diameter + bearing_pocket_tolerance + 8;

min_length_for_gear = (input_outer_radius * 2) + (wall_thickness * 2) + (clearance * 2);
min_length_for_nema17 = nema17_hole_spacing + (wall_thickness * 2) + 10;
housing_length = max(min_length_for_gear, min_length_for_nema17);

housing_width = 68;

input_x = housing_length / 2;
input_y = wall_thickness + input_outer_radius + clearance;

output_x = input_x;
output_y = input_y + center_distance;

difference() {
    union() {
        cube([housing_length, housing_width, box_height]);
    }
    
    translate([wall_thickness, wall_thickness, floor_thickness])
    cube([housing_length - (wall_thickness * 2), housing_width - (wall_thickness * 2),  
              box_height]);

    translate([output_x, output_y, -0.1])
    cylinder(d = bearing_outer_diameter + 0.3, h = bearing_pocket_depth + 0.1);
    
    translate([output_x, output_y, -0.1])
    cylinder(d = bearing_inner_diameter + 0.3, h = box_height + 0.2);

}

translate([output_x, output_y, 0])
    difference() {
        cylinder(d = boss_diameter, h = bearing_pocket_depth);
        cylinder(d = bearing_outer_diameter + bearing_pocket_tolerance, h = bearing_pocket_depth + 0.2);
    }
     