/*
 * Advent of Code 2025 day 2
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time, std::collections;

faultdef IMPOSSIBLE;

alias LongSet = HashSet{long};
const long[*] POWERS_OF_TEN = {
	1, 10, 100, 1000, 10000, 100000,
	1000000, 10000000, 100000000, 1000000000,
	10000000000L, 100000000000L, 1000000000000L, 10000000000000L
};


fn long? repeats(String s, int repeats, bool high)
{
	int pieces = s.len / repeats;
	// If not even divisible or just one repeat, return fault.
	if (s.len % repeats || pieces < 2) return IMPOSSIBLE?;

	// Get the repeating part
	String part = s[:repeats];
	long val = part.to_long()!;

	// Let's check if the remainder is higher or lower, this takes into account multiple matches.
	char* ptr = &s[repeats];
	for (int i = 1; i < pieces; i++)
	{
		foreach (j, c : part)
		{
			switch
			{
				case *ptr < c: return high ? val - 1 : val;
				case *ptr > c: return high ? val : val + 1;
			}
			ptr++;
		}
	}
	return val;
}

// Generate the result
fn long value_for_interval(long low, long high, usz len, int repeats, bool exactly_twice, LongSet* set)
{
	int copy = (int)len / repeats;
	// If this is a match with more than 2, and we're expecting a single match then exit.
	if (exactly_twice && copy > 2) return 0;

	// Create the number
	long mult = POWERS_OF_TEN[repeats];
	long tot;
	for (long j = low; j <= high; j++)
	{
		long sum = j;
		for (int i = 1; i < copy; i++)
		{
			sum = mult * sum + j;
		}
		// Add once, in the case when we might match more than once.
		if (set.add(sum)) tot += sum;
	}
	return tot;
}
fn long? count(String first, String last, bool exactly_twice, LongSet* set)
{
	long total;
	set.clear();
	// Walk through all possibilities
	for (int i = 1; i <= last.len / 2; i++)
	{
		// 1314 -> 12 1312 -> 13
		long? low = repeats(first, i, false);
		// 1314 -> 13 1312 -> 12
		long? high = repeats(last, i, true);
		// Same length is the easy case
		if (first.len == last.len)
		{
			if (catch low, high) continue;
			if (high < low) continue;
			total += value_for_interval(low, high, first.len, i, exactly_twice, set);
			continue;
		}
		// Different length, so compare with lowest / highest in the interval.
		if (try low)
		{
			total += value_for_interval(low, POWERS_OF_TEN[i] - 1, first.len, i, exactly_twice, set);
		}
		if (try high)
		{
			total += value_for_interval(POWERS_OF_TEN[i - 1], high, last.len, i, exactly_twice, set);
		}
	}
	return total;
}

fn long? solve(bool exactly_twice)
{
	long total;
	String data = (String)file::load_temp("day2.txt")!;
	Splitter s = data.tokenize(",");
	LongSet set;
	set.tinit();
	while (try part = s.next())
	{
		String[] parts = part.trim().tsplit("-");
		total += count(parts[0], parts[1], exactly_twice, &set)!;
	}
	return total;
}

fn void main()
{
	io::printn("Advent of code, day 2.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve(true)!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve(false)!!, c.mark());
	};
}