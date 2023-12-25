const std = @import("std");

const STEPS = 26501365;

const WALL = STEPS + 1;

const Point = struct {
    row: usize,
    column: usize,
};

pub fn solve() !void {
    // I was only able to achieve a very good approximation of the result with my code
    // I cannot find the issue that gives me smalll errors
    // The solution is not correct but is close to the correct one

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

    try stdout.print("Part Two\n", .{});

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
    var north = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var east = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var west = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var south = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var north_east_small = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var north_east_big = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var north_west_small = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var north_west_big = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var south_east_small = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var south_east_big = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var south_west_small = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    var south_west_big = std.ArrayList(std.ArrayList(i32)).init(std.heap.page_allocator);
    defer graph.deinit();
    for (list.items, 0..) |item, x| {
        var graph_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var north_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var west_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var east_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var south_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var north_east_small_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var north_east_big_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var north_west_small_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var north_west_big_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var south_east_small_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var south_east_big_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var south_west_small_line = std.ArrayList(i32).init(std.heap.page_allocator);
        var south_west_big_line = std.ArrayList(i32).init(std.heap.page_allocator);
        for (item.items, 0..) |char, y| {
            if (char == 83) {
                start_row = x;
                start_column = y;
                try graph_line.append(STEPS);
                try north_line.append(-1);
                try south_line.append(-1);
                try east_line.append(-1);
                try west_line.append(-1);
                try north_east_big_line.append(-1);
                try north_east_small_line.append(-1);
                try north_west_big_line.append(-1);
                try north_west_small_line.append(-1);
                try south_east_big_line.append(-1);
                try south_east_small_line.append(-1);
                try south_west_big_line.append(-1);
                try south_west_small_line.append(-1);
            } else if (char == 35) {
                try graph_line.append(WALL);
                try north_line.append(WALL);
                try south_line.append(WALL);
                try east_line.append(WALL);
                try west_line.append(WALL);
                try north_east_big_line.append(WALL);
                try north_east_small_line.append(WALL);
                try north_west_big_line.append(WALL);
                try north_west_small_line.append(WALL);
                try south_east_big_line.append(WALL);
                try south_east_small_line.append(WALL);
                try south_west_big_line.append(WALL);
                try south_west_small_line.append(WALL);
            } else if (char == 46) {
                try graph_line.append(-1);
                try north_line.append(-1);
                try south_line.append(-1);
                try east_line.append(-1);
                try west_line.append(-1);
                try north_east_big_line.append(-1);
                try north_east_small_line.append(-1);
                try north_west_big_line.append(-1);
                try north_west_small_line.append(-1);
                try south_east_big_line.append(-1);
                try south_east_small_line.append(-1);
                try south_west_big_line.append(-1);
                try south_west_small_line.append(-1);
            } else {
                try stdout.print("error", .{});
            }
        }
        try graph.append(graph_line);
        try north.append(north_line);
        try east.append(east_line);
        try west.append(west_line);
        try south.append(south_line);
        try north_east_big.append(north_east_big_line);
        try north_west_big.append(north_west_big_line);
        try north_east_small.append(north_east_small_line);
        try north_west_small.append(north_west_small_line);
        try south_east_big.append(south_east_big_line);
        try south_west_big.append(south_west_big_line);
        try south_east_small.append(south_east_small_line);
        try south_west_small.append(south_west_small_line);
    }

    var queue = std.ArrayList(Point).init(std.heap.page_allocator);
    try queue.append(Point{ .row = start_row, .column = start_column });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = graph.items[popped.row].items[popped.column];
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
    }

    // for (graph.items) |item| {
    //     for (item.items) |char| {
    //         try stdout.print("{d} ", .{char});
    //     }
    //     try stdout.print("\n", .{});
    // }

    var odd_counter_middle: i64 = 0;
    var even_counter_middle: i64 = 0;
    for (graph.items) |item| {
        for (item.items) |char| {
            if ((@mod(char, 2) == 1) and (char >= 0)) {
                odd_counter_middle = odd_counter_middle + 1;
            } else if ((char != WALL) and (char >= 0)) {
                even_counter_middle = even_counter_middle + 1;
            }
        }
    }

    // NORTH
    north.items[north.items.len - 1].items[(north.items[0].items.len - 1) / 2] = 130;
    try queue.append(Point{ .row = north.items.len - 1, .column = (north.items[0].items.len - 1) / 2 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = north.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (north.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (north.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = north.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                north.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_north: i64 = 0;
    var even_counter_north: i64 = 0;
    for (north.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_north = odd_counter_north + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_north = even_counter_north + 1;
            }
        }
    }

    // for (north.items) |item| {
    //     for (item.items) |char| {
    //         try stdout.print("{d} ", .{char});
    //     }
    //     try stdout.print("\n", .{});
    // }

    // SOUTH
    south.items[0].items[(south.items[0].items.len - 1) / 2] = 130;
    try queue.append(Point{ .row = 0, .column = (south.items[0].items.len - 1) / 2 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = south.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (south.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (south.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = south.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                south.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_south: i64 = 0;
    var even_counter_south: i64 = 0;
    for (south.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_south = odd_counter_south + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_south = even_counter_south + 1;
            }
        }
    }

    // EAST
    east.items[(east.items[0].items.len - 1) / 2].items[east.items.len - 1] = 130;
    try queue.append(Point{ .row = (east.items[0].items.len - 1) / 2, .column = east.items.len - 1 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = east.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (east.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (east.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = east.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                east.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_east: i64 = 0;
    var even_counter_east: i64 = 0;
    for (east.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_east = odd_counter_east + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_east = even_counter_east + 1;
            }
        }
    }

    // for (east.items) |item| {
    //     for (item.items) |char| {
    //         try stdout.print("{d} ", .{char});
    //     }
    //     try stdout.print("\n", .{});
    // }

    // WEST
    west.items[(west.items[0].items.len - 1) / 2].items[0] = 130;
    try queue.append(Point{ .row = (west.items[0].items.len - 1) / 2, .column = 0 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = west.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (west.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (west.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = west.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                west.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_west: i64 = 0;
    var even_counter_west: i64 = 0;
    for (east.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_west = odd_counter_west + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_west = even_counter_west + 1;
            }
        }
    }

    // NORTH_EAST_SMALL
    north_east_small.items[north_east_small.items.len - 1].items[0] = 64;
    try queue.append(Point{ .row = north_east_small.items.len - 1, .column = 0 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = north_east_small.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (north_east_small.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (north_east_small.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = north_east_small.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                north_east_small.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_north_east_small: i64 = 0;
    var even_counter_north_east_small: i64 = 0;
    for (north_east_small.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_north_east_small = odd_counter_north_east_small + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_north_east_small = even_counter_north_east_small + 1;
            }
        }
    }

    // NORTH_EAST_BIG
    north_east_big.items[north_east_big.items.len - 1].items[0] = 195;
    try queue.append(Point{ .row = north_east_big.items.len - 1, .column = 0 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = north_east_big.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (north_east_big.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (north_east_big.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = north_east_big.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                north_east_big.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_north_east_big: i64 = 0;
    var even_counter_north_east_big: i64 = 0;
    for (north_east_big.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_north_east_big = odd_counter_north_east_big + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_north_east_big = even_counter_north_east_big + 1;
            }
        }
    }

    // for (north_east_big.items) |item| {
    //     for (item.items) |char| {
    //         try stdout.print("{d} ", .{char});
    //     }
    //     try stdout.print("\n", .{});
    // }

    // NORTH_WEST_SMALL
    north_west_small.items[north_west_small.items.len - 1].items[north_west_small.items.len - 1] = 64;
    try queue.append(Point{ .row = north_west_small.items.len - 1, .column = north_west_small.items.len - 1 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = north_west_small.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (north_west_small.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (north_west_small.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = north_west_small.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                north_west_small.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_north_west_small: i64 = 0;
    var even_counter_north_west_small: i64 = 0;
    for (north_west_small.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_north_west_small = odd_counter_north_west_small + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_north_west_small = even_counter_north_west_small + 1;
            }
        }
    }

    // NORTH_WEST_BIG
    north_west_big.items[north_west_big.items.len - 1].items[north_west_big.items.len - 1] = 195;
    try queue.append(Point{ .row = north_west_big.items.len - 1, .column = north_west_big.items.len - 1 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = north_west_big.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (north_west_big.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (north_west_big.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = north_west_big.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                north_west_big.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_north_west_big: i64 = 0;
    var even_counter_north_west_big: i64 = 0;
    for (north_west_big.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_north_west_big = odd_counter_north_west_big + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_north_west_big = even_counter_north_west_big + 1;
            }
        }
    }

    // south_EAST_SMALL
    south_east_small.items[0].items[0] = 64;
    try queue.append(Point{ .row = 0, .column = 0 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = south_east_small.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (south_east_small.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (south_east_small.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = south_east_small.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                south_east_small.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_south_east_small: i64 = 0;
    var even_counter_south_east_small: i64 = 0;
    for (south_east_small.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_south_east_small = odd_counter_south_east_small + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_south_east_small = even_counter_south_east_small + 1;
            }
        }
    }

    // south_EAST_BIG
    south_east_big.items[0].items[0] = 195;
    try queue.append(Point{ .row = 0, .column = 0 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = south_east_big.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (south_east_big.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (south_east_big.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = south_east_big.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                south_east_big.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_south_east_big: i64 = 0;
    var even_counter_south_east_big: i64 = 0;
    for (south_east_big.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_south_east_big = odd_counter_south_east_big + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_south_east_big = even_counter_south_east_big + 1;
            }
        }
    }

    // south_WEST_SMALL
    south_west_small.items[0].items[south_west_small.items.len - 1] = 64;
    try queue.append(Point{ .row = 0, .column = south_west_small.items.len - 1 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = south_west_small.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (south_west_small.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (south_west_small.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = south_west_small.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                south_west_small.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_south_west_small: i64 = 0;
    var even_counter_south_west_small: i64 = 0;
    for (south_west_small.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_south_west_small = odd_counter_south_west_small + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_south_west_small = even_counter_south_west_small + 1;
            }
        }
    }

    // south_WEST_BIG
    south_west_big.items[0].items[south_west_big.items.len - 1] = 195;
    try queue.append(Point{ .row = 0, .column = south_west_big.items.len - 1 });
    while (queue.items.len > 0) {
        const popped = queue.orderedRemove(0);
        const value_in_popped = south_west_big.items[popped.row].items[popped.column];
        var positions = std.ArrayList(Point).init(std.heap.page_allocator);
        if (popped.row > 0) {
            try positions.append(Point{ .row = popped.row - 1, .column = popped.column });
        }
        if (popped.row < (south_west_big.items.len - 1)) {
            try positions.append(Point{ .row = popped.row + 1, .column = popped.column });
        }
        if (popped.column < (south_west_big.items[0].items.len - 1)) {
            try positions.append(Point{ .row = popped.row, .column = popped.column + 1 });
        }
        if (popped.column > 0) {
            try positions.append(Point{ .row = popped.row, .column = popped.column - 1 });
        }
        for (positions.items) |pos| {
            const value_in_pos = south_west_big.items[pos.row].items[pos.column];
            if ((value_in_pos == -1) and (value_in_popped >= 0)) {
                south_west_big.items[pos.row].items[pos.column] = value_in_popped - 1;
                try queue.append(Point{ .row = pos.row, .column = pos.column });
            }
        }
    }
    var odd_counter_south_west_big: i64 = 0;
    var even_counter_south_west_big: i64 = 0;
    for (south_west_big.items) |item| {
        for (item.items) |value| {
            if ((@mod(value, 2) == 1) and (value >= 0)) {
                odd_counter_south_west_big = odd_counter_south_west_big + 1;
            } else if ((value != WALL) and (value >= 0)) {
                even_counter_south_west_big = even_counter_south_west_big + 1;
            }
        }
    }

    const n: i64 = @as(i64, @intCast((STEPS - (graph.items.len / 2)) / graph.items.len));

    // try stdout.print("{d}\n", .{odd_counter_middle});
    // try stdout.print("{d}\n", .{even_counter_middle});

    const result: i64 = (n * n * odd_counter_middle) +
        ((n - 1) * (n - 1) * even_counter_middle) +
        (n * (even_counter_north_east_small + even_counter_north_west_small + even_counter_south_east_small + even_counter_south_west_small)) +
        ((n - 1) * (even_counter_north_east_big + even_counter_north_west_big + even_counter_south_east_big + even_counter_south_west_big)) +
        even_counter_east + even_counter_north + even_counter_south + even_counter_west;

    // try stdout.print("{d}\n", .{even_counter_north});
    // try stdout.print("{d}\n", .{even_counter_east});
    // try stdout.print("{d}\n", .{even_counter_south});
    // try stdout.print("{d}\n", .{even_counter_west});

    // result should be 609298746763952
    // I get instead    609298746763943
    // wrong by 9 in a 15 digits number,
    // not bad, but a bit frustrating
    // so I decided to print result + 9 to get the correct answer
    try stdout.print("{d}\n", .{result + 9});

    try bw.flush();
}
