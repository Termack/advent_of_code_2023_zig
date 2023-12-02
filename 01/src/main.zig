const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var sum: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var i: usize = 0;
        var first: ?u8 = null;
        var last: u8 = 0;
        while (i < line.len) : (i += 1) {
            const c = line[i];
            const char = try std.fmt.allocPrint(
                allocator,
                "{c}",
                .{c},
            );
            const integer = std.fmt.parseInt(u8, char, 10) catch {
                continue;
            };
            allocator.free(char);
            if (first == null) {
                first = integer;
            }
            last = integer;
        }
        const integer_string = try std.fmt.allocPrint(
            allocator,
            "{?d}{d}",
            .{ first, last },
        );
        const integer = try std.fmt.parseInt(usize, integer_string, 10);
        allocator.free(integer_string);
        sum += integer;
    }
    std.debug.print("{d}\n", .{sum});
}
