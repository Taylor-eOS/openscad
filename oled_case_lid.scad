include <oled_case_params.scad>

module lid_base() {
    translate([0, pocket_center_y, back_th / 2])
        cube([lid_x, lid_y, back_th], center = true);
}

module pin_cutout() {
    translate([0, pocket_center_y + (lid_y / 2) - (cutout_depth / 2), back_th / 2])
        cube([cutout_width, cutout_depth + 0.1, back_th + 0.2], center = true);
}

module component_recess(x, y) {
    translate([x, y, back_th - recess_depth])
        cylinder(h = recess_depth + 0.1, d = recess_dia, $fn = 32);
}

module lid_pin_holes() {
    for (px = [-pin_dist_x/2, pin_dist_x/2], py = [bottom_pin_y, top_pin_y]) {
        translate([px, py, -0.1])
            cylinder(h = back_th + 0.2, d = pin_hole_dia, $fn = 32);
    }
}

module screw_head_recesses() {
    for (px = [-pin_dist_x/2, pin_dist_x/2], py = [bottom_pin_y, top_pin_y]) {
        translate([px, py, -0.1])
            cylinder(h = screw_head_depth + 0.1, d = screw_head_dia, $fn = 32);
    }
}

module base_plate() {
    difference() {
        lid_base();
        pin_cutout();
        component_recess(recess_pos_x, recess_pos_y);
        lid_pin_holes();
        screw_head_recesses();
    }
}

module edge_bars() {
    translate([0, pocket_center_y - (lid_y / 2) + (tab_depth / 2), back_th + tab_depth / 2])
        cube([lid_x * edge_length_factor, tab_depth, tab_depth], center = true);
    translate([(lid_x / 2) - (tab_depth / 2), pocket_center_y, back_th + tab_depth / 2])
        cube([tab_depth, lid_y * edge_length_factor, tab_depth], center = true);
    translate([(-lid_x / 2) + (tab_depth / 2), pocket_center_y, back_th + tab_depth / 2])
        cube([tab_depth, lid_y * edge_length_factor, tab_depth], center = true);
}

module lid_assembly() {
    union() {
        base_plate();
        edge_bars();
    }
}

lid_assembly();