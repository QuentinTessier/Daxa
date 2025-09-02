const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const vma_dep = b.dependency("vma", .{});
    const vk_headers_dep = b.dependency("vk_headers", .{});
    const vma = b.addLibrary(.{
        .name = "VulkanMemoryAllocator",
        .linkage = .dynamic,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
        }),
    });
    vma.addCSourceFile(.{
        .file = b.path("vk_mem_alloc.cpp"),
        .flags = &.{
            "--std=c++17",
            "-DVMA_STATIC_VULKAN_FUNCTIONS=0",
            "-DVMA_DYNAMIC_VULKAN_FUNCTIONS=1",
        },
    });
    vma.addIncludePath(vma_dep.path("include"));
    vma.addIncludePath(vk_headers_dep.path("include"));

    const daxa = b.addLibrary(
        .{
            .name = "Daxa",
            .version = .{
                .major = 3,
                .minor = 0,
                .patch = 2,
            },
            .linkage = .dynamic,
            .root_module = b.createModule(
                .{
                    .target = target,
                    .optimize = optimize,
                    .link_libc = true,
                    .link_libcpp = true,
                },
            ),
        },
    );
    daxa.addIncludePath(b.path("./include"));
    daxa.addIncludePath(vma_dep.path("./include"));
    daxa.addIncludePath(vk_headers_dep.path("./include"));
    daxa.linkSystemLibrary("vulkan");

    const src_dir = "src/";
    daxa.addCSourceFiles(.{ .files = &.{
        src_dir ++ "cpp_wrapper.cpp",
        src_dir ++ "impl_device.cpp",
        src_dir ++ "impl_features.cpp",
        src_dir ++ "impl_instance.cpp",
        src_dir ++ "impl_core.cpp",
        src_dir ++ "impl_pipeline.cpp",
        src_dir ++ "impl_swapchain.cpp",
        src_dir ++ "impl_command_recorder.cpp",
        src_dir ++ "impl_gpu_resources.cpp",
        src_dir ++ "impl_sync.cpp",
        src_dir ++ "impl_dependencies.cpp",
        src_dir ++ "impl_timeline_query.cpp",
    }, .language = .cpp, .flags = &.{
        "-std=c++20",
        "-DDAXA_CMAKE_EXPORT=",
        "-DAXA_BUILT_WITH_WAYLAND=1",
    } });

    b.installArtifact(daxa);
}
