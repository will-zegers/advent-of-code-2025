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
  pointType: PointType;
}

function main(): void {
  const input = readInputFile();
  const points = gatherInputAsPoints(input);
  const numFreshIngredients = countFreshIngredients(points);

  console.log(`Number of fresh ingredients: ${numFreshIngredients}`);
}

function readInputFile(filename: string = INPUT_FILE): string[] {
  try {
    const input = fs.readFileSync(INPUT_FILE, 'utf-8');
    return input.split(/\r?\n/)
                .filter((elem, idx) => elem); // filter for empty lines
  } catch {
    console.log(`Error: failed to read file: '${INPUT_FILE}'`);
    process.exit(1);
  }
}

function gatherInputAsPoints(input: string[]): Point[] {
  // Gather up the beginning and end of ID ranges, and ingredient IDs as
  // points as were they to fall on a number line, then sort them numerically
  // (with ties going in the order RangeBegin < Ingredient < RangeEnd)

  let points: Point[] = [];
  for (const line of input) {
    if (line.includes('-')) { // a '-' indicates this is a range
      let [begin, end] = line.split('-');
      points.push({
        value: +begin,
        pointType: PointType.RangeBegin,
      });
      points.push({
        value: +end,
        pointType: PointType.RangeEnd,
      })
    } else {
      points.push({
        value: +line,
        pointType: PointType.Ingredient,
      });
    }
  }

  points.sort((a, b) => {
    if (a.value === b.value) {
      return a.pointType - b.pointType
    }
    return a.value - b.value;
  });

  return points;
}

function countFreshIngredients(points: Point[]): number {
  // This is pretty much a segments-and-points algo
  //
  // Use a counter that's incremented whenever we hit a RangeBegin,
  // and decrement it when we hit a RangeEnd (with a zero floor). When
  // we get to an Ingredient and the counter's positive, we know
  // we're in at least one range of IDs that has begun but not yet
  // been ended; so, the ingredient ID must lie in the fresh range.

  let counter = 0, freshIngredients = 0;
  for (const point of points) {
    switch(point.pointType) {
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
      default:
        throw new Error(`Invalid PointType ${point.pointType}`)
    }
  }
  return freshIngredients;
}

main()
