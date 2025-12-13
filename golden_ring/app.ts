import * as fs from 'fs';
import * as readline from 'readline';

const INPUT_FILE: string = 'input.txt';

enum PointType {
  RangeBegin = 1,
  Ingredient = 2,
  RangeEnd   = 4,
}

type Point = {
  value: number;
  type: PointType;
}

function main(): void
{
  const input = readInputFile();

  // part 1
  const pointsCountIngredients = gatherInputAsPoints(input, (a, b) => {
    if (a.value === b.value) {
      return a.type - b.type;
    }
    return a.value - b.value;
  });
  const numFreshIngredients = countFreshIngredients(pointsCountIngredients);

  // part 2
  const pointsCountFreshRangeIDs = gatherInputAsPoints(input, (a, b) => {
    if (a.value === b.value) {
      return b.type - a.type;
    }
    return b.value - a.value;
  });
  const freshRangeIDs = countFreshRangeIDs(pointsCountFreshRangeIDs);

  console.log(`Number of fresh ingredients: ${numFreshIngredients}`);
  console.log(`Number of fresh ingredients IDs: ${freshRangeIDs}`);
}

function readInputFile(filename: string = INPUT_FILE): string[]
{
  try {
    const input = fs.readFileSync(INPUT_FILE, 'utf-8');
    return input.split(/\r?\n/)
                .filter((elem, idx) => elem); // filter for empty lines
  } catch {
    console.log(`Error: failed to read file: '${INPUT_FILE}'`);
    process.exit(1);
  }
}

function gatherInputAsPoints(input: string[], sortFn: (a: Point, b: Point) => number): Point[]
{
  // Gather up the beginning and end of ID ranges, and ingredient IDs as
  // points as were they to fall on a number line, then sort them numerically
  // (Note: the sorting function and its tie-breakers is dependent on the problem,
  // hence why its parameterized)

  let points: Point[] = [];
  for (const line of input) {
    if (line.includes('-')) { // a '-' indicates this is a range
      let [begin, end] = line.split('-');
      points.push({
        value: +begin,
        type: PointType.RangeBegin,
      });
      points.push({
        value: +end,
        type: PointType.RangeEnd,
      })
    } else {
      points.push({
        value: +line,
        type: PointType.Ingredient,
      });
    }
  }

  points.sort(sortFn);

  return points;
}

function countFreshIngredients(points: Point[]): number
{
  // This is pretty much a segments-and-points algo
  //
  // Use a counter that's incremented whenever we hit a RangeBegin,
  // and decrement it when we hit a RangeEnd (with a zero floor). When
  // we get to an Ingredient and the counter's positive, we know
  // we're in at least one range of IDs that has begun but not yet
  // been ended; so, the ingredient ID must lie in the fresh range.

  let counter = 0, freshIngredients = 0;
  for (const point of points) {
    switch(point.type) {
      case PointType.RangeBegin:
        counter++;
        break;
      case PointType.RangeEnd:
        counter = counter > 0 ? counter - 1 : 0;
        break;
      case PointType.Ingredient:
        if (counter > 0) {
          freshIngredients++;
        }
        break;
    }
  }
  return freshIngredients;
}

function countFreshRangeIDs(points: Point[]): number
{
  /// Similar approach to the segment-point solution above.
  //
  // This time we're just working backward (i.e., we've sorted descending
  // order). When the counter is zero and encounter a RangeEnd, we add that
  // to the total range of IDs, knowing that there'll exist an eventual
  // beginning. For each RangeEnd, we increment the counter; for each
  // RangeBegin we decrement it. When we hit a RangeBegin that will decrement
  // the counter to zero, this indicates the start of some definite range -
  // possibly with some overlaps in between - so we subtract it off to get
  // the total interval.

  let counter = 0, freshRangeIDs = 0;
  for (const point of points) {
    switch(point.type) {
      case PointType.RangeBegin:
        if (counter === 1) {
          freshRangeIDs -= point.value - 1;
        }
        counter--;
        break;
      case PointType.RangeEnd:
        if (counter === 0) {
          freshRangeIDs += point.value;
        }
        counter++;
        break;
      case PointType.Ingredient: // Ignore, only care about IDs in ranges
        break;
    }
  }
  return freshRangeIDs;
}

main()
