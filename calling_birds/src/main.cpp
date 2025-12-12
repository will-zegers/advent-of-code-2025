#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iterator>

#include "paper_matrix.hpp"

typedef char forklift_t;

const size_t INPUT_DIMENSIONS = 142;

const char EMPTY = '.';
const char ROLL = '@';

unsigned int countNeighbors(const PaperMatrix<forklift_t>& m, const size_t row, const size_t column)
{
  unsigned int numNeighboringRolls = 0;
  for (size_t i = row - 1; i <= row + 1; i++) {
    for (size_t j = column - 1; j <= column + 1; j++) {
      if (i == row && j == column) {
        continue;
      };

      if (m.at(i, j) == ROLL) {
        numNeighboringRolls++;
      }
    }
  }

  return numNeighboringRolls;
}

unsigned int countNumberRollsAccessible(const PaperMatrix<forklift_t>& m)
{
  unsigned int numAccessible = 0;
  for (size_t i = 1; i < m.nRows - 1; i++) {
    for (size_t j = 1; j < m.nColumns - 1; j++) {
      if (m.at(i, j) == ROLL && countNeighbors(m, i, j) < 4) {
        numAccessible++;
      }
    }
  }

  return numAccessible;
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
  std::cout << countNumberRollsAccessible(matrix) << std::endl;
}
