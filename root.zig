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

    const device = blk: {
        var device_info: zdaxa.DeviceInfo2 = .default;
        device_info.name = .init("default device");

        const implicit_features: zdaxa.ImplicitFeatureFlags = .{};
        switch (zdaxa.daxa_instance_choose_device(instance.?, implicit_features, &device_info)) {
            .Success => std.log.info("Success", .{}),
            _ => |value| std.log.err("Failed {}", .{@intFromEnum(value)}),
        }

        var device: ?*anyopaque = null;
        switch (zdaxa.daxa_instance_create_device_2(instance.?, &device_info, &device)) {
            .Success => std.log.info("Success", .{}),
            _ => |value| std.log.err("Failed {}", .{@intFromEnum(value)}),
        }

        break :blk device;
    };
    _ = device;
}
