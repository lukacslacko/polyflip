dovetail_tension = 0.08;
dovetail_shape = 0.4;
dovetail_depth = 3;
dovetail_lower_cover = 0.4;
dovetail_upper_cover = 0.6;

function shift(pt, vec) = [for (p = vec) p + pt];

function zig(start_x, width) =
    let(
        a = width/4, 
        d = -dovetail_depth,
        s = dovetail_depth * dovetail_shape / 2
    )
    shift(
        [start_x, dovetail_tension],
        [[0,0],[a+s, 0],[a-s, d],[3*a+s, d],[3*a-s, 0]]
    );

function zag(start_x, width) =
    let(
        a = width/4, 
        d = -dovetail_depth,
        s = dovetail_depth * dovetail_shape / 2
    )
    shift(
        [start_x, dovetail_tension],
        [[0,d],[a+s, d],[a-s, 0],[3*a+s, 0],[3*a-s, d]]
    );

function zigzag(start_x, width, zig_or_zag) =
    zig_or_zag ? zig(start_x, width) : zag(start_x, width);

module dovetail(width, n, thickness, zig_or_zag) {
    h = thickness - dovetail_upper_cover;
    unit = width / n;
    translate([-width/2, dovetail_depth/2, -thickness/2]) {
        linear_extrude(h)
        polygon(
            [for (i=[0:n-1]) 
                each(zigzag(unit*i, unit, zig_or_zag)),
             [width, 0], [width, width], [0,width]]);
        translate([0, -dovetail_depth, -10])
        cube([width, width + dovetail_depth, dovetail_lower_cover + 10]);
        translate([0,0,h])
        cube([width, width, dovetail_upper_cover + 10]);
    }
}

intersection_for (y=[0,1]) mirror([0,y,0])
translate([0,8,0])
rotate([180,0,0])
dovetail(100, 10, 4);