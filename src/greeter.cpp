#include <iostream>
#include "greeter.h"

std::ostream& operator<<(std::ostream& os, const greeter& g) {
  os << g._content << std::endl;
  return os;
}

void greeter::clear() noexcept {
  _content.clear();
}

bool greeter::empty() const noexcept {
  return _content.empty();
}
