# place to try buck2 

https://buck2.build/docs/about/getting_started/#

# plan
- [ ] fetch, build and use gtest
- [ ] try use haskell
    - build
    - test
- [ ] try use a few langua at once
- [ ]

# Q: 
- how get log of a stage
- why do we need system_python_bootstrap_toolchain
- how to add cxx_test?
```
buck2 test //:test
File changed: root//BUCK
Error in configured node dependency, dependency chain follows (-> indicates depends on, ^ indicates same configuration as previous):
       root//:test (prelude//platforms:default#904931f735703749)
    -> toolchains//:test (^)


Caused by:
    Unknown target `test` from package `toolchains//`.
    Did you mean one of the 2 targets in toolchains//:BUCK?
    Maybe you meant one of these similar targets?
      toolchains//:cxx

```




# log

## 1
https://buck2.build/docs/about/getting_started/#

## 2: how to watch result 
it is hard to undrestand where git_fetch put files.

```
# gtest/BUCK

git_fetch(
    name = "gtest.git",
    repo = "https://github.com/google/googletest.git",
    rev  = "35b75a2cba6ef72b7ce2b6b94b05c54ca07df866",
)


```


But we can use:

```
buck2 build //gtest:gtest.git --show-output
Build ID: 78094e3d-ec10-4fa0-b6f2-93a1a14406fd
Command: build.                                                                                                          
Time elapsed: 0.0s
BUILD SUCCEEDED
root//gtest:gtest.git buck-out/v2/gen/root/904931f735703749/gtest/__gtest.git__/gtest


ls -l buck-out/v2/gen/root/904931f735703749/gtest/__gtest.git__/gtest
total 72
-rw-r--r-- 1 rbykov rbykov 7405 июн 18 11:34 BUILD.bazel
drwxr-xr-x 2 rbykov rbykov 4096 июн 18 11:34 ci
-rw-r--r-- 1 rbykov rbykov  986 июн 18 11:34 CMakeLists.txt
-rw-r--r-- 1 rbykov rbykov 5690 июн 18 11:34 CONTRIBUTING.md
-rw-r--r-- 1 rbykov rbykov 2293 июн 18 11:34 CONTRIBUTORS
drwxr-xr-x 7 rbykov rbykov 4096 июн 18 11:34 docs
-rw-r--r-- 1 rbykov rbykov 1974 июн 18 11:34 fake_fuchsia_sdk.bzl
drwxr-xr-x 7 rbykov rbykov 4096 июн 18 11:34 googlemock
drwxr-xr-x 8 rbykov rbykov 4096 июн 18 11:34 googletest
-rw-r--r-- 1 rbykov rbykov 1136 июн 18 11:34 googletest_deps.bzl
-rw-r--r-- 1 rbykov rbykov 1475 июн 18 11:34 LICENSE
-rw-r--r-- 1 rbykov rbykov 2640 июн 18 11:34 MODULE.bazel
-rw-r--r-- 1 rbykov rbykov 5261 июн 18 11:34 README.md
-rw-r--r-- 1 rbykov rbykov 2709 июн 18 11:34 WORKSPACE
-rw-r--r-- 1 rbykov rbykov 1794 июн 18 11:34 WORKSPACE.bzlmod
```
