outer_x = 37.9;
outer_y = 55.1;
inner_x = 36.3;
inner_y = 53.5;
base_wall = 0.8;
lid_total_h = 4.0;
plug_wall_thickness = 2.0;
tolerance = 0.2;
usb_w = 9.8 + tolerance;
usb_h = 5.8 + tolerance;
usb_r = 2.9;
usb_offset_y = 10.0;
usb_ring_h = 0.4;
hole_w = 14.0;
hole_h = 10.0;
hole_offset_y = 10.0;
eps = 0.01;
include_sensor_hole = true;

module usb_shape(extra_r = 0, height = base_wall) {
    hull() {
        for (i = [-1, 1], j = [-1, 1]) {
            translate([
                i * (usb_w / 2 - usb_r), 
                j * (usb_h / 2 - usb_r), 
                0
            ])
            cylinder(h = height, r = usb_r + extra_r, center = false, $fn = 32);
        }
    }
}

module lid_base() {
    cube([outer_x, outer_y, base_wall]);
}

module lid_frame() {
    translate([base_wall + tolerance, base_wall + tolerance, base_wall])
        difference() {
            cube([
                inner_x - 2 * tolerance, 
                inner_y - 2 * tolerance, 
                lid_total_h - base_wall
            ]);
            translate([plug_wall_thickness, plug_wall_thickness, -eps])
                cube([
                    inner_x - 2 * tolerance - 2 * plug_wall_thickness, 
                    inner_y - 2 * tolerance - 2 * plug_wall_thickness, 
                    lid_total_h - base_wall + 2 * eps
                ]);
        }
}

module usb_reinforcement() {
    translate([outer_x / 2, usb_offset_y, base_wall - eps])
        usb_shape(base_wall, usb_ring_h + eps);
}

module sensor_hole() {
    translate([(outer_x - hole_w) / 2, outer_y - hole_offset_y - hole_h, -eps])
        cube([hole_w, hole_h, base_wall + 2 * eps]);
}

module lid_subtractions() {
    translate([outer_x / 2, usb_offset_y, -eps])
        usb_shape(0, base_wall + usb_ring_h + 2 * eps);
    if (include_sensor_hole) { sensor_hole(); }
    
}

module lid_additions() {
    lid_base();
    lid_frame();
    usb_reinforcement();
}

module lid_assembly() {
    difference() {
        lid_additions();
        lid_subtractions();
    }
}

lid_assembly();