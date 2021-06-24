#include <boost/ut.hpp>
#include "greeter.h"

#include <sstream>

int main() {
  using namespace boost::ut;
  "greeter"_test = [] {
    greeter g("Hello, world!");
    std::ostringstream buffer;
    buffer << g;
    expect(buffer.str() == "Hello, world!\n");
  };
  return 0;
}
