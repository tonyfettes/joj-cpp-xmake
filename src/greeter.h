//! @file greeter.h
//! @brief header file for class greeter
//!
//! This file declare a class greeter.
//! @author Tony Fettes
//! @bug This is just an example.

#ifndef _GREETER_H_
#define _GREETER_H_

#include <iostream>

/// @class greeter
/// @brief A class that is able to print a string with a endl.
/// 
/// This class can be initialized with (const std::string&) / (std::string&&) /
/// (const char *), and can output the string to stream using operator<<.
class greeter {
private:
  std::string _content;

public:
  greeter() = delete;

  // This is a template function, so it should be defined where it is declared.
  /// Constructor that takes both (const std::string&)/(std::string&&)/(const
  /// char *).
  /// @param An C string or the lvalue/rvalue reference of a std::string.
  template <typename U>
  greeter(U&& s) : _content(std::forward<U>(s)) {}

  friend std::ostream& operator<<(std::ostream& os, const greeter& g);
  
  /// Clears the content of the greeter.
  void clear() noexcept;

  /// Check if the greeter is an empty one.
  /// @return true if the greeter is empty, false if not.
  bool empty() const noexcept;
};

#endif // _GREETER_H_
