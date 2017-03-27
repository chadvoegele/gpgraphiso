#pragma once

#include <string>
#include <vector>
#include <istream>

namespace gpgraphlib {
  class LabelReader {
    public:
      void setNodeProperties(int* arr);
      static LabelReader fromFilename(std::string filename);
      static LabelReader fromFileContents(std::string fileContents);
      LabelReader(std::vector<int> properties);
      void throwIfInvalid(unsigned nnodes);
      bool isValid(unsigned nnodes);

    private:
      std::vector<int> properties;
      static std::vector<int> parse(std::istream& stream);
  };
}
