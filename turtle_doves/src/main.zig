const std = @import("std");
const FileRead = std.fs.FileRead;

const INPUT_FILE = "input.txt";
const FILE_BUFFER_SIZE = 1024;
const MAX_DIGITS = 20;

pub fn main() !void {
    const file = try std.fs.cwd().openFile(INPUT_FILE, .{});
    defer file.close();

    var file_buffer = [_]u8{0} ** FILE_BUFFER_SIZE;
    const bytes_read = try file.read(&file_buffer);
    var comma_separated = std.mem.splitScalar(u8, file_buffer[0 .. bytes_read - 1], ',');

    var total: usize = 0;
    while (comma_separated.next()) |slice| {
        var bounds = std.mem.splitScalar(u8, slice, '-');

        const start = try std.fmt.parseInt(usize, bounds.next().?, 10);
        const end = try std.fmt.parseInt(usize, bounds.next().?, 10);
        for (start..end + 1) |i| {
            const result = check_symmetry(i);
            if (result) |number| {
                total += number;
            }
        }
    }
    std.debug.print("{d}\n", .{total});
}

fn check_symmetry(number: usize) ?usize {
    var buffer = [_]u8{0} ** MAX_DIGITS;

    const number_str = std.fmt.bufPrint(&buffer, "{d}", .{number}) catch {
        std.debug.print("Bad number in '{s}': {d}", .{INPUT_FILE, number});
        @panic("Terminating...");
    };

    const digits = number_str.len;
    if (digits % 2 != 0) {
        return null;
    }

    const front_half = number_str[0 .. digits / 2];
    const back_half = number_str[digits / 2 .. digits];

    for (front_half, back_half) |f, b| {
        if (f != b) {
            return null;
        }
    }

    return number;
}
