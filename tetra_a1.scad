use <hinged_triangle.scad>
use <geometry.scad>

$fn = 40;

thickness = 3;
depth = 5;
edge_length = 60;

pts = triangle_points(edge_length);

module face1() {
    hinged_triangle(
        edge_length=edge_length, depth=depth, thickness=thickness,
        hinge_n=11, flip_hinges=[0,0,1]);
}

A = pts[0];
B = pts[1];
C = pts[2];
F = along(A,B,.5);
G = along(B,C,1/3);
H = along(B,C,2/3);

//cut_through(F,G) face1();
//cut_through(H,A) face1();
cut_through(A,H) cut_through(G,F) face1();