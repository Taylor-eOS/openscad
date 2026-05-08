display_x = 32.8;
display_y = 50;
nozzle = 0.4;
wall = nozzle * 2;
print_margin = 0.15;
extra_space = 2;
outer_x = display_x + wall + print_margin * 2 + extra_space * 2;
outer_y = display_y + wall + print_margin * 2 + extra_space * 2;
inner_x = outer_x - 2 * wall;
inner_y = outer_y - 2 * wall;
outer_height_z = 20;
display_window = 27.6;
epsilon = 0.01;
window_y_offset = 2.6;
pin_diameter = 3.15;
pin_height = 4;
pin_y_top_offset = 5;
pin_y_bottom_offset = 11.56;
pin_x_offset = 0.2;
pin_facets = 32;
make_flat = false;

module outer_shell() {
    cube([outer_x, outer_y, outer_height_z]);
}

module inner_cavity() {
    translate([wall, wall, wall])
        cube([inner_x, inner_y, outer_height_z]);
}

module eink_window() {
    translate([
        (outer_x - display_window) / 2,
        ((outer_y - display_window) / 2) + window_y_offset,
        -epsilon
    ])
        cube([
            display_window,
            display_window,
            wall + 2 * epsilon + 0.5
        ]);
}

module chamfered_pin(d, h) {
    chamfer_height = h * 0.3;
    base_height = h - chamfer_height;
    cylinder(h = base_height, d = d, $fn = pin_facets);
    translate([0, 0, base_height])
        cylinder(h = chamfer_height, d1 = d, d2 = d * 0.7, $fn = pin_facets);
}

module pins() {
    window_x_left = (outer_x - display_window) / 2;
    window_x_right = (outer_x + display_window) / 2;
    window_y_bot = ((outer_y - display_window) / 2) + window_y_offset;
    window_y_top = ((outer_y + display_window) / 2) + window_y_offset;
    pin_x_left = window_x_left + pin_x_offset;
    pin_x_right = window_x_right - pin_x_offset;
    for (px = [pin_x_left, pin_x_right]) {
        translate([px, window_y_bot - pin_y_bottom_offset, wall])
            chamfered_pin(pin_diameter, pin_height);
        translate([px, window_y_top + pin_y_top_offset, wall])
            chamfered_pin(pin_diameter, pin_height);
    }
}

module conditional_projection(apply) {
    if (apply) {
        projection(cut = true) translate([0, 0, -1]) children();
    } else {
        children();
    }
}

conditional_projection(make_flat) {
    union() {
        difference() {
            outer_shell();
            inner_cavity();
            eink_window();
        }
        pins();
        if (make_flat) { eink_window(); }
    }
}