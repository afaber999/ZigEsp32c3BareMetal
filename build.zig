const std = @import("std");
const CrossTarget = @import("std").zig.CrossTarget;
const Target = @import("std").Target;
const Feature = @import("std").Target.Cpu.Feature;

pub fn build(b: *std.Build) void {
    const features = Target.riscv.Feature;
    var disabled_features = Feature.Set.empty;
    var enabled_features = Feature.Set.empty;

    // disable all CPU extensions
    disabled_features.addFeature(@intFromEnum(features.a));
    disabled_features.addFeature(@intFromEnum(features.c));
    disabled_features.addFeature(@intFromEnum(features.d));
    disabled_features.addFeature(@intFromEnum(features.e));
    disabled_features.addFeature(@intFromEnum(features.f));
    // except multiply
    enabled_features.addFeature(@intFromEnum(features.m));

    const target = b.resolveTargetQuery(.{ .cpu_arch = Target.Cpu.Arch.riscv32, .os_tag = Target.Os.Tag.freestanding, .abi = Target.Abi.none, .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 }, .cpu_features_sub = disabled_features, .cpu_features_add = enabled_features });

    const c3ModuleName = "c3";
    const c3Module = b.addModule(c3ModuleName, .{ .root_source_file = b.path("src/c3.zig") });

    const Examples = [_][]const u8{ "blink", "main", "uart_echo", "logger", "panic", "sysinfo", "monitor" };

    inline for (Examples) |exampleName| {
        const example = b.addExecutable(.{
            .name = exampleName ++ ".elf",
            .root_source_file = b.path("examples/" ++ exampleName ++ ".zig"),
            .target = target,
            .optimize = .ReleaseSafe,
            //.optimize = .ReleaseSmall,
        });

        //example.root_module.strip = false;
        example.root_module.strip = false;
        example.root_module.addImport(c3ModuleName, c3Module);

        example.setVerboseLink(true);
        example.addIncludePath(b.path("./src"));
        example.setLinkerScriptPath(b.path("src/link.ld"));

        b.installArtifact(example);

        // Copy the bin out of the elf
        const bin = b.addObjCopy(example.getEmittedBin(), .{
            .format = .bin,
        });
        bin.step.dependOn(&example.step);

        // Copy the bin to the output directory
        const copy_bin = b.addInstallBinFile(bin.getOutput(), exampleName ++ ".bin");
        b.default_step.dependOn(&copy_bin.step);

        // add run/flash step for each sample
        const flash_cmd = b.addSystemCommand(&[_][]const u8{
            "flash.cmd",
            exampleName,
        });

        flash_cmd.step.dependOn(b.getInstallStep());
        const flash_step = b.step("flash_" ++ exampleName, "Flash the firmware");
        flash_step.dependOn(&flash_cmd.step);
    }
}
