.PHONE: cargo-version rust-version rust-update rust-doc all


all: hello

hello: hello-world
	./hello-world

hello-world: hello-world.rs
	rustc hello-world.rs


cargo-version:
	cargo --version

rust-version:
	rustc --version

rust-update:
	rustup update


rust-doc:
	rustup doc
