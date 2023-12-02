const std = @import("std");
const allocator = std.heap.page_allocator;

const Case = enum { one, two, three, four, five, six, seven, eight, nine };

fn convert_number(str: []u8, size: u8) ?Case {
    if (str.len < size) {
        return null;
    }
    const case = std.meta.stringToEnum(Case, str[0..size]) orelse return null;
    return case;
}

fn check_digit(str: []u8) ?u8 {
    var digit: ?u8 = null;
    const c = str[0];
    digit = switch (c) {
        '0'...'9' => c - '0',
        else => null,
    };
    if (digit != null) {
        return digit;
    }

    const case = convert_number(str, 3) orelse convert_number(str, 4) orelse convert_number(str, 5) orelse return null;
    digit = switch (case) {
        .one => 1,
        .two => 2,
        .three => 3,
        .four => 4,
        .five => 5,
        .six => 6,
        .seven => 7,
        .eight => 8,
        .nine => 9,
    };
    return digit;
}

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
            const str = line[i..];
            const integer = check_digit(str) orelse continue;
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
