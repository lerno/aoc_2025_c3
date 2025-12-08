/*
 * Advent of Code 2025 day 7
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time, std::collections;

fn long? solve1()
{
	File f = file::open("day7.txt", "rb")!;
	defer (void)f.close();
	int total;
	String last = io::treadline(&f)!;
	int timelines = 1;
	while (try line = io::treadline(&f))
	{
		foreach (i, c : last)
		{
			if (c != 'S') continue;
			switch (line[i])
			{
				case '.':
					line[i] = c;
				case '^':
					total++;
					line[i - 1] = 'S';
					line[i + 1] = 'S';
			}
		}
		last = line;
	}
	return total;
}

fn long? solve2()
{
	File f = file::open("day7.txt", "rb")!;
	defer (void)f.close();
	String last = io::treadline(&f)!;
	long[200] vals;
	foreach (i, c : last)
	{
		vals[i] = c == 'S' ? 1 : 0;
	}
	while (try line = io::treadline(&f))
	{
		long[200] temp;
		foreach (i, v : vals)
		{
			if (!v) continue;
			switch (line[i])
			{
				case '.':
					temp[i] += v;
				case '^':
					temp[i - 1] += v;
					temp[i + 1] += v;
			}
		}
		vals = temp;
	}
	long timelines;
	foreach (v : vals) timelines += v;
	return timelines;
}

fn void main()
{
	io::printn("Advent of code, day 7.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1()!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2()!!, c.mark());
	};
}