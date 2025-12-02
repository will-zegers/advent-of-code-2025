use std::fs::File;
use std::io::{self, BufRead, BufReader};

mod dial_lock;
use dial_lock::DialLock;

const STARTING_POSITION: i16 = 50;
const MODULUS: i16 = 100;

fn main() -> io::Result<()> {
    let mut on_zero_count = 0;
    let mut dial = DialLock::new(STARTING_POSITION, MODULUS);

    let input = File::open("input.txt")?;
    let reader = BufReader::new(input);

    for line in reader.lines() {
        let line = line?;
        let (direction_str, distance_str) = line.split_at(1);
        let direction = direction_str.chars().next().unwrap();
        let distance = distance_str.parse::<i16>().unwrap();

        match direction {
            'L' => dial.rotate_left(distance),
            'R' => dial.rotate_right(distance),
            _ => panic!("Bad rotation direction '{}'", direction),
        };

        if dial.current == 0 {
            on_zero_count += 1;
        }
    }

    println!("Pointed to zero {} times", on_zero_count);
    println!("Passed zero {} times", dial.click_count);

    Ok(())
}
