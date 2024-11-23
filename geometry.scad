module cut_through(a_2d, b_2d) {
    v = b_2d - a_2d;
    intersection() {
        translate(a_2d)
        rotate(atan2(-v[0], v[1]))
        translate([100,0,0])
        cube([200,200,10], center=true);
        children();
    }
}

function along(p, q, ratio) = p + ratio * (q-p);

function triangle_points(edge_length) = 
    let(a = edge_length/2, rho = edge_length*sqrt(3)/6) 
    [[-a,-rho], [a,-rho], [0,2*rho]];
