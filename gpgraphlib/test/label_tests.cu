#include <gtest/gtest.h>
#include <sstream>

#include "label.h"

using namespace gpgraphlib;

TEST(label_reader, test1) {
  std::string c = "3 3\n1 2\n2 1\n3 3\n";
  LabelReader lr = LabelReader::fromFileContents(c);
  int prop[3];
  lr.setNodeProperties(prop);
  std::vector<int> actual(prop, prop+3);
  std::vector<int> expected = { 2, 1, 3 };
  EXPECT_EQ(expected, actual);
}
