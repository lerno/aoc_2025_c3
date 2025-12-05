/*
 * Advent of Code 2025 day 5
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time, std::collections;

fn int? solve1()
{
	File f = file::open("day5.txt", "rb")!!;
	defer (void)f.close();
	List{long[<2>]} list;
	while (String line = io::treadline(&f)!, line.len > 0)
	{
		String[] split = line.tsplit("-", 2);
		list.push({split[0].to_long()!, split[1].to_long()!});
	}
	int total;
	while (try line = io::treadline(&f))
	{
		long val = line.to_long()!;
		foreach (limits : list)
		{
			if (val >= limits.x && val <= limits.y)
			{
				total++;
				break;
			}
		}
	}
	return total;
}

fn void merge_ranges(List{long[<2>]}* list)
{
	foreach (i, limit : *list)
	{
		foreach (j, limit2 : list.array_view()[i + 1..])
		{
			// Overlap?
			if (limit.y < limit2.x || limit.x > limit2.y) continue;
			// Overlap, update the forward list
			list.[i + j + 1] = { min(limit.x, limit2.x), max(limit.y, limit2.y) };
			// "Delete" the current element
			list.[i] = { -1, -2 };
			break;
		}
	}
}

fn long? solve2()
{
	File f = file::open("day5.txt", "rb")!!;
	defer (void)f.close();
	List{long[<2>]} list;
	while (String line = io::treadline(&f)!, line.len > 0)
	{
		String[] split = line.tsplit("-", 2);
		list.push({split[0].to_long()!, split[1].to_long()!});
	}
	merge_ranges(&list);
	long total;
	foreach (limits : list)
	{
		total += limits.y - limits.x + 1;
	}
	return total;
}


fn void main()
{
	io::printn("Advent of code, day 5.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1()!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2()!!, c.mark());
	};
}