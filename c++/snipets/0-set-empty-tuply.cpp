#include<iostream>
#include<tuple>
#include<set>

// see also:
//
// https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/n4387.html
// resume: use make_tuple


int main () {

    {
        std::set<std::tuple<>> set;

        std::cout <<set.size() << std::endl;
        set.insert ({});
        std::cout <<set.size() << std::endl; //expected 1, go 0 o_O?
    }
    {
        std::set<std::tuple<int>> set;

        std::cout <<set.size() << std::endl;
        set.insert ({});
        std::cout <<set.size() << std::endl; //expected 1, go 0 o_O?
    }
    {
        std::set<std::tuple<int>> set;

        std::cout <<set.size() << std::endl;
        set.insert (1);
        std::cout <<set.size() << std::endl; //expected 1, got 1 - correct
    }
    {
        std::set<std::tuple<>> set;

        std::cout <<set.size() << std::endl;
        set.insert (std::make_tuple());
        std::cout <<set.size() << std::endl; //expected 1, got 1 - correct
    }
    return 0;
}
