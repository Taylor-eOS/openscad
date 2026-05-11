display_x = 24.8;
display_y = 26.9;
window_x = 23.4;
window_y = 12.2;
pin_to_window_top = 3.5;
pin_to_window_bottom = 7.2;
pin_dist_x = 20.5;
nozzle = 0.4;
wall_thickness = 2 * nozzle;
front_thickness = 0.8;
print_margin = 0.2;
extra_space = 0.5;
case_height = 4.0 + front_thickness;
inner_x = display_x + (print_margin * 2) + (extra_space * 2);
inner_y = display_y + (print_margin * 2) + (extra_space * 2);
top_pin_y = (window_y / 2) + pin_to_window_top;
bottom_pin_y = -(window_y / 2) - pin_to_window_bottom;
pocket_center_y = (top_pin_y + bottom_pin_y) / 2;
outer_x = inner_x + (wall_thickness * 2);
outer_y = inner_y + (wall_thickness * 2);
pin_diameter = 2.5;
pin_height = 3.5;

module outer_shell() {
    translate([0, pocket_center_y, case_height / 2])
        cube([outer_x, outer_y, case_height], center=true);
}

module inner_pocket() {
    translate([0, pocket_center_y, front_thickness + (case_height / 2)])
        cube([inner_x, inner_y, case_height], center=true);
}

module display_window() {
    cube([window_x, window_y, wall_thickness * 3], center=true);
}

module mounting_pins() {
    positions = [[-pin_dist_x/2, bottom_pin_y], [pin_dist_x/2, bottom_pin_y], [-pin_dist_x/2, top_pin_y], [pin_dist_x/2, top_pin_y]];
    for (p = positions) {
        translate([p[0], p[1], wall_thickness])
            cylinder(h = pin_height, d = pin_diameter, $fn = 32);
    }
}

module conditional_projection(apply) {
    if (apply) {
        projection(cut = true) translate([0, 0, -1]) children();
    } else {
        children();
    }
}

module display_case_assembly(make_flat = false) {
    conditional_projection(make_flat) {
        union() {
            difference() {
                outer_shell();
                inner_pocket();
                display_window();
            }
            mounting_pins();
            if (make_flat) { display_window(); }
        }
    }
}

display_case_assembly(make_flat = false);