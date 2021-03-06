# C++ Project Template for [Joint-Online-Judge](https://joj.sjtu.edu.cn/)

This template is based on xmake build system.

## Disclaimer

This project template is **NOT OFFICIAL**, and I'm not responsible for any possible wrongly generated code or late submission.

## Project Hierarchy

```
(project root)
├── build
│   ├── compile_commands.json
│   └── linux/x86_64/coverage/example
├── coverage
│   ├── index.html
│   └── ...
├── README.md
├── src
│   └── main.cpp
├── test
│   └── main.cpp
├── upload
│   └── example.zip
├── joj.lua
└── xmake.lua
```

## Usage

Please refer to [xmake](https://xmake.io/#/) documentation and `xmake.lua` for usage.

### Package

```sh
# Replace example with your target name.
xmake package example
# `upload` file directory will be created (if does not exist), and example.zip will be
# placed at `upload/example.zip`.
```

### Submit to JOJ

Before using this feature, you need to first have
[JOJ-Submitter](https://github.com/BoYanZh/JOJ-Submitter) installed on your
machine. Please refer to its `README.md` to see how to do it.

First you need to obtain your JOJ SID via
[JI-Auth](https://github.com/BoYanZh/JI-Auth) or browser, and URL of the
problem you want to submit. Then modify corresponding items in `xmake.lua`, and

```sh
xmake submit
```

Wait for the result!

## Features

- [xmake](https://github.com/xmake-io/xmake) build system, which supports
  [conan](https://github.com/conan-io/conan) package manager.
- Coverage support. Use [grcov](https://github.com/mozilla/grcov) to generate
  html coverage report. (Disabled on default, you need to have
  [grcov](https://github.com/mozilla/grcov) installed and uncomment
  corresponding section in `xmake.lua` to enable it.)
- Unit test support. By default this template use
  [boost-ext/ut](https://github.com/boost-ext/ut), xmake will download it for
  you.

## Special Thanks

[JI-Auth](https://github.com/BoYanZh/JI-Auth)

[JOJ-Submitter](https://github.com/BoYanZh/JOJ-Submitter)

## FAQ

1. How to build target before running it?

   Current I haven't find any way to do it. Probably you could just use `xmake build target && xmake run target`
