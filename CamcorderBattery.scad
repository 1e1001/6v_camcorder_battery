/* concerns:

2AA top filler harmful?

2.9-3mm screw holes

*/

module SocketHook(y) {
    // traced shape
    translate([0, y + 3, 0]) rotate([90, 0, 0]) linear_extrude(3)
    polygon([[-1, 4], [10, 4], [10, 1.2], [5.5, 1.2], [5.5, 0], [28, 0], [28, 4], [43, 4], [43, 1.2], [37.5, 1.2], [37.5, -1], [-1, -1]], convexity = 10);
}
module SocketRegistration(y, l, r, t) {
    for (x = [[1, l], [45 - r, r]]) {
        translate([x.x, y, -1]) {
            cube([x.y, 4, 3]);
            if (t) {
                multmatrix([
                    [1, 0, 0, 0],
                    [0, 1, 0, -1.5],
                    [0, 1, 1, -2.5],
                ]) cube([x.y, 2, 3]);
            }
        }
    }
}

module Screws(d) {
    screw_pos = [[23, 18, 0], [23, 54, 0]];
    for (pos = screw_pos) {
        translate(pos) {
            $fn = 64;
            translate([0, 0, -1]) cylinder(h = 11, d = d);
            translate([0, 0, 9 - 1.86]) cylinder(h = 1.86 * 2, d1 = 3, d2 = 3 + 3.7 * 2);
        }
    }
}

module Socket() {
    difference() {
        cube([46, 89, 7]);
        SocketHook(-1);
        SocketHook(87);
        SocketRegistration(16, 12, 12, true);
        SocketRegistration(33, 9, 9, false);
        SocketRegistration(50, 14, 9, false);
        Screws(2.8);
    }
}

module Holder() {
    difference() {
        // base
        cube([102, 72, 2]);
        // switch cutouts - slanted
//        translate([0, 70, 0]) rotate([90, 0, 0]) linear_extrude(10)
//        polygon([[4, -2], [4, -1], [8, 3], [14, 3], [18, -1], [74, -1], [74, 3], [81, 3], [85, -1], [85, -2]]);
        // switch cutouts - cubic
        translate([7, 58, -1]) cube([15, 12, 4]);
        translate([74, 58, -1]) cube([12, 12, 4]);
        translate([28, 0, -7]) Screws(3);
    }
    // rims
    cube([102, 2, 7]);
    translate([0, 70, 0]) cube([102, 2, 7]);
    cube([2, 72, 7]);
    translate([100, 0, 0]) cube([2, 72, 7]);
    // rim for smaller battery
    translate([67, 0, 0]) cube([35, 2.2, 7]);
}

module Contact(x) {
    translate([x, 65, 0]) {
        // outer cutout
        translate([0, 0, -1]) cube([10, 12, 1.5]);
        // contact hold
        translate([1, 2, -1]) cube([8, 5, 2.6]);
        // upper carving / holding ring
        rotate([90, 0, 90]) linear_extrude(10)
        polygon(points = [
            [-7, 9.5], [1, 1.5], [8, 1.5], [13.5, 7], [13.5, 9], [5, 9],
            [2, 5], [7, 5], [7, 2], [2, 2],
        ], paths = [[0, 1, 2, 3, 4, 5], [6, 7, 8, 9]]);
    }
}

stack = false;

translate(stack ? [0, 0, 0] : [0, 0, 7]) rotate(stack ? [0, 0, 0] : [0, 180, 0])
color([0, 0, 1]) difference() {
    // base shapes + additions
    Socket();
    Contact(4);
    Contact(32);
}
translate(stack ? [-28, 0, 7] : [10, 0, 0]) 
color([0, 1, 0]) Holder();

//color([1, 0, 0, 0.5])
//union() {
//    // 2AA reference
//    translate([65 - 26, 12, 9]) cube([33, 67, 18]);
//    // 4AA reference
//    translate([-26, 11, 9]) cube([65, 68, 19]);
//}

