include <oled_case_params.scad>

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

module mounting_pins() {
    for (px = [-pin_dist_x/2, pin_dist_x/2], py = [bottom_pin_y, top_pin_y]) {
        translate([px, py, front_th]) 
        difference() {
            union() {
                cylinder(h = pin_height, d = pin_dia, $fn = 32);
                cylinder(h = flare_height, d1 = flare_dia, d2 = pin_dia, $fn = 32);
            }
            translate([0, 0, -eps])
                cylinder(d = pin_hole_dia, h = pin_height + 0.2, $fn = 32);
        }
    }
}

module gap_filler() {
    translate([0, filler_y_pos, case_height])
    rotate([0, -90, 0])
    linear_extrude(height = filler_width, center = true)
    polygon(points=[[0,0], [0, -filler_extension], [-filler_height, 0]]);
}

module lid_locking_recesses() {
    translate([0, pocket_center_y - (lid_y / 2) + (tab_depth / 2), case_height - (tab_depth / 2)])
        cube([(lid_x * edge_length_factor) + (print_margin * 2), tab_pocket_width, tab_depth + eps], center = true);
    translate([(lid_x / 2) - (tab_depth / 2), pocket_center_y, case_height - (tab_depth / 2)])
        cube([tab_pocket_width, (lid_y * edge_length_factor) + (print_margin * 2), tab_depth + eps], center = true);
    translate([(-lid_x / 2) + (tab_depth / 2), pocket_center_y, case_height - (tab_depth / 2)])
        cube([tab_pocket_width, (lid_y * edge_length_factor) + (print_margin * 2), tab_depth + eps], center = true);
}

module display_case_assembly() {
    union() {
        difference() {
            outer_shell();
            inner_pocket();
            display_window();
            lid_locking_recesses();
        }
        mounting_pins();
        gap_filler();
    }
}

//projection(cut = true) 
//translate([0, 0, -1]) 
display_case_assembly();