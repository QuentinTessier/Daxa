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

pub const ImplicitFeatureFlags = packed struct(i32) {
    mesh_shader: bool = false,
    basic_ray_tracing: bool = false,
    ray_tracing_pipeline: bool = false,
    ray_tracing_invocation_reorder: bool = false,
    ray_tracing_position_fetch: bool = false,
    conservative_rasterization: bool = false,
    shader_atomic_int64: bool = false,
    image_atomic64: bool = false,
    shader_float16: bool = false,
    shader_int8: bool = false,
    dynamic_state_3: bool = false,
    shader_atomic_float: bool = false,
    swapchain: bool = false,
    shader_int16: bool = false,
    shader_clock: bool = false,
    host_image_copy: bool = false,
    line_rasterization: bool = false,
    __padding: u15 = 0,
};

pub const DeviceInfo2 = extern struct {
    physical_device_index: u32,
    explicit_features: i32,
    max_allowed_images: u32,
    max_allowed_buffers: u32,
    max_allowed_samplers: u32,
    max_allowed_acceleration_structures: u32,
    name: SmallString,

    pub const default: DeviceInfo2 = .{
        .physical_device_index = std.math.maxInt(u32),
        .explicit_features = 1,
        .max_allowed_images = 10000,
        .max_allowed_buffers = 10000,
        .max_allowed_samplers = 400,
        .max_allowed_acceleration_structures = 10000,
        .name = .init(""),
    };
};

pub extern fn daxa_create_instance(*const InstanceInfo, *?*anyopaque) Result;
pub extern fn daxa_instance_choose_device(*anyopaque, ImplicitFeatureFlags, *DeviceInfo2) Result;
pub extern fn daxa_instance_create_device_2(*anyopaque, *const DeviceInfo2, *?*anyopaque) Result;
