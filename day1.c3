/*
 * Advent of Code 2025 day 1
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time;

fn int? solve1()
{
	int zero;
	File f = file::open("day1.txt", "rb")!;
	defer (void)f.close();
	int val = 50;
	while (try line = io::treadline(&f))
	{
		int amount = line[1..].to_int()!;
		switch (line[0])
		{
			case 'L': val = (val + 100 - amount) % 100;
			case 'R': val = (val + amount) % 100;
		}
		if (val == 0) zero++;
	}
	return zero;
}

fn int? solve2()
{
	int zero;
	File f = file::open("day1.txt", "rb")!;
	defer (void)f.close();
	int val = 50;
	while (try line = io::treadline(&f))
	{
		int amount = line[1..].to_int()!;
		// Handle the amount >= 100 case
		zero += amount / 100;
		// Reduce to 0-99
		amount %= 100;
		switch (line[0])
		{
			case 'L':
				int new = (val + 100 - amount) % 100;
				// Handle underflow non-zero
				if (new > val && val != 0) zero++;
				val = new;
			case 'R':
				int new = (val + amount) % 100;
				// Handle overflow non-zero
				if (new < val && new != 0) zero++;
				val = new;
		}
		// Increase if exactly at zero.
		if (!val) zero++;
	}
	return zero;
}

fn void main()
{
	io::printn("Advent of code, day 1.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1()!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2()!!, c.mark());
	};
}