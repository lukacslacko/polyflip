magnet_width = 5;
magnet_height = 2.5;
magnet_depth = 1.5;
magnet_gap = .2;
magnet_wall = .8;
magnet_cover = .7;

module magnet_hole(p, q, thickness) {
    x = (q-p) / norm(q-p);
    y = [-x[1], x[0]];
    a = -90 + atan2(-x[0], x[1]);
    v = (p+q) / 2;
    width = magnet_width + magnet_gap + 2*magnet_wall;
    depth = magnet_depth + magnet_gap + magnet_wall;
    height = magnet_height + magnet_gap + magnet_cover;
    translate(v)
    rotate(a)
    translate([-width/2, 0.6,  thickness - height + 0.01])
    cube([width, depth, height]);
}

module magnet_holder() {
    width = magnet_width + magnet_gap + 2*magnet_wall;
    depth = magnet_depth + magnet_gap + magnet_wall;
    height = magnet_height + magnet_gap + magnet_cover;
    difference() {
        cube([width, depth, height-.2]);
        translate([magnet_wall, -0.01, magnet_cover])
        cube([width-2*magnet_wall, depth-magnet_wall, height]);
    }
}

module magnet_cut_outs(edges, thickness) {
    difference() {
        children();
        for (edge=edges) magnet_hole(edge[0], edge[1], thickness);
    }
}

A = [-20, 0];
B = [10, 10];
C = [0, -10];
magnet_cut_outs([[A,B],[B,C],[C,A]],4)
linear_extrude(4)
polygon([A, B, C]);

for (y=[0,5,10])
translate([10,-y,0])
magnet_holder();