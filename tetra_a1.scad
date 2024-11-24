use <dovetail.scad>
use <hinged_triangle.scad>
use <geometry.scad>

$fn = 40;

thickness = 4;
depth = 5;
edge_length = 80;

dovetail_n = 22;
hinge_n = 14;

pts = triangle_points(edge_length);

module face1() {
    hinged_triangle(
        edge_length=edge_length, depth=depth, thickness=thickness,
        hinge_n=hinge_n);
}

module inner_dovetail_piece() {
    translate([0, 2+depth-edge_length*sqrt(3)/6, 0])
    dovetail(width=2*edge_length, n=dovetail_n, thickness=thickness);
}

module outer_dovetail_piece() {
    translate([0, 2+depth-edge_length*sqrt(3)/6, 0])
    rotate([180,0,0])
    dovetail(width=2*edge_length, n=dovetail_n, thickness=thickness);
}

module all_inner_dovetails() {
    intersection_for(a=[120:120:360]) 
        rotate(a) inner_dovetail_piece();
}

module all_outer_dovetails() {
    for(a=[120:120:360])
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

A = pts[0];
B = pts[1];
C = pts[2];
F = along(A,B,.5);
G = along(B,C,1/3);
H = along(B,C,2/3);

module piece_1a() { cut_through(F,G) face1(); }
module piece_1b() { cut_through(H,A) face1(); }
module piece_1c() { cut_through(A,H) cut_through(G,F) face1(); }

outer() piece_1a();