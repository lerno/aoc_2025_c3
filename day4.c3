/*
 * Advent of Code 2025 day 4
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time;

bool[150][150] map;
alias MapData = Slice2d{bool};

const isz[<2>][8] DIRS = { { 1, 1 }, { 0, 1 }, { -1, 1 }, { 1, 0 }, { -1, 0 }, { 1, -1 }, { 0, -1 }, { -1, -1} };
int[150][150] neighbour_count;

// First just load the map. Here we just keep an overdimensioned map.
fn MapData load_map() => @pool()
{
	File f = file::open("day4.txt", "rb")!!;
	defer (void)f.close();
	int row_len;
	int row;
	while (try line = io::treadline(&f))
	{
		row_len = line.len;
		foreach (x, c : line) if (c == '@') map[row][x] = true;
		row++;
	}
	// Use a 2d slice
	return array::slice2d(array_ptr: &map, xlen: row_len, ylen: row);
}

fn void calculate_neighbours(MapData data)
{
	neighbour_count = {};
	data.@each(;usz[<2>] pos, bool value)
	{
		if (value)
		{
			// Update the neighbour count around it
			foreach (dir : DIRS)
			{
				isz[<2>] inc_pos = (isz[<2>])pos + dir;
				if (inc_pos.min() < 0) continue;
				neighbour_count[inc_pos.y][inc_pos.x]++;
			}
		}

	};
}
fn int solve1(MapData data)
{
	calculate_neighbours(data);

	// Now just walk through everything, summing the
	// number that has 3 or fewer neighbours
	int total;
	data.@each(;usz[<2>] pos, bool value)
	{
		if (value && neighbour_count[pos.y][pos.x] < 4) total++;
	};
	return total;;
}

fn int solve2(MapData data)
{
	calculate_neighbours(data);

	int total;
	bool removed @noinit;
	do
	{
		removed = false;
		data.@each(;usz[<2>] pos, bool value)
		{
			if (value && neighbour_count[pos.y][pos.x] < 4)
			{
				// Don't remove this one again
				neighbour_count[pos.y][pos.x] = int.max;

				// Decrease the neighbourhood count.
				foreach (dir : DIRS)
				{
					isz[<2>] dec_pos = (isz[<2>])pos + dir;
					if (dec_pos.min() < 0) continue; // Just avoid going to negative x,y
					neighbour_count[dec_pos.y][dec_pos.x]--;
				}
				// Add to total
				removed = true;
				total++;
			}
		};
	} while (removed); // Repeat while things are removed
	return total;
}

fn void main()
{
	io::printn("Advent of code, day 4.");
	MapData map = load_map();
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1(map), c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2(map), c.mark());
	};
}