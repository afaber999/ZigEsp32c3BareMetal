const std = @import("std");
const CrossTarget = @import("std").zig.CrossTarget;
const Target = @import("std").Target;
const Feature = @import("std").Target.Cpu.Feature;

fn getTarget(b: *std.Build) std.Build.ResolvedTarget {
    return b.resolveTargetQuery(.{
        .cpu_arch = std.Target.Cpu.Arch.riscv32,
        .ofmt = std.Target.ObjectFormat.elf,
        .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
        .cpu_features_add = std.Target.riscv.featureSet(&.{
            std.Target.riscv.Feature.c,
            std.Target.riscv.Feature.m,
        }),
        .abi = std.Target.Abi.eabi,
        .os_tag = std.Target.Os.Tag.freestanding,
    });
}

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

    const exe = b.addExecutable(.{
        .name = "zfirmware.elf",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = .ReleaseSmall,
    });

    //const target = getTarget(b);
    // const target = .{
    //     .cpu_arch = .riscv32,
    //     .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 }, // RV32I
    //     .os_tag = .freestanding,
    //     .abi = .eabi,
    // };

    // const optimize = b.standardOptimizeOption(.{});

    // const exe = b.addExecutable(.{
    //     .name = "zfirmware.elf",
    //     .root_source_file = b.path("main.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });

    //const cflags = .{ "-Os", "-march=rv32imc", "-mabi=ilp32" };
    exe.setVerboseLink(true);
    exe.addIncludePath(b.path("./src"));
    //exe.addCSourceFile(.{ .file = b.path("c3dk.c"), .flags = &cflags });
    //exe.entry = .{ .symbol_name = "_reset" };
    exe.setLinkerScriptPath(b.path("src/link.ld"));
    b.installArtifact(exe);

    // add run step for each sample
    const mkbin_cmd = b.addSystemCommand(&[_][]const u8{
        "esptool.exe",
        // "--chip esp32c3",
        // "--flash_mode dio",
        // "--flash_freq 80m --flash_size 4MB",
        // "elf2image",
        // "./zig-out/bin/zfirmware.elf",
    });
    mkbin_cmd.addArg("elf2image");
    mkbin_cmd.addArg("./zig-out/bin/zfirmware.elf");
    mkbin_cmd.addArg("--chip");
    mkbin_cmd.addArg("esp32c3");
    //mkbin_cmd.addArg("--chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/zfirmware.elf");

    //esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/zfirmware.elf

    mkbin_cmd.step.dependOn(b.getInstallStep());
    // mkbin_cmd.addArg("--flash_mode dio");
    // mkbin_cmd.addArg("--flash_freq 80m");
    // mkbin_cmd.addArg("--flash_size 4MB");
    // mkbin_cmd.addArg("./zig-out/bin/zfirmware.elf");
    const mkbin_step = b.step("mkbin", "Make bin the firmware");
    mkbin_step.dependOn(&mkbin_cmd.step);

    const flash_cmd = b.addSystemCommand(&.{
        "esptool.py",
        "--chip",
        "esp32c3",
        "--port",
        "/dev/ttyUSB0",
        "write_flash",
        "--flash_mode",
        "dio",
        "0x0",
    });
    // add run step for each sample
    // const flash_cmd = b.addSystemCommand(&[_][]const u8{
    //     "esptool.exe",
    // });
    //flash_cmd.step.dependOn(mkbin_step);
    // flash_cmd.addArg("write_flash");
    // flash_cmd.addArg("0");
    // flash_cmd.addArg("./zig-out/bin/zfirmware.bin");
    const flash_step = b.step("flash", "Flash the firmware");
    flash_step.dependOn(&flash_cmd.step);
}
