package swan_a_swimming

import "core:fmt"
import "core:os"
import "core:strings"

FILE_PATH :: "input.txt"
LINE_WIDTH :: 15

// I originally got a nice clean solution using bit_set, but had to
// revert to a fixed u8 array as bit_set goes no higher than 128 bits
// (input lines would've needed 141)

main :: proc()
{
  input, ok := os.read_entire_file(FILE_PATH)
  if !ok {
    fmt.eprintf("Error reading file %v")
    return
  }
  defer delete(input)

  content := string(input)

  // beam_path holds the updated view of the beam's current layout after
  // splits and fallthroughs
  beam_path: [LINE_WIDTH]u8 = '.'

  // timeline_accumlator keeps a running tally of the of the number of
  // timelines (unique paths) 'created' after each line for each position
  // in the line of input
  timeline_accumulator: [LINE_WIDTH]int = 0

  print_manifold_diagram(content)

  i := 0
  split_count := 0
  for line in strings.split_lines_iterator(&content) {
    split_count += get_split_count(&beam_path, line)
    get_timeline_count(&timeline_accumulator, line)
  }

  timeline_count := 0
  for i in timeline_accumulator {
    timeline_count += i
  }
  fmt.printfln("Number of splits: %d", split_count)
  fmt.printfln("Total timeline count: %d", timeline_count)

}

get_split_count :: proc(beam_path: ^[LINE_WIDTH]u8, line: string) -> int {
  // tracks the number of times we encounter a split ('^') while tracking
  // the tachyon path through the line of input. Note that even if a '^'
  // occurs on the input, we don't necessarily count it unless we see a
  // beam ('|') going into it from the previous results

  split_count := 0
  for i := 0; i < len(line); i = i + 1 {
    if line[i] == '^' && beam_path[i] == '|' {
      // a beam ('|') has hit a splitter ('^'). The beam stops in that column
      // and continues as two beams in the adjacent columns
      beam_path[i-1] = '|'
      beam_path[i+1] = '|'
      beam_path[i] = '.'

      split_count += 1
    } else if line[i] == 'S' { // mark the start point
      beam_path[i] = '|'
    }
  }
  return split_count
}

get_timeline_count :: proc(timeline_accumulator: ^[LINE_WIDTH]int, line: string) {
  // accumulates the number of 'timelines' (i.e. total number of unique paths)
  // encountered to each position in the input, upto this line in the input
  //
  // e.g.           | Timelines
  // .......S.......|
  // .......|.......|
  //        1       | 1
  // .......^.......|
  // ......|.|......|
  //       1 1      | 2
  // ......^.^......|
  // .....|.|.|.....|
  //      1 2 1     | 4
  // (and so on)

  for i := 0; i < len(line); i = i + 1 {
    if line[i] == '^' && timeline_accumulator[i] > 0 {
      timeline_accumulator[i-1] += timeline_accumulator[i]
      timeline_accumulator[i+1] += timeline_accumulator[i]
      timeline_accumulator[i] = 0
    } else if line[i] == 'S' { // mark the start point
      timeline_accumulator[i] = 1
    }
  }
}

print_manifold_diagram :: proc(content: string) {
  // helper/debug function to view the manifold diagram

  i := 0
  content := strings.clone(content) // so we don't consume the 'content' string
  beam_path: [LINE_WIDTH]u8 = '.'
  for line in strings.split_lines_iterator(&content) {
    get_split_count(&beam_path, line)
    if i % 2 == 0 {
      fmt.printfln(line)
    } else {
      fmt.printfln("%s", beam_path)
    }
    i += 1
  }
}
