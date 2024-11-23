function triangle_edge_length(edge_length, depth) =
    edge_length - 2*sqrt(3)*depth;

module triangle(edge_length, depth, thickness) {
    e_top = triangle_edge_length(edge_length, depth);
    r_top = e_top/sqrt(3);
    r_bottom = r_top + thickness * sqrt(3)/2;
    rotate(90)
    for (z=[0,1]) mirror([0,0,z])
    linear_extrude(thickness/2, scale=r_top/r_bottom)
    circle(r=r_bottom, $fn=3);
}
