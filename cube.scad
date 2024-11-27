use <dovetail.scad>
use <hinged_square.scad>
use <geometry.scad>
use <magnet.scad>

$fn = 40;

thickness = 4;
depth = 5;
edge_length = 40;

dovetail_n = 6;
hinge_n = 6;

module face(flip) {
    intersection() {
        hinged_square(
            edge_length=edge_length, 
            depth=depth, 
            thickness=thickness,
            hinge_n=hinge_n,
            flip=flip);
        cube(edge_length, center=true);
    }
}

module inner_dovetail_piece() {
    translate([0, 2+depth-edge_length/2, 0])
    dovetail(
        width=edge_length, 
        n=dovetail_n, 
        thickness=thickness,
        zig_or_zag=true);
}

module outer_dovetail_piece() {
    translate([0, 2+depth-edge_length/2, 0])
    rotate([180,0,0])
    dovetail(
        width=edge_length, 
        n=dovetail_n, 
        thickness=thickness,
        zig_or_zag=false);    
}

module all_inner_dovetails() {
    intersection_for(a=[90:90:360]) 
        rotate(a) inner_dovetail_piece();
}

module all_outer_dovetails() {
    for(a=[90:90:360]) 
        rotate(a) outer_dovetail_piece();
}

module inner() {
    intersection() {
        all_inner_dovetails();
        children();
    }
}

module outer() {
    intersection() {
        all_outer_dovetails();
        children();
    }
}

e = edge_length/2;
A = [-e,-e];
B = [e,-e];
C = [e,e];

module piece() {
    magnet_cut_outs([[A,C]], thickness)
    intersection() {
        linear_extrude(2*thickness, center=true)
        polygon([A,B,C]);
        inner() face(0);
    }
}

module conn() {
    rotate([180,0,0])
    intersection() {
        for (x=[0, 1])
            translate([x * edge_length,0,0])
            outer() face(x);
        linear_extrude(2*thickness, center=true)
        offset(-.3)  // corner relief
        polygon([[0,0],[e,e],[2*e,0],[e,-e]]);
    }
}


conn();