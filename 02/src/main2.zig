const std = @import("std");
const allocator = std.heap.page_allocator;

const Colors = enum { red, green, blue };
const NumberByColor = struct { red: usize, green: usize, blue: usize };

fn play_round(str: []const u8) NumberByColor {
    var it = std.mem.split(u8, str, ",");
    var result = NumberByColor{ .red = 0, .green = 0, .blue = 0 };
    while (it.next()) |part| {
        const reveal = std.mem.trim(u8, part, " ");
        var it2 = std.mem.split(u8, reveal, " ");
        const num = std.fmt.parseInt(usize, std.mem.trim(u8, it2.next() orelse @panic("Fail"), " "), 10) catch @panic("Fail");
        const color = std.meta.stringToEnum(Colors, std.mem.trim(u8, it2.next() orelse @panic("Fail"), " ")) orelse @panic("Fail");
        switch (color) {
            .red => if (num > result.red) {
                result.red = num;
            },
            .green => if (num > result.green) {
                result.green = num;
            },
            .blue => if (num > result.blue) {
                result.blue = num;
            },
        }
    }
    return result;
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
        var result = NumberByColor{ .red = 0, .green = 0, .blue = 0 };
        while (it2.next()) |round| {
            const round_result = play_round(std.mem.trim(u8, round, " "));
            if (round_result.red > result.red) {
                result.red = round_result.red;
            }
            if (round_result.green > result.green) {
                result.green = round_result.green;
            }
            if (round_result.blue > result.blue) {
                result.blue = round_result.blue;
            }
        }

        sum += result.red * result.blue * result.green;
        i += 1;
    }
    std.debug.print("{d}\n", .{sum});
}
