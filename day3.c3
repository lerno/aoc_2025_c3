/*
 * Advent of Code 2025 day 3
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time;

fn int[2] max_found(String s)
{
	int max = s[0];
	int pos;
	foreach (int i, c : s[1..])
	{
		if (c > max)
		{
			max = c;
			pos = i + 1;
		}
	}
	return { max, pos };
}

fn long? solve1()
{
	int total;
	File f = file::open("day3.txt", "rb")!;
    defer (void)f.close();
    while (try line = io::treadline(&f))
    {
        int[2] res = max_found(line[:^1]);
        int[2] res2 = max_found(line[res[1] + 1..]);
        total += (res[0] - '0') * 10 + res2[0] - '0';
    }
	return total;
}

fn long? solve2()
{
	long total;
	File f = file::open("day3.txt", "rb")!;
    defer (void)f.close();
    while (try line = io::treadline(&f))
    {
        int[2] res = max_found(line[:^11]);
        long val = (long)res[0] - '0';
        int pos = res[1];
        for (int i = 11; i > 0; i--)
        {
            line = line[pos + 1..];
	        res = max_found(line[..^i]);
            pos = res[1];
            val = val * 10 + (long)res[0] - '0';
        }
        total += val;
    }
	return total;
}

fn void main()
{
	io::printn("Advent of code, day 3.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1()!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2()!!, c.mark());
	};
}