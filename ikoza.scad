use <dovetail.scad>
use <hinged_triangle.scad>
use <geometry.scad>
use <magnet.scad>

$fn = 40;

thickness = 4;
depth = 5;
edge_length = 85;

dovetail_n = 24;
hinge_n = 12;

assert(dovetail_n%4==0);

pts = triangle_points(edge_length);

module face() {
    intersection() {
        hinged_triangle(
            edge_length=edge_length, 
            depth=depth, 
            thickness=thickness,
            hinge_n=hinge_n,
            flip=0);
        linear_extrude(2*thickness, center=true) polygon(pts);
    }
}

module outer_face() {
    intersection() {
        hinged_triangle(
            edge_length=edge_length, 
            depth=depth, 
            thickness=thickness,
            hinge_n=hinge_n,
            flip=1);
        linear_extrude(2*thickness, center=true) polygon(pts);
    }
}

/*
Ear and slot

module ear(p) {
    union() {
        translate(p) {
            cylinder(d1=8,d2=6,h=w/2);
            mirror([0,0,1])
            cylinder(d1=8,d2=6,h=w/2);
        }
        children();
    }
}

module slot(p) {
    difference() {
        children();
        translate(p) {
            translate([0,0,-0.01])
            cylinder(d1=8.1,d2=6.1,h=w/2+.05);
            mirror([0,0,1])
            translate([0,0,-0.01])
            cylinder(d1=8.1,d2=6.1,h=w/2+0.05);
        }
    }
}

module left(dir, ear_or_slot) {
    conn(a,b,dir)
    conn(e,a,1-dir)
    intersection() {
        edge(a,b,45);
        if (ear_or_slot) {
            ear((2*b+e)/3+[1.6,0,0])
            edge(b,e,0,0.05);
        } else {
            slot((2*b+e)/3-[1.6,0,0])
            edge(b,e,0,0.05);
        }
        edge(e,a,45);
        cube([200,200,w],center=true);
    }
}
module right(dir, ear_or_slot) {
    mirror([1,0,0]) left(dir, ear_or_slot);
}


*/

module faces() {
    face();
    for (a=[120:120:360])
        rotate(a)
        translate([0,-edge_length*sqrt(3)/3,0])
        rotate(180)
        outer_face();
}

module inner_dovetail_piece() {
    translate([0, 2+depth-edge_length*sqrt(3)/6, 0])
    dovetail(
        width=2*edge_length, 
        n=dovetail_n, 
        thickness=thickness,
        zig_or_zag=true);
}

module outer_dovetail_piece(zig_or_zag) {
    translate([0, -edge_length*sqrt(3)/6, 0])
    intersection_for(y=[0,1])
        mirror([0,y,0])
        translate([0, 2+depth, 0])
        rotate([180,0,0])
        dovetail(
            width=2*edge_length, 
            n=dovetail_n, 
            thickness=thickness,
            zig_or_zag=zig_or_zag);
}

module all_inner_dovetails() {
    intersection_for(a=[120:120:360]) 
        rotate(a) inner_dovetail_piece();
}

module all_outer_dovetails() {
    for(a=[120:120:360])
        rotate(a) {
            translate([0,edge_length*sqrt(3)/2,0])
            outer_dovetail_piece(zig_or_zag=false);
            outer_dovetail_piece(zig_or_zag=false);
        }
}

module inner() {
    intersection() {
        all_inner_dovetails();
        children();
    }
    // Magnet size: 5x2.5x1.5
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
E = along(A,C,.5);

W = A+(B-C);
T = B+(C-A);
Y = along(C,T,-.5);
I = along(C,T,.5);
X = along(B,T,.5);
J = along(B,W,.5);
U = along(A,W,1/3);
V = along(A,W,2/3);
Z = along(A,W,-1/3);

S = line_line(B,I, F,T);
N = line_line(C,X, A,H);
K = line_line(C,F, A,H);
M = line_line(B,E, F,G);
Q = line_line(F,G, A,J);
R = line_line(B,V, A,J);
L = line_line(A,Y, C,Z);

TL = line_line(A,Y, B,E);
BC = line_line(C,F, A,J);
MC = line_line(C,F, B,E);

module keep(vec) {
    intersection() {
        linear_extrude(2*thickness, center=true)
        polygon(vec);
        children();
    }
}

module piece_1a() { cut_through(F,G) face(); }
module piece_1b() { cut_through(H,A) face(); }
module piece_1c() { cut_through(A,H) cut_through(G,F) face(); }

module piece_2a() { cut_through(F,C) face(); }
module piece_2b() { cut_through(C,F) face(); }

module inner_face_1() {
    translate([2,0,0]) inner() piece_1a();
    translate([0,2,0]) inner() piece_1b();
    inner() piece_1c();
}

module inner_face_2() {
    translate([2,0,0]) inner() piece_2a();
    translate([-2,0,0]) inner() piece_2b();
}

module conn_a() {
    keep([K,M,S,N]) outer() faces();
}

module conn_b() {
    keep([B,S,F,BC]) outer() faces();
}

module conn_c() {
    keep([A,BC,F,M,MC]) outer() faces();
}

module conn_d() {
    keep([A,MC,C,L]) outer() faces();
}

module face_pair() {
    inner_face_2();
    translate([0,-40,0])
    rotate(180)
    inner_face_1();
}

module plane(radius) {
    cube([100,100,2*radius],center=true);
}

module support() {
    intersection() {
        rho=edge_length/sqrt(6) - thickness/2 - 0.2;

        plane(rho);
        intersection_for(a=[90:90:360])
        rotate(a+45)
        rotate([90,0,0])
        plane(rho);
        intersection_for(a=[90:90:360])
        rotate(a)
        rotate([109.28/2,0,0])
        plane(rho);
    }
}

support();