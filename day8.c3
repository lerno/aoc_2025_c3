/*
 * Advent of Code 2025 day 8
 * Sample solution demonstrating C3 language and standard library.
 */
import std::io, std::time, std::collections, std::sort;

alias Vec = long[<3>];
struct Box
{
	int circuit;
	Vec pos;
}
struct Distance
{
	int box1, box2;
	long distance;
}
typedef Circuit = inline List{int};

fn bool Distance.less(&self, Distance d)
{
	return self.distance < d.distance;
}

fn bool Circuit.less(&self, Circuit c)
{
	return self.len() > c.len();
}

fn long? solve1()
{
	File f = file::open("day8.txt", "rb")!;
	defer (void)f.close();
	List{Box} list;
	List{Distance} dist;
	List{Circuit} circuits;
	while (try line = io::treadline(&f))
	{
		Splitter s = line.tokenize(",");
		Vec vec = (Vec){ s.next().to_long(), s.next().to_long(), s.next().to_long() }!;
		foreach (int i, box : list)
		{
			Vec diff = vec - box.pos;
			dist.push({i, (int)list.len(), diff.dot(diff)});
		}
		list.push({ 0, vec });
	}
	quicksort(&dist);
	const END = 1000;
	foreach (d : dist.array_view()[:END])
	{
		int bx1 = d.box1;
		int bx2 = d.box2;
		Box* b1 = &list[bx1];
		Box* b2 = &list[bx2];
		if (b2.circuit < b1.circuit)
		{
			@swap(b1, b2);
			@swap(bx1, bx2);
		}
		switch
		{
			case !b1.circuit && b2.circuit:
				b1.circuit = b2.circuit;
				circuits[(usz)b2.circuit - 1].push(bx1);
			case !b1.circuit && !b2.circuit:
				Circuit c;
				c.push(bx1);
				c.push(bx2);
				b1.circuit = b2.circuit = (int)circuits.len() + 1;
				circuits.push(c);
			case b1.circuit == b2.circuit:
				break;
			default:
				Circuit* c1 = &circuits[(usz)b1.circuit - 1];
				Circuit* c2 = &circuits[(usz)b2.circuit - 1];
				foreach (bxid : c2.array_view())
				{
					list[bxid].circuit = b1.circuit;
					c1.push(bxid);
				}
				c2.clear();
		}
	}
	quicksort(&circuits);
	return circuits[0].len() * circuits[1].len() * circuits[2].len();
}

fn long? solve2()
{
	File f = file::open("day8.txt", "rb")!;
	defer (void)f.close();
	List{Box} list;
	List{Distance} dist;
	List{Circuit} circuits;
	while (try line = io::treadline(&f))
	{
		Splitter s = line.tokenize(",");
		Vec vec = (Vec){ s.next().to_long(), s.next().to_long(), s.next().to_long() }!;
		foreach (int i, box : list)
		{
			Vec diff = vec - box.pos;
			dist.push({i, (int)list.len(), diff.dot(diff)});
		}
		list.push({ 0, vec });
	}
	quicksort(&dist);
	foreach (d : dist)
	{
		int bx1 = d.box1;
		int bx2 = d.box2;
		Box* b1 = &list[bx1];
		Box* b2 = &list[bx2];
		if (b2.circuit < b1.circuit)
		{
			@swap(b1, b2);
			@swap(bx1, bx2);
		}
		switch
		{
			case !b1.circuit && b2.circuit:
				Circuit* c2 = &circuits[(usz)b2.circuit - 1];
				b1.circuit = b2.circuit;
				c2.push(bx1);
				if (c2.len() == list.len()) return b1.pos.x * b2.pos.x;
			case !b1.circuit && !b2.circuit:
				Circuit c;
				c.push(bx1);
				c.push(bx2);
				b1.circuit = b2.circuit = (int)circuits.len() + 1;
				circuits.push(c);
			case b1.circuit == b2.circuit:
				break;
			default:
				Circuit* c1 = &circuits[(usz)b1.circuit - 1];
				Circuit* c2 = &circuits[(usz)b2.circuit - 1];
				foreach (bxid : c2.array_view())
				{
					list[bxid].circuit = b1.circuit;
					c1.push(bxid);
				}
				if (c1.len() == list.len()) return b1.pos.x * b2.pos.x;
				c2.clear();
		}
	}
	unreachable("Failed");
}

fn void main()
{
	io::printn("Advent of code, day 8.");
	@pool()
	{
		// Simple benchmarking with Clock, "mark" returns the last duration and resets the clock
		Clock c = clock::now();
		io::printfn("* Task 1: %d - completed in %s", solve1()!!, c.mark());
		io::printfn("* Task 2: %d - completed in %s", solve2()!!, c.mark());
	};
}

