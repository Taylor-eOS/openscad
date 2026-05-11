include <oled_case_params.scad>
    
module lid_base() {
    translate([0, pocket_center_y, back_th / 2])
        cube([lid_x, lid_y, back_th], center=true);
}

module pin_cutout() {
    translate([0, pocket_center_y + (lid_y / 2) - (cutout_depth / 2), back_th / 2])
        cube([cutout_width, cutout_depth + 0.1, back_th + 0.2], center=true);
}

module lid_assembly() {
    difference() {
        lid_base();
        pin_cutout();
    }
}

lid_assembly();