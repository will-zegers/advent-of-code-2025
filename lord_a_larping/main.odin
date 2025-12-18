package lord_a_larping

import "core:fmt"
import "core:os"
import "core:strings"

FILE_PATH :: "input.txt"
LINE_WIDTH :: 15

// I originally got a nice clean solution using bit_set, but had to
// revert to a fixed array as bit_sit goes no high than 128 bits
INPUT_LINE :: [LINE_WIDTH]u8

main :: proc()
{
  input, ok := os.read_entire_file(FILE_PATH)
  if !ok {
    fmt.eprintf("Error reading file %v")
    return
  }
  defer delete(input)

  content := string(input)

  // beam_path holds the updated view of the beams current layout after
  // splits and fallthroughs
  beam_path: INPUT_LINE = '.'

  i := 0
  split_count := 0
  for line in strings.split_lines_iterator(&content) {
    split_count += process_line(&beam_path, line)
  }
  fmt.println(split_count)
}

process_line :: proc(beam_path: ^INPUT_LINE, line: string) -> int {
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

print_manifold_diagram :: proc(content: ^string) {
  // helper function to view the manifold diagram (note: this consumes
  // the 'content' string)
  i := 0
  beam_path: INPUT_LINE = '.'
  for line in strings.split_lines_iterator(content) {
    process_line(&beam_path, line)
    if i % 2 == 0 {
      fmt.printfln(line)
    } else {
      fmt.printfln("%s", beam_path)
    }
    i += 1
  }
}
