# place to try buck2 

https://buck2.build/docs/about/getting_started/#

# Q: 
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

https://buck2.build/docs/about/getting_started/#

