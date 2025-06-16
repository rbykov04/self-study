#include "lib.h"
#include <gtest/gtest.h>

TEST(MyTest, BasicTest) {
  ASSERT_EQ(sum(2, 3), 5);
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
