#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iterator>
#include "paper_matrix.hpp"

typedef char forklift_t;

const size_t INPUT_DIMENSIONS = 12;

const char EMPTY = '.';
const char ROLL = '@';
const char MARKED_FOR_REMOVAL = '+';

bool isOccupiedByRoll(const PaperMatrix<forklift_t>& m, const size_t row, const size_t column)
{
  return m.at(row, column) == ROLL || m.at(row, column) == MARKED_FOR_REMOVAL;
}

unsigned int neighborCount(const PaperMatrix<forklift_t>& m, const size_t row, const size_t column)
{
  unsigned int numNeighboringRolls = 0;
  for (size_t i = row - 1; i <= row + 1; i++) {
    for (size_t j = column - 1; j <= column + 1; j++) {
      if (i == row && j == column) {
        continue;
      };

      if (isOccupiedByRoll(m, i, j)) {
        numNeighboringRolls++;
      }
    }
  }

  return numNeighboringRolls;
}

unsigned int countAndMarkAccessibleRolls(PaperMatrix<forklift_t>& m)
{
  unsigned int numAccessible = 0;
  for (size_t i = 1; i < m.nRows - 1; i++) {
    for (size_t j = 1; j < m.nColumns - 1; j++) {
      if (isOccupiedByRoll(m, i, j) && neighborCount(m, i, j) < 4) {
        m.set(i, j, MARKED_FOR_REMOVAL);
        numAccessible++;
      }
    }
  }

  return numAccessible;
}

void removeMarkedRolls(PaperMatrix<forklift_t>& m)
{
  for (size_t i = 1; i < m.nRows - 1; i++) {
    for (size_t j = 1; j < m.nColumns - 1; j++) {
      if (m.at(i, j) == MARKED_FOR_REMOVAL) {
        m.set(i, j, EMPTY);
      }
    }
  }
}

int main(int argc, char* argv[])
{
  std::string inputFile = argv[1];
  std::ifstream file(inputFile);

  std::vector<forklift_t> data(
    std::istream_iterator<forklift_t>{file},
    std::istream_iterator<forklift_t>{}
  );

  auto matrix = PaperMatrix<forklift_t>(INPUT_DIMENSIONS, data);

  auto numberToRemove = countAndMarkAccessibleRolls(matrix);
  auto totalRemoved = numberToRemove;
  while (numberToRemove > 0) {
    removeMarkedRolls(matrix);
    numberToRemove = countAndMarkAccessibleRolls(matrix);
    totalRemoved += numberToRemove;
  }

  std::cout << totalRemoved << std::endl;
}
