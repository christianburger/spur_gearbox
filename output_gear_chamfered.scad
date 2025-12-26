include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = 100;

output_teeth = 32;
module_size = 1.156;
tooth_width = 8;
pressure_angle = 20;

output_pitch_radius = (module_size * output_teeth) / 2;
output_outer_radius = (module_size * (output_teeth + 2)) / 2;

output_bore = 5.0;
output_bore_tolerance = 0.6;

output_hub_diameter = 18;
output_hub_height = 10;

setscrew_diameter = 5.0;
setscrew_diameter_tolerance = 0.6;

chamfer_height = 2.0;
chamfer_angle = 45;

chamfer_cone_base_radius = output_outer_radius - chamfer_height * tan(chamfer_angle);
base_radius = output_outer_radius;


intersection() {
    translate([0, 0, tooth_width / 2]) {
        difference() {
            union() {
                spur_gear(
                    mod = module_size,
                    teeth = output_teeth,
                    thickness = tooth_width,
                    shaft_diam = output_bore + output_bore_tolerance,
                    pressure_angle = pressure_angle
                );
                
                translate([0, 0, tooth_width/2])
                    cylinder(d = output_hub_diameter, h = output_hub_height);
            }
            
            translate([0, 0, tooth_width/2 ])
                cylinder(d = output_bore + output_bore_tolerance, h = output_hub_height);
            
            translate([0, 0, tooth_width/2 + output_hub_height/2])
                rotate([90, 0, 0])
                    cylinder(d = setscrew_diameter - setscrew_diameter_tolerance, h = output_hub_diameter, center = true);
        }
    }
    
    union() {
        translate([0, 0, tooth_width]) {
            cylinder(r = chamfer_cone_base_radius, h = output_hub_height);
        }

        translate([0, 0, tooth_width - chamfer_height]) {
            cylinder(
                r1 = output_outer_radius,
                r2 = chamfer_cone_base_radius,
                h = chamfer_height
            );
        }
        
        translate([0, 0, chamfer_height]) {
            mirror([0, 0, 1]) {
                cylinder(
                    r1 = output_outer_radius,
                    r2 = chamfer_cone_base_radius,
                    h = chamfer_height
                );
            }
        }
        
        translate([0, 0, chamfer_height])
            cylinder(r = output_outer_radius, h = tooth_width - 2 * chamfer_height);
    }
}