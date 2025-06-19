#include <iostream>

#include "lib.h"

auto main(int argc, char *argv[]) -> int {
    std::cout << "Hello from a C++ Buck2 program!" << std::endl;
    std::cout << "2 + 3 = " << sum (2, 3) << std::endl;
    return 0;
}
