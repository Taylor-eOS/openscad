include <oled_case_params.scad>

module lid_base() {
    translate([0, pocket_center_y, back_thickness / 2])
        cube([lid_x, lid_y, back_thickness], center = true);
}

module pin_cutout() {
    translate([0, pocket_center_y + (lid_y / 2) - (cutout_depth / 2), back_thickness / 2])
        cube([cutout_width, cutout_depth + 0.1, back_thickness + 0.2], center = true);
}

module component_recess(x, y) {
    translate([x, y, back_thickness - recess_depth])
        cylinder(h = recess_depth, d = recess_dia, $fn = 32);
}

module base_plate() {
    difference() {
        lid_base();
        pin_cutout();
        component_recess(recess_pos_x, recess_pos_y);
    }
}

module edge_bars() {
    translate([0, pocket_center_y - (lid_y / 2) + (tab_depth / 2), back_thickness + tab_depth / 2])
        cube([lid_x * edge_length_factor, tab_depth, tab_depth], center = true);
    translate([(lid_x / 2) - (tab_depth / 2), pocket_center_y, back_thickness + tab_depth / 2])
        cube([tab_depth, lid_y * edge_length_factor, tab_depth], center = true);
    translate([(-lid_x / 2) + (tab_depth / 2), pocket_center_y, back_thickness + tab_depth / 2])
        cube([tab_depth, lid_y * edge_length_factor, tab_depth], center = true);
}

module lid_assembly() {
    union() {
        base_plate();
        edge_bars();
    }
}

lid_assembly();