include <oled_case_params.scad>

module outer_shell() {
    translate([0, pocket_center_y, case_height / 2])
        cube([outer_x, outer_y, case_height], center=true);
}

module inner_pocket() {
    translate([0, pocket_center_y, front_thickness + (case_height / 2)])
        cube([inner_x, inner_y, case_height], center=true);
}

module display_window() {
    cube([window_x, window_y, side_wall_thickness * 3], center=true);
}

module pin_shaft() {
    cylinder(h = pin_height, d = pin_dia, $fn = 32);
}

module pin_reinforcement() {
    cylinder(h = flare_height, d1 = flare_dia, d2 = pin_dia, $fn = 32);
}

module reinforced_pin() {
    union() {
        pin_shaft();
        pin_reinforcement();
    }
}

module mounting_pins() {
    for (px = [-pin_dist_x/2, pin_dist_x/2], py = [bottom_pin_y, top_pin_y]) {
        translate([px, py, front_thickness]) reinforced_pin();
    }
}

module gap_filler() {
    translate([0, filler_y_pos, case_height])
    rotate([0, -90, 0])
    linear_extrude(height = filler_width, center = true)
    polygon(points=[[0,0], [0, -filler_extension], [-filler_height, 0]]);
}

module display_case_assembly() {
    union() {
        difference() {
            outer_shell();
            inner_pocket();
            display_window();
        }
        mounting_pins();
        gap_filler();
    }
}

//projection(cut = true) 
//translate([0, 0, -1]) 
display_case_assembly();