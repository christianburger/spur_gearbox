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
nema17_body_size = 42.3;  // NEMA17 standard body size

// HOUSING PARAMETERS
wall_thickness = 2;
floor_thickness = 2;  // Bottom floor thickness where bearings sit
bearing_pocket_depth = bearing_thickness + 0.5;
box_height = tooth_width / 2 + bearing_pocket_depth + 5;
clearance = 12;

// Add these variables in the HOUSING PARAMETERS section:
bearing_pocket_tolerance = 0.3;
boss_diameter = bearing_outer_diameter + bearing_pocket_tolerance + 10;

// HOUSING DIMENSIONS
housing_width = nema17_body_size;  // 42.3mm to match NEMA17
housing_length = 68;

// AXLE POSITIONS
// Input gear centered in X, positioned in Y
input_x = housing_width / 2;
input_y = 5.65 + nema17_hole_spacing / 2;  // Position to match NEMA17 mounting holes

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



// Variable definitions (add these in the HOUSING PARAMETERS section)
bearing_retainer_height = 1;  // Height of retaining ring
bearing_retainer_id = 6.0;  // Inner diameter for shaft clearance

// REMOVE THIS
z_displacement = 100;

// HOUSING HALF
difference() {
    union() {
        // Main box body
        cube([housing_width, housing_length, box_height]);
        
        // INPUT AXLE - Bearing boss (donut)
        translate([input_x, input_y, 0])
            difference() {
                cylinder(d = bearing_outer_diameter + 4, h = bearing_pocket_depth);
                cylinder(d = bearing_inner_diameter + 0.3, h = bearing_pocket_depth + 0.2);
            }
        
        // OUTPUT AXLE - Bearing boss (donut)
        translate([output_x, output_y, 0])
            difference() {
                cylinder(d = bearing_outer_diameter + 4, h = bearing_pocket_depth);
                cylinder(d = bearing_inner_diameter + 0.3, h = bearing_pocket_depth + 0.2);
            }
    
    }
    
    nema17_hole_spacing = 31;
    nema17_mount_hole = 3.2;
    nema17_boss_diameter = 22.5;
    nema17_boss_depth = 2.5;
    
    translate([input_x, input_y, -0.1])
    cylinder(d = nema17_boss_diameter, h = nema17_boss_depth + 0.1);
  
 
 
    // Interior cavity for gears
    translate([wall_thickness, wall_thickness, floor_thickness])
    cube([housing_width - (wall_thickness * 2), housing_length - (wall_thickness * 2),  
              box_height]);
    
    // INPUT AXLE - Bearing pocket
    translate([input_x, input_y, -0.1])
    cylinder(d = bearing_outer_diameter + bearing_pocket_tolerance, h = bearing_pocket_depth + 0.1);
    
    // INPUT AXLE - Shaft clearance
    translate([input_x, input_y, -0.1])
    cylinder(d = bearing_inner_diameter + 0.3, h = box_height + 0.2);
    
    // OUTPUT AXLE - Bearing pocket
    translate([output_x, output_y, -0.1])
    cylinder(d = bearing_outer_diameter + 0.3, h = bearing_pocket_depth + 0.1);
    
    // OUTPUT AXLE - Shaft clearance
    translate([output_x, output_y, -0.1])
    cylinder(d = bearing_inner_diameter + 0.3, h = box_height + 0.2);
    
    // NEMA17 MOTOR MOUNTING HOLES (hexagonal for hex nuts)
    translate([nema17_hole1_x, nema17_hole1_y, 0])
        cylinder(d = nema17_mount_hole, h = box_height);
    
    translate([nema17_hole2_x, nema17_hole2_y, 0])
        cylinder(d = nema17_mount_hole, h = box_height);
    
    translate([nema17_hole3_x, nema17_hole3_y, 0])
        cylinder(d = nema17_mount_hole, h = box_height);
    
    translate([nema17_hole4_x, nema17_hole4_y, 0])
        cylinder(d = nema17_mount_hole, h = box_height);
}

// OUTPUT AXLE - Bearing boss (donut)
translate([output_x, output_y, 0])
    difference() {
        cylinder(d = boss_diameter, h = bearing_pocket_depth);
        cylinder(d = bearing_outer_diameter + bearing_pocket_tolerance, h = bearing_pocket_depth + 0.2);
    }
    

// OUTPUT AXLE - Bearing retainer ring (bottom housing)
translate([output_x, output_y, bearing_pocket_depth])
    difference() {
       cylinder(d = boss_diameter, h = bearing_retainer_height);
        cylinder(d = bearing_retainer_id, h = bearing_retainer_height + 0.2);
    }

    
    
