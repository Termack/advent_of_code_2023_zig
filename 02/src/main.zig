const std = @import("std");
const allocator = std.heap.page_allocator;

const Colors = enum { red, green, blue };

fn play_round(str: []const u8) bool {
    var it = std.mem.split(u8, str, ",");
    while (it.next()) |part| {
        const reveal = std.mem.trim(u8, part, " ");
        var it2 = std.mem.split(u8, reveal, " ");
        const num = std.fmt.parseInt(usize, std.mem.trim(u8, it2.next() orelse @panic("Fail"), " "), 10) catch @panic("Fail");
        const color = std.meta.stringToEnum(Colors, std.mem.trim(u8, it2.next() orelse @panic("Fail"), " ")) orelse @panic("Fail");
        const max_size: i32 = switch (color) {
            .red => 12,
            .green => 13,
            .blue => 14,
        };
        if (num > max_size) {
            return false;
        }
    }
    return true;
}

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var sum: usize = 0;
    var i: usize = 1;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, ":");
        const bla = it.next();
        _ = bla;
        var it2 = std.mem.split(u8, it.next() orelse @panic("Fail"), ";");
        var result = false;
        while (it2.next()) |round| {
            result = play_round(std.mem.trim(u8, round, " "));
            if (result == false) {
                break;
            }
        }
        if (result == true) {
            sum += i;
        }
        i += 1;
    }
    std.debug.print("{d}\n", .{sum});
}
