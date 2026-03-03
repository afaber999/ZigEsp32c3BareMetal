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
    Sample.init("interrupt", "examples/interrupt/interrupt.zig", "src/link.ld", null),
    Sample.init("main", "examples/main.zig", "src/link.ld", null),
    Sample.init("uart_echo", "examples/uart_echo.zig", "src/link.ld", null),
    Sample.init("logger", "examples/logger.zig", "src/link.ld", null),
    Sample.init("panic", "examples/panic.zig", "src/link.ld", null),
    Sample.init("sysinfo", "examples/sysinfo.zig", "src/link.ld", null),
    Sample.init("monitor", "examples/monitor.zig", "src/link.ld", null),
    Sample.init("asm", "examples/asm/asm.zig", "src/link.ld", "examples/asm/asm.S"),
    Sample.init("systimer", "examples/systimer.zig", "src/link.ld", null),
    Sample.init("shell", "examples/shell/main.zig", "src/link.ld", null),
    Sample.init("ledc", "examples/ledc.zig", "src/link.ld", null),
    Sample.init("timer0", "examples/timer0.zig", "src/link.ld", null),
    Sample.init("clocks", "examples/clocks.zig", "src/link.ld", null),
};

pub fn build(b: *std.Build) void {
    const clean_step = b.step("clean", "Remove build artifacts");
    const clean_out = b.addRemoveDirTree(.{ .cwd_relative = "zig-out" });
    clean_step.dependOn(&clean_out.step);

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

    const rv32ModuleName = "rv32";
    const rv32Module = b.addModule(rv32ModuleName, .{ .root_source_file = b.path("src/rv32.zig") });
    rv32Module.addCSourceFile(.{ .file = b.path("./src/rv32.S"), .flags = cflags });

    const objcopy_candidates = [_][]const u8{
        "riscv64-unknown-elf-objcopy",
        "riscv32-unknown-elf-objcopy",
        "riscv32-esp-elf-objcopy",
        "objcopy",
    };
    const objcopy_search_paths = [_][]const u8{
        "C:/msys64/mingw64/bin",
        "C:/msys64/ucrt64/bin",
        "C:/msys64/usr/bin",
        "/mingw64/bin",
        "/ucrt64/bin",
        "/usr/bin",
    };

    var gnu_objcopy: ?[]const u8 = null;
    for (objcopy_candidates) |program_name| {
        gnu_objcopy = b.findProgram(&.{program_name}, &objcopy_search_paths) catch null;
        if (gnu_objcopy != null) break;
    }

    var warned_objcopy_missing = false;

    inline for (Examples) |example| {
        const firmware = b.addExecutable(.{
            .name = example.name ++ ".elf",
            .root_module = b.createModule(.{
                .root_source_file = b.path(example.zig_file),
                .target = target,
                .optimize = .ReleaseSafe,
                //.optimize = .ReleaseSmall,
            }),
        });

        //firmware.root_module.strip = false;
        firmware.root_module.strip = false;
        firmware.root_module.addImport(rv32ModuleName, rv32Module);

        firmware.setVerboseLink(false);

        if (example.asm_file) |asm_file| {
            firmware.addCSourceFile(.{ .file = b.path(asm_file), .flags = cflags });
        }

        //firmware.addIncludePath(b.path("./src"));
        firmware.setLinkerScript(b.path(example.link_file));

        b.installArtifact(firmware);

        // Copy the bin out of the elf, OBJ copy in zig 0.15 is broken, so we use objcopy directly
        // const bin = b.addObjCopy(firmware.getEmittedBin(), .{
        //     .format = .bin,
        // });
        // bin.step.dependOn(&firmware.step);
        // Copy the bin to the output directory
        // const copy_bin = b.addInstallBinFile(bin.getOutput(), example.name ++ ".bin");
        // b.default_step.dependOn(&copy_bin.step);

        // Use GNU objcopy to create .bin files (avoids objcopy issues in zig 0.15)
        if (gnu_objcopy) |objcopy_path| {
            const bin_filename = b.fmt("{s}.bin", .{example.name});
            const objcopy_run = b.addSystemCommand(&.{objcopy_path});
            objcopy_run.addArgs(&.{ "-O", "binary" });
            objcopy_run.addFileArg(firmware.getEmittedBin());
            const bin_output = objcopy_run.addOutputFileArg(bin_filename);
            b.getInstallStep().dependOn(&b.addInstallFileWithDir(
                bin_output,
                .{ .custom = "bin" },
                bin_filename,
            ).step);
        } else if (!warned_objcopy_missing) {
            std.log.warn("GNU objcopy not found (tried: riscv64-unknown-elf-objcopy, riscv32-unknown-elf-objcopy, riscv32-esp-elf-objcopy, objcopy); skipping .bin generation", .{});
            warned_objcopy_missing = true;
        }

        const flash_cmd_script = switch (builtin.os.tag) {
            .windows => "./flash.cmd",
            else => "./flash.sh",
        };

        // add run/flash step for each sampleFflash
        const flash_cmd = b.addSystemCommand(&[_][]const u8{
            flash_cmd_script,
            example.name,
        });

        flash_cmd.step.dependOn(b.getInstallStep());
        const flash_step = b.step("flash_" ++ example.name, "Flash the firmware");
        flash_step.dependOn(&flash_cmd.step);
    }
}
