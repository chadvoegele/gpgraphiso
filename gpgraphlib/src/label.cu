#include <label.h>

#include <fstream>
#include <sstream>

namespace gpgraphlib {
  LabelReader::LabelReader(std::vector<int> properties) : properties(properties) { }

  LabelReader LabelReader::fromFilename(std::string filename) {
    filename = filename;
    std::ifstream fs(filename);
    if (!fs.is_open()) {
      throw std::runtime_error("failed to open " + filename);
    }
    LabelReader lr(parse(fs));
    return lr;
  }

  LabelReader LabelReader::fromFileContents(std::string fileContents) {
    std::istringstream ss(fileContents);
    LabelReader lr(parse(ss));
    return lr;
  }

  std::vector<int> LabelReader::parse(std::istream& stream) {
    std::vector<int> properties;
    int nnodes;
    if (stream >> nnodes && stream >> nnodes) {
      properties.reserve(nnodes);
    } else {
      throw std::runtime_error("Failed to read label header.");
    }

    int i;
    bool isProp = false;
    while (stream >> i) {
      if (isProp) {
        properties.push_back(i);
      }
      isProp = !isProp;
    }

    if (properties.size() != nnodes) {
      throw std::runtime_error("Mismatch between header # nodes and actual # of properties.");
    }

    return properties;
  }

  void LabelReader::setNodeProperties(int* arr) {
    for (size_t i = 0; i != properties.size(); i++) {
      arr[i] = properties[i];
    }
  }

  bool LabelReader::isValid(unsigned nnodes) {
    return nnodes == properties.size();
  }

  void LabelReader::throwIfInvalid(unsigned nnodes) {
    if (!isValid(nnodes)) {
      throw std::runtime_error("Labels are invalid.");
    }
  }
}
