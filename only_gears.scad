// Gearbox Housing Half for 4:1 Linear Gearbox
// Using BOSL2 library
// Print this TWICE to get both halves (they are identical)
// 
include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = 100;

// GEAR PARAMETERS
input_teeth = 8;
output_teeth = 32;
module_size = 1.156;
tooth_width = 8;
pressure_angle = 20;

// CALCULATED GEAR DIMENSIONS
input_pitch_radius = (module_size * input_teeth) / 2;
output_pitch_radius = (module_size * output_teeth) / 2;
center_distance = input_pitch_radius + output_pitch_radius + 0.5;
input_outer_radius = (module_size * (input_teeth + 2)) / 2;
output_outer_radius = (module_size * (output_teeth + 2)) / 2;

// BEARING PARAMETERS (695ZZ: 5mm ID, 13mm OD, 4mm thickness)
bearing_inner_diameter = 5;
bearing_outer_diameter = 13;
bearing_thickness = 4;

// SHAFT/HUB PARAMETERS
input_bore = 5.0;
output_bore = 5.0;
input_hub_diameter = 12;
output_hub_diameter = 16;
input_hub_height = 8;
output_hub_height = 8;
setscrew_diameter = 3.0;

// NEMA17 PARAMETERS
nema17_hole_spacing = 31;
nema17_mount_hole = 3.2;

// HOUSING PARAMETERS
wall_thickness = 2;
floor_thickness = 2;  // Bottom floor thickness where bearings sit
bearing_pocket_depth = bearing_thickness + 0.5;
box_height = tooth_width / 2 + bearing_pocket_depth + 5;
clearance = 12;

// Add these variables in the HOUSING PARAMETERS section:
bearing_pocket_tolerance = 0.3;
boss_diameter = bearing_outer_diameter + bearing_pocket_tolerance + 10;


// CALCULATE HOUSING DIMENSIONS
// Length: input gear width + walls + clearance + NEMA17 considerations
min_length_for_gear = (input_outer_radius * 2) + (wall_thickness * 2) + (clearance * 2);
min_length_for_nema17 = nema17_hole_spacing + (wall_thickness * 2) + 10;
housing_length = max(min_length_for_gear, min_length_for_nema17);

// Width: Fixed to 68mm (Y direction)
housing_width = 68;

// AXLE POSITIONS
// Input gear centered in X, positioned in Y
input_x = housing_length / 2;
input_y = wall_thickness + input_outer_radius + clearance;

// Output gear same X, extended in Y direction
output_x = input_x;
output_y = input_y + center_distance;

// NEMA17 HOLE POSITIONS (31mm square pattern centered on input axle)
nema17_hole1_x = input_x - nema17_hole_spacing / 2;
nema17_hole1_y = input_y - nema17_hole_spacing / 2;
nema17_hole2_x = input_x + nema17_hole_spacing / 2;
nema17_hole2_y = input_y - nema17_hole_spacing / 2;
nema17_hole3_x = input_x - nema17_hole_spacing / 2;
nema17_hole3_y = input_y + nema17_hole_spacing / 2;
nema17_hole4_x = input_x + nema17_hole_spacing / 2;
nema17_hole4_y = input_y + nema17_hole_spacing / 2;



// INPUT GEAR (12 teeth)
//translate([input_x, input_y, box_height + 4]) {
translate([output_x, output_y, box_height + 20]) {
    rotate([0, 0, 180/8]) {
        difference() {
            union() {
                spur_gear(
                    mod = module_size,
                    teeth = input_teeth,
                    thickness = tooth_width,
                    shaft_diam = input_bore,
                    pressure_angle = pressure_angle
                );
                
                translate([0, 0, tooth_width/2])
                    cylinder(d = input_hub_diameter, h = input_hub_height);
            }
            
            translate([0, 0, tooth_width/2 - 0.1])
                cylinder(d = input_bore, h = input_hub_height + 0.2);
            
            translate([0, 0, tooth_width/2 + input_hub_height/2])
                rotate([90, 0, 0])
                    cylinder(d = setscrew_diameter, h = input_hub_diameter + 1, center = true);
        }
    }
}

// OUTPUT GEAR (32 teeth)
translate([output_x, output_y, box_height + 2]) {
    difference() {
        union() {
            spur_gear(
                mod = module_size,
                teeth = output_teeth,
                thickness = tooth_width,
                shaft_diam = output_bore,
                pressure_angle = pressure_angle
            );
            
            translate([0, 0, tooth_width/2])
                cylinder(d = output_hub_diameter, h = output_hub_height);
        }
        
        translate([0, 0, tooth_width/2 - 0.1])
            cylinder(d = output_bore, h = output_hub_height + 0.2);
        
        translate([0, 0, tooth_width/2 + output_hub_height/2])
            rotate([90, 0, 0])
                cylinder(d = setscrew_diameter, h = output_hub_diameter + 1, center = true);
    }
}
    