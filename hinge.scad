$fn = 40;

hinge_gap = 0.3;
hinge_hole_d = 2.6;
hinge_rod_d = 2.2;

module hinge_hole_piece(width, depth, thickness) {
    h = width - hinge_gap;
    difference() {
        hinge_rod_piece(width, depth, thickness);
        rotate([0,90,0])
        cylinder(d=hinge_hole_d, h=width+1, center=true);
    }
}

module hinge_rod_piece(width, depth, thickness) {
    h = width - hinge_gap;
    rotate([0,90,0]) {
        cylinder(d=thickness, h=h, center=true);
        translate([-thickness/2,0,-h/2])
        cube([thickness, depth, h]);
    }
}

module hinge_rod(width) {
    h = width - hinge_gap;
    rotate([0,90,0])
    cylinder(d=hinge_rod_d, h=h, center=true);
}

module hinge(width, depth, thickness, n) {
    unit_width = width/n;
    shift = width/2 - unit_width/2;
    for (i=[0:2:n-1]) {
        translate([i*unit_width - shift,0,0])
        hinge_rod_piece(unit_width, depth, thickness);
    }
    for (i=[1:2:n-1]) {
        translate([i*unit_width - shift,0,0])
        rotate(180)
        hinge_hole_piece(unit_width, depth, thickness);
    }
    hinge_rod(width);
}

intersection() {
    translate([0,0,-100])
    cube(200, center=true);
    union() {
        for (y=[-8,8]) translate([0,y,0])
        cube([30, 5, 4], center=true);
        hinge(30, 6, 4, 6);
    }
}
