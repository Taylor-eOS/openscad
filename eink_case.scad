wall = 0.8;
outer_x = 38;
outer_y = 58;
outer_z = 50;
window_size = 27.6;
inner_x = outer_x - 2 * wall;
inner_y = outer_y - 2 * wall;
epsilon = 0.01;
pin_diameter = 2.85;
pin_height = 3;
pin_y_top_offset = 5;
pin_y_bottom_offset = 11.4;
pin_x_offset = 0.2;
window_y_offset = 2;
solid_window = false;

module outer_shell() {
    cube([outer_x, outer_y, outer_z]);
}

module inner_cavity() {
    translate([wall, wall, wall])
        cube([inner_x, inner_y, outer_z]);
}

module eink_window() {
    translate([
        (outer_x - window_size) / 2,
        ((outer_y - window_size) / 2) + window_y_offset,
        -epsilon
    ])
        cube([
            window_size,
            window_size,
            wall + 2 * epsilon + 0.5
        ]);
}

module chamfered_pin(d, h) {
    chamfer_height = h * 0.4; 
    base_height = h - chamfer_height;
    cylinder(h = base_height, d = d, $fn = 32);
    translate([0, 0, base_height])
        cylinder(h = chamfer_height, d1 = d, d2 = d * 0.7, $fn = 32);
}

module pins() {
    window_x_left = (outer_x - window_size) / 2;
    window_x_right = (outer_x + window_size) / 2;
    window_y_bot = ((outer_y - window_size) / 2) + window_y_offset;
    window_y_top = ((outer_y + window_size) / 2) + window_y_offset;
    pin_x_left = window_x_left + pin_x_offset;
    pin_x_right = window_x_right - pin_x_offset;
    for (px = [pin_x_left, pin_x_right]) {
        translate([px, window_y_bot - pin_y_bottom_offset, wall])
            chamfered_pin(pin_diameter, pin_height);
        translate([px, window_y_top + pin_y_top_offset, wall])
            chamfered_pin(pin_diameter, pin_height);
    }
}

//projection(cut = true)
//translate([0, 0, -1]) 
union() {
    difference() {
        outer_shell();
        inner_cavity();
        if (!solid_window) {
            eink_window();
        }
    }
    pins();
    if (solid_window) {
        eink_window();
    }
}