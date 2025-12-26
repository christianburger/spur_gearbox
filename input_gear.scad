include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = 100;

// Gear parameters
input_teeth = 8;
module_size = 1.156;
tooth_width = 8;
pressure_angle = 20;

// Hub & bore
input_bore_nominal = 5.0;          // nominal shaft size
shaft_clearance = 0.2;             // explicit clearance for shaft bore
input_bore = input_bore_nominal + shaft_clearance;

d_flat_height = 4.0;               // across the flat of the D-shaft
input_hub_diameter = 12;
input_hub_height = 10;

// Setscrew (M5 grub screw)
setscrew_diameter = 5.0;           // nominal grub screw diameter
setscrew_clearance = 0.6;          // undersize allowance for PETG shrinkage
// Effective hole size = setscrew_diameter - setscrew_clearance

// Chamfer
chamfer_height = 2.0;
chamfer_angle = 45;
input_outer_radius = (module_size * (input_teeth + 2)) / 2;
chamfer_cone_base_radius = input_outer_radius - chamfer_height * tan(chamfer_angle);
base_radius = input_outer_radius + 2;

// D-shaped bore module
module d_bore(h) {
    circle_r = input_bore/2;
    linear_extrude(height=h)
        difference() {
            circle(r=circle_r);
            // Subtract rectangle to flatten one side → true D-shape
            translate([-circle_r, -circle_r])
                square([2*circle_r, circle_r - d_flat_height/2]);
        }
}

// Hub with bore and setscrew
translate([0, 0, tooth_width/2 + input_hub_height])
    rotate([180, 0, 0])
        difference() {
            // Hub cylinder
            translate([0, 0, tooth_width/2])
                cylinder(d = input_hub_diameter, h = input_hub_height);

            // D-shaped bore with explicit clearance
            translate([0, 0, tooth_width/2 - 0.1])
                d_bore(input_hub_height + 0.2);

            // Setscrew hole aligned with the flat (−Y axis)
            translate([0, -input_hub_diameter, tooth_width/2 + input_hub_height/2])
                rotate([90, 0, 0])  // along Y-axis
                    cylinder(
                        d = setscrew_diameter - setscrew_clearance,
                        h = input_hub_diameter * 2,
                        center = true
                    );
        }

// Gear body with chamfers
translate([0, 0, tooth_width/2 + input_hub_height])
    difference() {
        spur_gear(
            mod = module_size,
            teeth = input_teeth,
            thickness = tooth_width,
            shaft_diam = input_bore,   // explicit clearance applied
            pressure_angle = pressure_angle
        );

        difference() {
            translate([0, 0, tooth_width/2 - chamfer_height])
                cylinder(d = base_radius + 12, h = input_hub_height - chamfer_height);

            translate([0, 0, tooth_width/2 - chamfer_height])
                cylinder(r1 = base_radius, r2 = chamfer_cone_base_radius, h = chamfer_height);
        }

        mirror([0, 0, 1])
            difference() {
                translate([0, 0, tooth_width/2 - chamfer_height])
                    cylinder(d = base_radius + 12, h = input_hub_height - chamfer_height);

                translate([0, 0, tooth_width/2 - chamfer_height])
                    cylinder(r1 = base_radius, r2 = chamfer_cone_base_radius, h = chamfer_height);
            }
    }
