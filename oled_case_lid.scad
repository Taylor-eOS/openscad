include <oled_case_params.scad>

module lid_base() {
    translate([0, pocket_center_y, back_th / 2])
        cube([lid_x, lid_y, back_th], center=true);
}

module pin_cutout() {
    translate([0, pocket_center_y + (lid_y / 2) - (cutout_depth / 2), back_th / 2])
        cube([cutout_width, cutout_depth + 0.1, back_th + 0.2], center=true);
}

module corner_tab() {
    translate([0, 0, -tab_depth])
    linear_extrude(height = tab_depth)
    polygon(points = [[0, 0], [tab_size, 0], [0, tab_size]]);
}

module lid_corner_tabs() {
    translate([-lid_x / 2, pocket_center_y - lid_y / 2, 0])
        rotate([0, 0, 0]) corner_tab();
    translate([lid_x / 2, pocket_center_y - lid_y / 2, 0])
        rotate([0, 0, 90]) corner_tab();
    translate([lid_x / 2, pocket_center_y + lid_y / 2, 0])
        rotate([0, 0, 180]) corner_tab();
    translate([-lid_x / 2, pocket_center_y + lid_y / 2, 0])
        rotate([0, 0, 270]) corner_tab();
}

module base_plate() {
    difference() {
        lid_base();
        pin_cutout();
    }
}

module lid_assembly() {
    union() {
        base_plate();
        lid_corner_tabs();
    }
}

lid_assembly();