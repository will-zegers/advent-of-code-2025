#include <iostream>
#include <vector>

using std::vector;

template <typename T>
struct PaperMatrix {

  const size_t nRows;
  const size_t nColumns;

  PaperMatrix(size_t squareDimension, std::vector<T> data)
      : nRows(squareDimension)
      , nColumns(squareDimension)
      , data(data) {}

  inline T at(const size_t row, const size_t column) const
  {

    return data[indexTo1D(row, column)];
  }

  void print() {
    for (int i = 0; i < nRows; i++) {
      for (int j = 0; j < nColumns; j++) {
        std::cout << at(i, j);
      }
      std::cout << std::endl;
    }
  }


private:
  const std::vector<T> data;

  size_t indexTo1D(const size_t i, const size_t j) const
  {
    return nColumns * i + j;
  }
};
