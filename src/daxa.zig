const std = @import("std");

pub const NativeWindowHandle = *anyopaque;

pub const NativeWindowPlatform = enum(i32) {
    UNKNOWN,
    WIN32_API,
    XLIB_API,
    WAYLAND_API,
};

pub fn FixedList(comptime T: type, comptime Capacity: usize) type {
    return extern struct {
        data: [Capacity]T,
        size: u8,

        pub fn init(data: []const T) @This() {
            std.debug.assert(data.len <= Capacity);

            var self: @This() = undefined;
            @memset(&self.data, 0);
            @memcpy(self.data[0..data.len], data);
            self.size = @intCast(data.len);
            return self;
        }
    };
}

pub const SmallString = FixedList(u8, 63);

pub const Result = enum(i32) {
    Success = 0,
    _,
};

pub const InstanceFlags = packed struct(i32) {
    debug_util: bool = false,
    parent_must_outlive_child: bool = false,
    __padding: u30 = 0,
};

pub const InstanceInfo = extern struct {
    flags: InstanceFlags,
    engine_name: SmallString,
    app_name: SmallString,

    pub const default_instance_info: InstanceInfo = .{
        .flags = .{ .debug_util = true },
        .engine_name = .init("daxa"),
        .app_name = .init("daxa app"),
    };
};

pub extern fn daxa_create_instance(*const InstanceInfo, *?*anyopaque) Result;
