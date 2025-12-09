/*
 * Advent of Code 2025 day 9
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time, std::collections, std::sort, std::math;

alias Vec = long[<2>];

fn long? solve1()
{
	File f = file::open("day9.txt", "rb")!;
	defer (void)f.close();
	List{long} dist;
	List{Vec} tiles;
	dist.tinit(128000);
	tiles.tinit(500);
	while (try line = io::treadline(&f))
	{
		String[] s = line.tsplit(",");
		Vec vec = (Vec){ s[0].to_long(), s[1].to_long() }!;
		foreach (tile : tiles)
		{
			// Calculate the diff
			Vec diff = math::abs(vec - tile) + 1;
			dist.push(diff.product());
		}
		tiles.push(vec);
	}
	// Sort distance
	quicksort(&dist);
	// Return biggest
	return dist[^1];
}

struct Rect
{
	Vec a, b;
	long area;
}

fn bool Rect.less(&self, Rect a)
{
	return self.area < a.area;
}

fn bool inside(Rect r, List{Vec} tiles)
{
	Vec prev = tiles[^1];
	// Test if any tile would invalidate this rect.
	foreach (t : tiles)
	{
		// Is the point inside?
		if (t.comp_gt(r.a).and() && t.comp_lt(r.b).and()) return false;
		Vec max = math::max(t, prev);
		Vec min = math::min(t, prev);
		// Is it crossing from horizontally?
		if (max.x >= r.b.x && min.x <= r.a.x && max.y < r.b.y && min.y > r.a.y) return false;
		// Is it crossing vertically?
		if (max.y >= r.b.y && min.y <= r.a.y && max.x < r.b.x && min.x > r.a.x) return false;
		prev = t;
	}
	return true;
}

fn long? solve2()
{
	File f = file::open("day9.txt", "rb")!;
	defer (void)f.close();
	List{Rect} rects;
	List{Vec} tiles;
	rects.tinit(128000);
	tiles.tinit(500);
	while (try line = io::treadline(&f))
	{
		String[] s = line.tsplit(",");
		Vec vec = (Vec){ s[0].to_long(), s[1].to_long() }!;
		foreach (i, tile : tiles)
		{
			// Store the rect
			Vec diff = math::abs(vec - tile) + 1;
			rects.push({ math::min(tile, vec), math::max(tile, vec), diff.product() });
		}
		tiles.push(vec);
	}
	quicksort(&rects);
	foreach_r (rect : rects)
	{
		// Check if it's inside the total area.
		if (inside(rect, tiles)) return rect.area;
	}
	return 0;
}

fn void main()
{
	io::printn("Advent of code, day 9.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1()!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2()!!, c.mark());
	};
}

