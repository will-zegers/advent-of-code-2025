pub struct DialLock {
    pub click_count: i16,
    pub current: i16,
    modulus: i16,
}

impl DialLock {
    pub fn new(starting_position: i16, modulus: i16) -> Self {
        Self {
            click_count: 0,
            current: starting_position,
            modulus,
        }
    }

    pub fn rotate_left(self: &mut Self, distance: i16) {
        self.count_clicks_left(distance);
        self.update_current_left(distance);
    }

    pub fn rotate_right(self: &mut Self, distance: i16) {
        self.count_clicks_right(distance);
        self.update_current_right(distance);
    }

    fn update_current_left(self: &mut Self, distance: i16) {
        if self.current >= distance {
            self.current -= distance;
            return;
        }

        let complimentary_distance = self.modulus - (distance % self.modulus);
        self.update_current_right(complimentary_distance);
    }

    fn update_current_right(self: &mut Self, distance: i16) {
        self.current = (self.current + distance) % self.modulus;
    }

    fn count_clicks_left(self: &mut Self, distance: i16) {
        if self.current > distance {
            return;
        }

        let clicks = distance / self.modulus;
        if self.current == 0 || (distance % self.modulus) < self.current {
            self.click_count += clicks;
        } else {
            self.click_count += clicks + 1;
        }
    }

    fn count_clicks_right(self: &mut Self, distance: i16) {
        self.click_count += (self.current + distance) / self.modulus;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_rotate_right() {
        let mut dial = DialLock::new(0, 100);

        dial.rotate_right(1);
        assert_eq!(dial.current, 1);

        dial.rotate_right(42);
        assert_eq!(dial.current, 43);

        dial.rotate_right(56);
        assert_eq!(dial.current, 99);

        dial.rotate_right(1);
        assert_eq!(dial.current, 0);

        dial.rotate_right(101);
        assert_eq!(dial.current, 1);

        dial.rotate_right(1234);
        assert_eq!(dial.current, 35);
    }

    #[test]
    fn test_rotate_left() {
        let mut dial = DialLock::new(0, 100);

        dial.rotate_left(1);
        assert_eq!(dial.current, 99);

        dial.rotate_left(69);
        assert_eq!(dial.current, 30);

        dial.rotate_left(420);
        assert_eq!(dial.current, 10);
    }

    #[test]
    fn test_click_count_right() {
        let mut dial = DialLock::new(0, 100);

        dial.rotate_right(67);
        assert_eq!(dial.click_count, 0);

        dial.rotate_right(33);
        assert_eq!(dial.click_count, 1);

        dial.rotate_right(100);
        assert_eq!(dial.click_count, 2);

        dial.rotate_right(420);
        assert_eq!(dial.click_count, 6);

        dial.rotate_right(79);
        assert_eq!(dial.click_count, 6);

        dial.rotate_right(1);
        assert_eq!(dial.click_count, 7);
    }

    #[test]
    fn test_count_click_left() {
        let mut dial = DialLock::new(0, 100);

        dial.rotate_left(1);
        assert_eq!(dial.click_count, 0);

        dial.rotate_left(99);
        assert_eq!(dial.click_count, 1);

        dial.rotate_left(100);
        assert_eq!(dial.click_count, 2);

        dial.rotate_left(1);
        assert_eq!(dial.click_count, 2);

        dial.rotate_left(30);
        assert_eq!(dial.click_count, 2);

        dial.rotate_left(942);
        assert_eq!(dial.click_count, 11);
    }
}
