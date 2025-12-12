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
            const result = check_for_repeating_sequence(i);
            if (result) |number| {
                total += number;
            }
        }
    }
    std.debug.print("{d}\n", .{total});
}

fn check_for_repeating_sequence(number: usize) ?usize {
    var buffer = [_]u8{0} ** MAX_DIGITS;
    const number_str = usize_to_buffer(&buffer, number);
    const digits = number_str.len;

    if (digits == 1) {
        return null;
    }

    const upper_bound = @divFloor(digits, 2);
    for (1..upper_bound+1) |n| {
        if (digits % n == 0 and check_for_n_sequence(number_str, n)) {
            return number;
        }
    }
    return null;
}

fn check_for_n_sequence(number_str: []u8, n: usize) bool {
    for (number_str[0..number_str.len - n], number_str[n..]) |i, j| {
        if (i != j) {
            return false;
        }
    }
    return true;
}

fn check_symmetry(number: usize) ?usize {
    var buffer = [_]u8{0} ** MAX_DIGITS;
    const number_str = usize_to_buffer(&buffer, number);
    const digits = number_str.len;

    if (digits % 2 != 0) {
        return null;
    }

    if (check_for_n_sequence(number_str, digits / 2)) {
        return number;
    }
    return null;
}

fn usize_to_buffer(buffer: []u8, number: usize) []u8 {
    return std.fmt.bufPrint(buffer, "{d}", .{number}) catch {
        std.debug.print("Bad number in '{s}': {d}", .{INPUT_FILE, number});
        @panic("Terminating...");
    };
}
