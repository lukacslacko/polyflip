use <hinge.scad>
use <triangle.scad>

module hinged_triangle(
    edge_length, depth, thickness, hinge_n, flip) {
    for (i=[0,1,2]) {
        rotate(120*i)
        translate([0, -edge_length*sqrt(3)/6, 0])
        rotate(180*flip)
        hinge(
            width=triangle_edge_length(edge_length=edge_length, depth=depth), 
            depth=depth, 
            thickness=thickness, 
            n=hinge_n);
    }
    triangle(
        edge_length=edge_length, 
        depth=depth, 
        thickness=thickness);
}