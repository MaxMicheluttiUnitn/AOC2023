const std = @import("std");

const WALL = 1_000_001;
const STEPS = 64;

const Point = struct {
    row: usize,
    column: usize,
};

pub fn solve() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // try stdout.print("Run `zig build test` to run the tests.\n", .{});

    var file = try std.fs.cwd().openFile("problem.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var list = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!

    try stdout.print("Part One\n", .{});

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        //try stdout.print("{s}\n", .{line});
        var line_list = std.ArrayList(i32).init(std.heap.page_allocator);
        for (line) |i| {
            try line_list.append(i);
        }
        try list.append(line_list);
    }

    // try stdout.print("{d}\n", .{list.items.len});

    // for (list.items) |item| {
    //     for (item.items) |char| {
    //         try stdout.print("{d} ", .{char});
    //     }
    //     try stdout.print("\n", .{});
    // }

    // try stdout.print("{d}\n", .{list.items[3].items[4]});
    var start_row: usize = 0;
    var start_column: usize = 0;
    var graph = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    defer graph.deinit(); // try commenting this out and see if zig detects the memory leak!
    for (list.items, 0..) |item, x| {
        var graph_line = std.ArrayList(i32).init(std.heap.page_allocator);
        for (item.items, 0..) |char, y| {
            if (char == 83) {
                start_row = x;
                start_column = y;
                try graph_line.append(STEPS);
            } else if (char == 35) {
                try graph_line.append(WALL);
            } else if (char == 46) {
                try graph_line.append(-1);
            } else {
                try stdout.print("error", .{});
            }
        }
        try graph.append(graph_line);
    }

    // for (graph.items) |item| {
    //     for (item.items) |char| {
    //         try stdout.print("{d} ", .{char});
    //     }
    //     try stdout.print("\n", .{});
    // }

    var queue = std.ArrayList(Point).init(std.heap.page_allocator);
    try queue.append(Point{ .row = start_row, .column = start_column });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        // if ((popped.row < 0) or (popped.row >= graph.items.len) or (popped.column < 0) or (popped.column >= graph.items[0].items.len)) {
        //     continue;
        // }
        const value_in_popped = graph.items[popped.row].items[popped.column];
        // try stdout.print("Row: {d}\n", .{popped.row});
        // try stdout.print("Column: {d}\n", .{popped.column});
        // try stdout.print("Value: {d}\n", .{value_in_popped});
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (graph.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (graph.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = graph.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                graph.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
        // for (graph.items) |item| {
        //     for (item.items) |char| {
        //         try stdout.print("{d} ", .{char});
        //     }
        //     try stdout.print("\n", .{});
        // }
    }

    // for (graph.items) |item| {
    //     for (item.items) |char| {
    //         try stdout.print("{d} ", .{char});
    //     }
    //     try stdout.print("\n", .{});
    // }

    var even_counter: i32 = 0;
    for (graph.items) |item| {
        for (item.items) |char| {
            if (@mod(char, 2) == 0) {
                even_counter = even_counter + 1;
            }
        }
    }
    try stdout.print("Places: {d}\n", .{even_counter});
    try bw.flush();
}
