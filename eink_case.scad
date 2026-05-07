wall = 0.8;
outer_x = 37;
outer_y = 54;
outer_z = 50;
window_size = 27.6;
inner_x = outer_x - 2 * wall;
inner_y = outer_y - 2 * wall;
epsilon = 0.01;

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
        (outer_y - window_size) / 2,
        -epsilon
    ])
        cube([
            window_size,
            window_size,
            wall + 2 * epsilon
        ]);
}

//projection(cut = true) 
//translate([0, 0, -5])
//rotate([90, 0, 0])
difference() {
    outer_shell();
    inner_cavity();
    eink_window();
}