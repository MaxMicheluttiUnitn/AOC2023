const std = @import("std");
const partone = struct {
    usingnamespace @import("partone.zig");
};
const parttwo = struct {
    usingnamespace @import("parttwo.zig");
};

pub fn main() !void {
    //try partone.solve();
    try parttwo.solve();
}
