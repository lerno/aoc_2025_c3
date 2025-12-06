/*
 * Advent of Code 2025 day 6
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time, std::collections;

fn long? solve1()
{
	File f = file::open("day6.txt", "rb")!!;
	defer (void)f.close();
	long[1000] sums;
	long[1000] products = { [0..999] = 1 };
	long total;
	while (try line = io::treadline(&f))
	{
		Splitter s = line.tokenize(" ");
		int index = -1;
		while (index++, try element = s.next())
		{
			switch (element[0])
			{
				case '*':
					total += products[index];
				case '+':
					total += sums[index];
				default:
					long val = element.to_long()!;
					sums[index] += val;
					products[index] *= val;
			}
		}
	}
	return total;
}

fn long calculate(int col, int next_col, String[] numbers, bool is_plus)
{
	long total = is_plus ? 0 : 1;
	for (int i = next_col - 1; i >= col; i--)
	{
		long val;
		foreach (s : numbers)
		{
			char c = s.len > i ? s[i] : ' ';
			if (c.is_digit())
			{
				val = val * 10 + c - (long)'0';
			}
		}
		if (val)
		{
			total = is_plus ? (total + val) : (total * val);
		}
	}
	return total;
}

fn long? solve2()
{
	File f = file::open("day6.txt", "rb")!!;
	defer (void)f.close();
	String[6] numbers;
	int row = 0;
	long total;
	int max_width;
	while (try line = io::treadline(&f))
	{
		if (line[0] == '*' || line[0] == '+')
		{
			int len = line.len;
			int i;
			do
			{
				bool is_plus = line[i] == '+';
				int next_index = max_width;
				for (int j = i + 1; j < len; j++)
				{
					if (line[j] != ' ')
					{
						next_index = j;
						break;
					}
				}
				total += calculate(i, next_index, numbers[:row], is_plus);
				i = next_index;
			} while (i < len);
			break;
		}
		max_width = max(max_width, (int)line.len);
		numbers[row++] = line;
	}
	return total;
}

fn void main()
{
	io::printn("Advent of code, day 6.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1()!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2()!!, c.mark());
	};
}