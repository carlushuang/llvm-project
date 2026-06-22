// REQUIRES: system-linux

// COM: An explicit --gcc-toolchain should prevent fallback to sysroot or host
// COM: C++ headers when deciding whether to use embedded libc++.
// RUN: rm -rf %t.sysroot %t.gcc-toolchain
// RUN: mkdir -p %t.sysroot/usr/include/c++/999 %t.gcc-toolchain
// RUN: touch %t.sysroot/usr/include/c++/999/cstddef
// RUN: compile-hip-cxx-headers --mode=gcc-toolchain %s \
// RUN:   %t.sysroot %t.gcc-toolchain | %FileCheck %s

// CHECK: Embedded libc++ headers: active
// CHECK: RESULT: PASS

#include <tuple>
#include <type_traits>

static_assert(std::is_integral<int>::value, "int is integral");
static_assert(std::tuple_size<std::tuple<int, float>>::value == 2,
              "tuple size");

extern "C" __attribute__((global)) void test_kernel(int *out) {
  std::tuple<int, float> t{42, 3.14f};
  out[0] = std::get<0>(t);
}
