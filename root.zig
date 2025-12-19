const std = @import("std");
const zdaxa = @import("zdaxa");

pub fn main() !void {
    std.log.info("Hello Daxa !", .{});
    var instance: ?*anyopaque = null;
    const info: zdaxa.InstanceInfo = .default_instance_info;
    switch (zdaxa.daxa_create_instance(&info, &instance)) {
        .Success => std.log.info("Success", .{}),
        _ => |value| std.log.err("Failed {}", .{@intFromEnum(value)}),
    }
}
