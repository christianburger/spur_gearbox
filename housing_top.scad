// ============================================================================
// 4:1 LINEAR GEARBOX HOUSING
// ============================================================================
// BOSL2 library required
// Print TWICE to get both halves (identical halves)
// ============================================================================

include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = 100;

// ============================================================================
// TOLERANCES & CLEARANCES
// ============================================================================
// Clearance: Add to pockets/holes (makes them bigger for fit)
// Tolerance: Add to shaft bores (allows shaft to pass through)

clearance_bearing_pocket = 0.3;  // Bearing pocket clearance
clearance_screw_hole = 0.0;      // M3 screw hole clearance
clearance_boss_center = 0.3;     // Motor boss center clearance
tolerance_shaft = 0.4;           // Shaft bore tolerance
tolerance_output_bore = 0.6;     // Output gear bore tolerance

// ============================================================================
// GEAR PARAMETERS
// ============================================================================

teeth_input = 12;
teeth_output = 32;
gear_module = 1.156;
gear_thickness = 10;
gear_pressure_angle = 20;

// Calculated gear dimensions
pitch_radius_input = (gear_module * teeth_input) / 2;
pitch_radius_output = (gear_module * teeth_output) / 2;
outer_radius_input = (gear_module * (teeth_input + 2)) / 2;
outer_radius_output = (gear_module * (teeth_output + 2)) / 2;
center_distance = pitch_radius_input + pitch_radius_output + 0.5;

// ============================================================================
// BEARING SPECIFICATIONS (695ZZ: 5mm ID, 13mm OD, 4mm thickness)
// ============================================================================

bearing_id = 5;      // Inner diameter
bearing_od = 13;     // Outer diameter
bearing_thickness = 4;

// ============================================================================
// SHAFT & HUB PARAMETERS
// ============================================================================

// Input shaft (D-shaped)
shaft_diameter_input = 5.0;
shaft_flat_height = 4.0;  // D-shaft flat dimension
hub_diameter_input = 12;
hub_height_input = 10;

// Output shaft (round)
shaft_diameter_output = 9.0;
hub_diameter_output = 18;
hub_height_output = 10;

// Setscrews (M3 grub screws)
setscrew_output_diameter = 3.0;
setscrew_output_clearance = 0.6;  // Undersize for PETG shrinkage

// Setscrews (M5 grub screws)
setscrew_input_diameter = 5.0;
setscrew_input_clearance = 0.6;  // Undersize for PETG shrinkage

// Gear chamfers
chamfer_height = 2.0;
chamfer_angle = 45;
chamfer_base_radius_input = outer_radius_input - chamfer_height * tan(chamfer_angle);
chamfer_base_radius_output = outer_radius_output - chamfer_height * tan(chamfer_angle);
chamfer_base_radius_gear = outer_radius_input + 2;

// ============================================================================
// NEMA17 MOTOR PARAMETERS
// ============================================================================

nema17_body_size = 42.3;          // Standard NEMA17 body dimension
nema17_hole_spacing = 31;         // Mounting hole spacing
nema17_hole_diameter = 3.2;       // M3 mounting holes
nema17_boss_diameter = 23;        // Center boss clearance
nema17_boss_depth = 2.5;          // Boss pocket depth
nema17_hole_edge_distance = 5.65; // Distance from hole center to motor edge

// ============================================================================
// HOUSING DIMENSIONS
// ============================================================================


wall_to_gear_clearance = 5;
housing_width = 50;                // X dimension (matches NEMA17)

//housing_length = 56;

wall_thickness = 2;
floor_thickness = 2;

// Bearing pockets
bearing_pocket_depth = bearing_thickness + 0.5;
bearing_retainer_height = 2.0;     // Retainer ring height
bearing_retainer_id = 7.0;         // Retainer inner diameter
boss_diameter = bearing_od + clearance_bearing_pocket + 10;

clearance_internal_bottom = 1;   // Clearance below gears
clearance_internal_top = 1;      // Clearance above gears

box_height =  (
              clearance_internal_bottom + 
              clearance_internal_top +
              max(hub_height_input, hub_height_output) + 
              gear_thickness + 
              bearing_retainer_height * 2 +
              bearing_pocket_depth * 2) / 2;

   
