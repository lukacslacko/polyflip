use <hinge.scad>

module hinged_square(
    edge_length, depth, thickness, hinge_n, flip) {
    for (i=[0,1,2,3]) {
        rotate(90*i)
        translate([0, -edge_length/2, 0])
        rotate(180*flip)
        hinge(
            width=edge_length - 2 * depth, 
            depth=depth, 
            thickness=thickness, 
            n=hinge_n);
    }
    cube([
        edge_length-2*depth, 
        edge_length-2*depth, 
        thickness], center=true);
}