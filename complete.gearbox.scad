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
tolerance_output_bore = 0.4;     // Output gear bore tolerance

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

clearance_internal_bottom = 1.5;   // Clearance below gears
clearance_internal_top = 1.5;      // Clearance above gears

box_height = (floor_thickness * 2 +          
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
output_hole_edge_distance = 7;    // Distance from output hole center to wall edge
output_hole_diameter = 4.2;       // M4 mounting holes at output end
output_hole_tolerance = 0.2;      //clearance for M4 mounting holes at output end

output_hole1_x = output_hole_edge_distance;
output_hole1_y = housing_length - output_hole_edge_distance;
output_hole2_x = housing_width - output_hole_edge_distance;
output_hole2_y = housing_length - output_hole_edge_distance;

// corner chamfer   
box_chamfer_width = wall_thickness;
   

module corner_chamfer(box_chamfer_width, box_chamfer_size) {
  cube([box_chamfer_width, box_chamfer_size, box_height]);
}


// Visualization offsets
z_offset_top_housing = 100;
z_offset_gears = 40;

// ============================================================================
// BOTTOM HOUSING HALF
// ============================================================================

difference() {
    union() {
        // Main box body
        cube([housing_width, housing_length, box_height]);
        
        // Input bearing boss
        translate([input_x, input_y, 0])
            difference() {
                cylinder(d = bearing_od + 4, h = bearing_pocket_depth);
                cylinder(d = bearing_id + clearance_boss_center, h = bearing_pocket_depth + 0.2);
            }
        
        // Output bearing boss
        translate([output_x, output_y, 0])
            difference() {
                cylinder(d = bearing_od + 4, h = bearing_pocket_depth);
                cylinder(d = bearing_id + clearance_boss_center, h = bearing_pocket_depth + 0.2);
            }
    }
    
    // NEMA17 motor boss clearance
    translate([input_x, input_y, -0.1])
        cylinder(d = nema17_boss_diameter, h = nema17_boss_depth + 0.1);
    
    // Interior cavity
    translate([wall_thickness, wall_thickness, floor_thickness])
        cube([housing_width - (wall_thickness * 2), 
              housing_length - (wall_thickness * 2), 
              box_height]);
    
    // Input bearing pocket
    translate([input_x, input_y, -0.1])
        cylinder(d = bearing_od + clearance_bearing_pocket, h = bearing_pocket_depth + 0.1);
    
    // Input shaft clearance
    translate([input_x, input_y, -0.1])
        cylinder(d = bearing_id + clearance_boss_center, h = box_height + 0.2);
    
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
        cylinder(d = output_hole_diameter + output_hole_tolerance, h = box_height);
    translate([output_hole2_x, output_hole2_y, 0])
        cylinder(d = output_hole_diameter + output_hole_tolerance, h = box_height);
 
    // Box chamfers
    cutting_width = 5/2;
    translate([cutting_width/sqrt(2), -cutting_width/sqrt(2), 0]){
      rotate([0,0,45]) {
        corner_chamfer(cutting_width, box_chamfer_size);
      }
    }
    
    // Bottom-right corner
    translate([housing_width + cutting_width/sqrt(2), cutting_width/sqrt(2), 0]){
      rotate([0,0,135]) {
        corner_chamfer(cutting_width, box_chamfer_size);
      }
    }
    
    // Top-left corner
    translate([-cutting_width/sqrt(2), housing_length - cutting_width/sqrt(2), 0]){
      rotate([0,0,315]) {
        corner_chamfer(cutting_width, box_chamfer_size);
      }
    }
    
    // Top-right corner
    translate([housing_width - cutting_width/sqrt(2), housing_length + cutting_width/sqrt(2), 0]){
      rotate([0,0,225]) {
        corner_chamfer(cutting_width, box_chamfer_size);
      }
    }
    
    
  }

// Output bearing boss (outer)
  translate([output_x, output_y, 0])
    difference() {
        cylinder(d = boss_diameter, h = bearing_pocket_depth);
        cylinder(d = bearing_od + clearance_bearing_pocket, h = bearing_pocket_depth + 0.2);
    }

// Output bearing retainer ring (bottom)
translate([output_x, output_y, bearing_pocket_depth])
    difference() {
        cylinder(d = boss_diameter, h = bearing_retainer_height);
        cylinder(d = bearing_retainer_id, h = bearing_retainer_height + 0.2);
    }

box_chamfer_size = 5; 
translate([box_chamfer_size/sqrt(2), 0, 0]){
  rotate([0,0,45]) {
    corner_chamfer(box_chamfer_width, box_chamfer_size);
  }
}


// Bottom-right corner
translate([housing_width, box_chamfer_size/sqrt(2), 0]){
  rotate([0,0,135]) {
    corner_chamfer(box_chamfer_width, box_chamfer_size);
  }
}

// Top-left corner
translate([0, housing_length - box_chamfer_size/sqrt(2), 0]){
  rotate([0,0,315]) {
    corner_chamfer(box_chamfer_width, box_chamfer_size);
  }
}


// Top-right corner
translate([housing_width - box_chamfer_size/sqrt(2), housing_length, 0]){
  rotate([0,0,225]) {
    corner_chamfer(box_chamfer_width, box_chamfer_size);
  }
}

// ============================================================================
// TOP HOUSING HALF
// ============================================================================

translate([housing_width, 0, z_offset_top_housing]) {
    rotate([0, 180, 0]) {
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
                cylinder(d = output_hole_diameter + output_hole_tolerance, h = box_height);
            translate([output_hole2_x, output_hole2_y, 0])
                cylinder(d = output_hole_diameter + output_hole_tolerance, h = box_height);
                
            // Box chamfers
            cutting_width = 5/2;
            translate([cutting_width/sqrt(2), -cutting_width/sqrt(2), 0]){
              rotate([0,0,45]) {
                corner_chamfer(cutting_width, box_chamfer_size);
              }
            }
            
            // Bottom-right corner
            translate([housing_width + cutting_width/sqrt(2), cutting_width/sqrt(2), 0]){
              rotate([0,0,135]) {
                corner_chamfer(cutting_width, box_chamfer_size);
              }
            }
            
            // Top-left corner
            translate([-cutting_width/sqrt(2), housing_length - cutting_width/sqrt(2), 0]){
              rotate([0,0,315]) {
                corner_chamfer(cutting_width, box_chamfer_size);
              }
            }
            
            // Top-right corner
            translate([housing_width - cutting_width/sqrt(2), housing_length + cutting_width/sqrt(2), 0]){
              rotate([0,0,225]) {
                corner_chamfer(cutting_width, box_chamfer_size);
              }
            }
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
        
        translate([box_chamfer_size/sqrt(2), 0, 0]){
          rotate([0,0,45]) {
            corner_chamfer(box_chamfer_width, box_chamfer_size);
          }
        }
        
        
        // Bottom-right corner
        translate([housing_width, box_chamfer_size/sqrt(2), 0]){
          rotate([0,0,135]) {
            corner_chamfer(box_chamfer_width, box_chamfer_size);
          }
        }
        
        // Top-left corner
        translate([0, housing_length - box_chamfer_size/sqrt(2), 0]){
          rotate([0,0,315]) {
            corner_chamfer(box_chamfer_width, box_chamfer_size);
          }
        }
        
        
        // Top-right corner
        translate([housing_width - box_chamfer_size/sqrt(2), housing_length, 0]){
          rotate([0,0,225]) {
            corner_chamfer(box_chamfer_width, box_chamfer_size);
          }
        }
    }
}

// ============================================================================
// GEARS (VISUALIZATION)
// ============================================================================

// INPUT GEAR (Blue)
color("lightblue")
translate([input_x, input_y, floor_thickness + z_offset_gears]) {
    // Hub with D-bore
    translate([0, 0, gear_thickness/2 + hub_height_input])
        rotate([180, 0, 0])
            difference() {
                translate([0, 0, gear_thickness/2])
                    cylinder(d = hub_diameter_input, h = hub_height_input);
                
                // D-shaped bore
                translate([0, 0, gear_thickness/2 - 0.1])
                    linear_extrude(height = hub_height_input + 0.2) {
                        difference() {
                            circle(r = (shaft_diameter_input + tolerance_shaft) / 2);
                            translate([-(shaft_diameter_input + tolerance_shaft)/2, 
                                     -(shaft_diameter_input + tolerance_shaft)/2])
                                square([shaft_diameter_input + tolerance_shaft, 
                                       (shaft_diameter_input + tolerance_shaft)/2 - shaft_flat_height/2]);
                        }
                    }
                
                // Setscrew hole
                translate([0, -hub_diameter_input, gear_thickness/2 + hub_height_input/2])
                    rotate([90, 0, 0])
                        cylinder(d = setscrew_input_diameter - setscrew_input_clearance, 
                               h = hub_diameter_input * 2, 
                               center = true);
            }
    
    // Gear with chamfers
    translate([0, 0, gear_thickness/2 + hub_height_input])
        difference() {
            spur_gear(
                mod = gear_module,
                teeth = teeth_input,
                thickness = gear_thickness,
                shaft_diam = shaft_diameter_input + tolerance_shaft,
                pressure_angle = gear_pressure_angle
            );
            
            // Top chamfer
            difference() {
                translate([0, 0, gear_thickness/2 - chamfer_height])
                    cylinder(d = chamfer_base_radius_gear + 12, h = hub_height_input - chamfer_height);
                translate([0, 0, gear_thickness/2 - chamfer_height])
                    cylinder(r1 = chamfer_base_radius_gear, 
                           r2 = chamfer_base_radius_input, 
                           h = chamfer_height);
            }
            
            // Bottom chamfer
            mirror([0, 0, 1])
                difference() {
                    translate([0, 0, gear_thickness/2 - chamfer_height])
                        cylinder(d = chamfer_base_radius_gear + 12, h = hub_height_input - chamfer_height);
                    translate([0, 0, gear_thickness/2 - chamfer_height])
                        cylinder(r1 = chamfer_base_radius_gear, 
                               r2 = chamfer_base_radius_input, 
                               h = chamfer_height);
                }
        }
}

// OUTPUT GEAR (Green)
color("lightgreen")
translate([output_x, output_y, z_offset_gears + hub_height_output + chamfer_height + gear_thickness]) {
  rotate([0,180,1.8]) {
    intersection() {
          translate([0, 0, gear_thickness / 2]) {
              difference() {
                  union() {
                      // Gear body
                      spur_gear(
                          mod = gear_module,
                          teeth = teeth_output,
                          thickness = gear_thickness,
                          shaft_diam = shaft_diameter_output + tolerance_output_bore,
                          pressure_angle = gear_pressure_angle
                      );
                      
                      // Hub
                      translate([0, 0, gear_thickness/2])
                          cylinder(d = hub_diameter_output, h = hub_height_output);
                  }
                  
                  // Bore
                  translate([0, 0, gear_thickness/2])
                      cylinder(d = shaft_diameter_output + tolerance_output_bore, h = hub_height_output);
                  
                  // Setscrew hole
                  translate([0, 0, hub_height_output + (gear_thickness / 2) - 4])
                      rotate([90, 0, 0])
                          cylinder(d = setscrew_output_diameter - setscrew_output_clearance, 
                                 h = hub_diameter_output, 
                                 center = true);
              }
          }
          
          // Chamfer profile
          union() {
              translate([0, 0, gear_thickness]) {
                  cylinder(r = chamfer_base_radius_output, h = hub_height_output);
              }
              translate([0, 0, gear_thickness - chamfer_height]) {
                  cylinder(r1 = outer_radius_output, 
                         r2 = chamfer_base_radius_output, 
                         h = chamfer_height);
              }
              translate([0, 0, chamfer_height]) {
                  mirror([0, 0, 1]) {
                      cylinder(r1 = outer_radius_output, 
                             r2 = chamfer_base_radius_output, 
                             h = chamfer_height);
                  }
              }
              translate([0, 0, chamfer_height])
                  cylinder(r = outer_radius_output, h = gear_thickness - 2 * chamfer_height);
          }
      }
  }
}