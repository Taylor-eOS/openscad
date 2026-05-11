display_x = 24.8;
display_y = 26.9;
window_x = 23.4;
window_y = 12.2;
pin_to_window_top = 3.5;
pin_to_window_bottom = 7.2;
pin_dist_x = 20.5;
nozzle_dia = 0.4;
side_wall_th = nozzle_dia * 2;
front_th = 0.8;
print_margin = 0.2;
extra_space = 0.4;
case_height = 4.0 + front_th + front_th;
inner_x = display_x + (print_margin * 2) + (extra_space * 2);
inner_y = display_y + (print_margin * 2) + (extra_space * 2);
top_pin_y = (window_y / 2) + pin_to_window_top;
bottom_pin_y = -(window_y / 2) - pin_to_window_bottom;
pocket_center_y = (top_pin_y + bottom_pin_y) / 2;
outer_x = inner_x + (side_wall_th * 2);
outer_y = inner_y + (side_wall_th * 2);
pin_dia = 2.5;
pin_height = 3.5;
flare_height = 1.0;
flare_dia = pin_dia + 1.2;

module outer_shell() {
    translate([0, pocket_center_y, case_height / 2])
        cube([outer_x, outer_y, case_height], center=true);
}

module inner_pocket() {
    translate([0, pocket_center_y, front_th + (case_height / 2)])
        cube([inner_x, inner_y, case_height], center=true);
}

module display_window() {
    cube([window_x, window_y, side_wall_th * 3], center=true);
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
        pin_reinforcement(); //Comment out to dimention pins
    }
}

module mounting_pins() {
    for (px = [-pin_dist_x/2, pin_dist_x/2], py = [bottom_pin_y, top_pin_y]) {
        translate([px, py, front_th]) reinforced_pin();
    }
}

module display_case_assembly() {
    union() {
        difference() {
            outer_shell();
            inner_pocket();
            display_window();
        }
        mounting_pins();
        //display_window(); //Add to dimention pins
    }
}

//projection(cut = true) 
//translate([0, 0, -1]) 
display_case_assembly();