echo ("clearance_internal_bottom: ", clearance_internal_bottom)
echo ("clearance_internal_top", clearance_internal_top);
echo ("hub_height (max)", max(hub_height_input, hub_height_output));
echo ("gear_thickness: ", gear_thickness)
echo ("bearing_retainer_height (x2): ", bearing_retainer_height * 2);
echo ("bearing_pocket_depth: (x2)", bearing_pocket_depth * 2);   
echo ("\n\n>>>>> box_height: ", box_height);

// ============================================================================
// CALCULATED POSITIONS
// ============================================================================

// Input shaft position (centered on NEMA17 mounting pattern)
input_x = housing_width / 2;
input_y = nema17_hole_edge_distance + nema17_hole_spacing / 2;

// Output shaft position
output_x = input_x;
output_y = input_y + center_distance;

housing_length = output_y + outer_radius_output + wall_to_gear_clearance;


// NEMA17 mounting holes (31mm square pattern)
nema17_hole1_x = input_x - nema17_hole_spacing / 2;
nema17_hole1_y = input_y - nema17_hole_spacing / 2;
nema17_hole2_x = input_x + nema17_hole_spacing / 2;
nema17_hole2_y = input_y - nema17_hole_spacing / 2;
nema17_hole3_x = input_x - nema17_hole_spacing / 2;
nema17_hole3_y = input_y + nema17_hole_spacing / 2;
nema17_hole4_x = input_x + nema17_hole_spacing / 2;
nema17_hole4_y = input_y + nema17_hole_spacing / 2;

// Output end mounting holes (opposite end)
output_hole1_x = input_x - nema17_hole_spacing / 2;
output_hole1_y = housing_length - nema17_hole_edge_distance;
output_hole2_x = input_x + nema17_hole_spacing / 2;
output_hole2_y = housing_length - nema17_hole_edge_distance;

// Visualization offsets
z_offset_top_housing = 100;
z_offset_gears = 40;

// ============================================================================
// TOP HOUSING HALF
// ============================================================================

translate([0, 0, 0]) {
    rotate([0, 0, 0]) {
        difference() {
            union() {
                cube([housing_width, housing_length, box_height]);
            }
            
            // Interior cavity
            translate([wall_thickness, wall_thickness, floor_thickness])
                cube([housing_width - (wall_thickness * 2), 
                      housing_length - (wall_thickness * 2), 
                      box_height]);
            
            // Output bearing pocket
            translate([output_x, output_y, -0.1])
                cylinder(d = bearing_od + clearance_bearing_pocket, h = bearing_pocket_depth + 0.1);
            
            // Output shaft clearance
            translate([output_x, output_y, -0.1])
                cylinder(d = bearing_id + clearance_boss_center, h = box_height + 0.2);
            
            // NEMA17 mounting holes
            translate([nema17_hole1_x, nema17_hole1_y, 0])
                cylinder(d = nema17_hole_diameter + clearance_screw_hole, h = box_height);
            translate([nema17_hole2_x, nema17_hole2_y, 0])
                cylinder(d = nema17_hole_diameter + clearance_screw_hole, h = box_height);
            translate([nema17_hole3_x, nema17_hole3_y, 0])
                cylinder(d = nema17_hole_diameter + clearance_screw_hole, h = box_height);
            translate([nema17_hole4_x, nema17_hole4_y, 0])
                cylinder(d = nema17_hole_diameter + clearance_screw_hole, h = box_height);
            
            // Output end mounting holes
            translate([output_hole1_x, output_hole1_y, 0])
                cylinder(d = nema17_hole_diameter + clearance_screw_hole, h = box_height);
            translate([output_hole2_x, output_hole2_y, 0])
                cylinder(d = nema17_hole_diameter + clearance_screw_hole, h = box_height);
        }
        
        // Output bearing boss (outer)
        translate([output_x, output_y, 0])
            difference() {
                cylinder(d = boss_diameter, h = bearing_pocket_depth);
                cylinder(d = bearing_od + clearance_bearing_pocket, h = bearing_pocket_depth + 0.2);
            }
        
        // Output bearing retainer ring (top)
        translate([output_x, output_y, bearing_pocket_depth])
            difference() {
                cylinder(d = boss_diameter, h = bearing_retainer_height);
                cylinder(d = bearing_retainer_id, h = bearing_retainer_height + 0.2);
            }
    }
}

