# rust

Rust is a multi-paradigm, general-purpose programming language that emphasizes performance, type safety, and concurrency. It enforces memory safety—ensuring that all references point to valid memory—without requiring the use of a garbage collector or reference counting present in other memory-safe languages. To simultaneously enforce memory safety and prevent concurrent data races, its "borrow checker" tracks the object lifetime of all references in a program during compilation. Rust is popularized for systems programming but also has high-level features including some functional programming constructs.

wikipedia.org/wiki/Rust_(programming_language)

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Rust_programming_language_black_logo.svg/500px-Rust_programming_language_black_logo.svg.png" width="30%" height="auto" alt="rust logo">

## How to use this Makejail

### Start a Rust instance running your app

The most straightforward way to use this image is to use a Rust container as both the build and runtime environment. In your `Containerfile`, writing something along the lines of the following will compile and run your project:

```Containerfile
FROM ghcr.io/appjail-makejails/rust

WORKDIR /myapp
COPY . .

# Depending on your project, you'll need many packages. FreeBSD-set-base-jail
# installs many dependencies, although it may take up more unnecessary space
# than if only the necessary packages were installed.
RUN pkg install FreeBSD-set-base-jail && \
    cargo install --path .

CMD ["myapp"]
```

Then, build and run the OCI image:

```console
$ buildah build --network=host -t my-rust-app .
$ appjail oci run \
    -o overwrite=force \
    -o ephemeral \
    -o alias \
    -o ip4_inherit \
    localhost/my-rust-app my-rust-app
```

This creates an image that has all of the rust tooling for the image, which is 2.32 GiB. If you just want the compiled application:

```dockerfile
FROM ghcr.io/appjail-makejails/rust

WORKDIR /myapp
COPY . .

RUN pkg install FreeBSD-set-base-jail && cargo install --path .

FROM ghcr.io/appjail-makejails/base
COPY --from=builder /usr/local/cargo/bin/myapp /usr/local/bin/myapp
CMD ["myapp"]
```

This method will create an image that is only 34.5 MiB in size.

### Compile your app inside the Docker container

There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the container instance, you can write something like:

```console
$ appjail oci run \
    -o overwrite=force \
    -o ephemeral \
    -o alias \
    -o ip4_inherit \
    -o fstab="$PWD /myapp" \
    -o pkg=FreeBSD-set-base-jail \
    -o template=/usr/local/share/examples/appjail/templates/freebsd-oci.conf \
    -w /myapp \
    ghcr.io/appjail-makejails/rust:15.1 my-rust-app \
    cargo build --release
```

This will add your current directory, as a volume, to the container, set the working directory to the volume, and run the command `cargo build --release`. This tells Cargo, Rust's build system, to compile the crate in `myapp` and output the executable to `target/release/myapp`.

### OCI image and Makejail

This repository includes a small `Makejail` that ultimately uses the OCI image, in case you prefer to use `appjail-makejail(5)`.

```console
$ appjail makejail \
    -j rust \
    -f gh+AppJail-makejails/rust \
    -o alias \
    -o ip4_inherit \
    -o ephemeral \
    -o container="args:--pull"
...
$ appjail cmd jexec rust cargo version
cargo 1.96.0 (30a34c682 2026-05-25) (built from a source tarball)
```

### Arguments (stage: build)

* `rust_from` (default: `ghcr.io/appjail-makejails/rust`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `rust_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
    - tag: 15.1-nightly
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        NIGHTLY: 'yes'
```

## Notes

1. The ideas present in the Docker image of Rust are taken into account for users who are familiar with it.
