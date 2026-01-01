# Spur Gearbox for NEMA17 Motor

A fully parametric **3D printable single-stage spur gear reduction gearbox** designed in OpenSCAD, intended for NEMA17 stepper motors.

This design provides a clean, compact reduction using chamfered spur gears for smoother meshing, supported by 695ZZ bearings (5x13x4 mm). The split housing allows easy assembly, and the output shaft is designed for a 9 mm round shaft with setscrew.

**Gear ratio**: 32:12 ≈ **2.667:1** reduction

## Features

- Direct mount to standard NEMA17 motors (31 mm hole pattern)
- Input gear with D-shaft bore for standard 5 mm motor shafts
- Chamfered gears to reduce sharp edges and improve print quality/meshing
- Integrated bearing pockets and retainers for two 695ZZ bearings
- Setscrew hubs on both input and output gears
- Mounting holes on the output end (M4)
- Printed in two halves (top + bottom housing) for easy access

## Files

- `complete.gearbox.scad` – Full assembly view (open this to preview the complete gearbox)
- `housing_bottom.scad` – Bottom half of the housing
- `housing_top.scad` – Top half of the housing
- `input_gear_chamfered.scad` – Input gear (12 teeth) with hub and D-bore
- `output_gear_chamfered.scad` – Output gear (32 teeth) with hub
- `.stl` files – Pre-exported meshes ready for slicing/printing

## How to Generate STL Files and 3D Print

### Using OpenSCAD (recommended for latest/custom versions)

1. Install OpenSCAD (free from https://openscad.org/)
2. Open each part file you want to print:
   - `housing_bottom.scad`
   - `housing_top.scad`
   - `input_gear_chamfered.scad`
   - `output_gear_chamfered.scad`
   - (Optional: open `complete.gearbox.scad` first to preview the full assembly)
3. Press **F5** to preview the model
4. Press **F6** to render (this computes the full geometry – takes a few seconds)
5. Once rendered, go to **File > Export > Export as STL** and save the file
6. Repeat for each part

### Using Pre-exported STLs

The repository already includes ready-to-print STL files for all parts. Simply download them directly.

### Slicing and Printing Recommendations

- **Material**: PETG or PLA+ recommended for strength and durability (ABS/ASA also good if you have an enclosure)
- **Layer height**: 0.15–0.2 mm for good balance of strength and detail
- **Infill**: 30–50% (use more for gears if under heavy load)
- **Perimeters/Walls**: 3–4 for strength
- **Supports**: Usually minimal or none needed. Small tree supports may help under bearing bosses if your printer struggles with bridging
- **Orientation**: Print housing halves flat on the bed (large flat side down) for best strength
- **Brim**: Recommended for better bed adhesion on larger parts

## Required Hardware

- 2 × 695ZZ bearings (5 × 13 × 4 mm)
- M3 grub screw for input gear setscrew
- M4 or M5 grub screw for output shaft
- Optional: M3/M4 screws or glue to secure top and bottom housing together

## Customization

Parameters are defined at the top of the SCAD files. You can easily modify:
- Gear ratio (change tooth counts)
- Module (tooth size)
- Shaft diameters
- Clearances and tolerances for your printer

Open `complete.gearbox.scad` to visualize changes in the full assembly.

Enjoy the build! If you print it, feel free to share improvements. 🚀
