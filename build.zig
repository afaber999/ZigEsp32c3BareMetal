const std = @import("std");
const CrossTarget = @import("std").zig.CrossTarget;
const Target = @import("std").Target;
const Feature = @import("std").Target.Cpu.Feature;
const builtin = @import("builtin");

const Sample = struct {
    name: []const u8,
    zig_file: []const u8,
    link_file: []const u8,
    asm_file: ?[]const u8,

    pub fn init(name: []const u8, zig_file: []const u8, link_file: []const u8, asm_file: ?[]const u8) Sample {
        return Sample{ .name = name, .zig_file = zig_file, .link_file = link_file, .asm_file = asm_file };
    }
};

const Examples = [_]Sample{
    Sample.init("blink", "examples/blink.zig", "src/link.ld", null),
    Sample.init("gpio", "examples/gpio.zig", "src/link.ld", null),
    Sample.init("interrupt", "examples/interrupt/interrupt.zig", "src/link.ld", "examples/interrupt/interrupt.S"),
    Sample.init("main", "examples/main.zig", "src/link.ld", null),
    Sample.init("uart_echo", "examples/uart_echo.zig", "src/link.ld", null),
    Sample.init("logger", "examples/logger.zig", "src/link.ld", null),
    Sample.init("panic", "examples/panic.zig", "src/link.ld", null),
    Sample.init("sysinfo", "examples/sysinfo.zig", "src/link.ld", null),
    Sample.init("monitor", "examples/monitor.zig", "src/link.ld", null),
    Sample.init("asm", "examples/asm/asm.zig", "src/link.ld", "examples/asm/asm.S"),
    Sample.init("systimer", "examples/systimer.zig", "src/link.ld", null),
    Sample.init("shell", "examples/shell/main.zig", "src/link.ld", null),
};

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

    const cflags = &[_][]const u8{
        "-Wall",
        "-Werror",
        "-Wno-gnu-designator",
        "-Wno-unused-variable",
        "-Wno-unused-but-set-variable",
        "-O3",
        "-I./",
        "-mno-relax",
        "-fno-pie",
        "-fno-stack-protector",
        "-fno-common",
        "-fno-omit-frame-pointer",
    };

    const c3ModuleName = "c3";
    const c3Module = b.addModule(c3ModuleName, .{ .root_source_file = b.path("src/c3.zig") });
    c3Module.addCSourceFile(.{ .file = b.path("./src/c3.S"), .flags = cflags });


    inline for (Examples) |example| {
        const firmware = b.addExecutable(.{
            .name = example.name ++ ".elf",
            .root_source_file = b.path(example.zig_file),
            .target = target,
            .optimize = .ReleaseSafe,
            //.optimize = .ReleaseSmall,
        });

        //firmware.root_module.strip = false;
        firmware.root_module.strip = false;
        firmware.root_module.addImport(c3ModuleName, c3Module);

        firmware.setVerboseLink(true);

        if (example.asm_file) |asm_file| {
            firmware.addCSourceFile(.{ .file = b.path(asm_file), .flags = cflags });
        }

        //firmware.addIncludePath(b.path("./src"));
        firmware.setLinkerScriptPath(b.path(example.link_file));

        b.installArtifact(firmware);

        // Copy the bin out of the elf
        const bin = b.addObjCopy(firmware.getEmittedBin(), .{
            .format = .bin,
        });
        bin.step.dependOn(&firmware.step);

        // Copy the bin to the output directory
        const copy_bin = b.addInstallBinFile(bin.getOutput(), example.name ++ ".bin");
        b.default_step.dependOn(&copy_bin.step);

        const flash_cmd_script = switch (builtin.os.tag) {
            .windows => "./flash.cmd",
            else => "./flash.sh",
        };

        // add run/flash step for each sample
        const flash_cmd = b.addSystemCommand(&[_][]const u8{
            flash_cmd_script,
            example.name,
        });

        flash_cmd.step.dependOn(b.getInstallStep());
        const flash_step = b.step("flash_" ++ example.name, "Flash the firmware");
        flash_step.dependOn(&flash_cmd.step);
    }
}
