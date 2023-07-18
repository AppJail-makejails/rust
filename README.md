# Rust

Rust is a multi-paradigm, general-purpose programming language that emphasizes performance, type safety, and concurrency. It enforces memory safety—ensuring that all references point to valid memory—without requiring the use of a garbage collector or reference counting present in other memory-safe languages. To simultaneously enforce memory safety and prevent concurrent data races, its "borrow checker" tracks the object lifetime of all references in a program during compilation. Rust is popularized for systems programming but also has high-level features including some functional programming constructs.

wikipedia.org/wiki/Rust_(programming_language)

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Rust_programming_language_black_logo.svg/800px-Rust_programming_language_black_logo.svg.png" alt="rust logo" width="60%" height="auto">

## How to use this Makejail

### Basic usage

Create a `Makejail` in your Rust app project.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/rust

WORKDIR /app
COPY app/

RUN rustc hello.rs

STAGE cmd

WORKDIR /app
RUN ./hello
```

Where `options/network.makejail` are the options that suit your environment, for example:

```
ARG network
ARG interface=rustapp

OPTION virtualnet=${network}:${interface} default
OPTION nat
```

Open a shell and run `appjail makejail`:

```sh
appjail makejail -j rustapp -- --network development
```

To run the application we can use `appjail run`:

```console
# appjail run rustapp
Hello, world!
```

### Using Makejail builders

If we get the size of the previous jail

```console
# appjail stop rustapp
...
# appjail cmd local rustapp du -sh
789M    .
```

we have a very large jail to run a simple binary. For compiled programming languages we could use Makejail builders to reduce the size of the jail.

**Makejail**:

```
OPTION start
OPTION overwrite

EXEC --name rustapp-builder --file build.makejail --arg network=development --arg interface=rstappb

WORKDIR /app
COPY --jail rustapp-builder /app/hello
DESTROY --force rustapp-builder

STAGE cmd

WORKDIR /app
RUN ./hello
```

**build.makejail**:

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/rust

WORKDIR /app
COPY app/

RUN rustc hello.rs
```

For simplicity, `Makejail` does not use more options than necessary, but you can use as many as you want without affecting `build.makejail`.

Open a shell and run `appjail makejail`:

```sh
appjail makejail -j rustapp
```

Now our jail with the application we want to run has a very reduced size.

```console
# appjail stop rustapp
...
# appjail cmd local rustapp du -sh
 13M    .
```

Much of the size overhead if for jail, but for big applications this is not harmful.

## How to build the Image

Make any changes you want to your image.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/rust --file build.makejail
```

Build the jail:

```sh
appjail makejail -j rust
```

Remove unportable or unnecessary files and directories and export the jail:

```sh
appjail stop rust
appjail cmd local rust sh -c "rm -f var/log/*"
appjail cmd local rust sh -c "rm -f var/cache/pkg/*"
appjail cmd local rust sh -c "rm -f var/run/*"
appjail cmd local rust vi etc/rc.conf
appjail image export rust
```

## Tags

| Tag         | Arch    | Version           | Type   |
| ----------- | ------- | ----------------- | ------ |
| `13.2-1.70` | `amd64` | `13.2-RELEASE-p1` | `thin` |
| `13.1-1.70` | `amd64` | `13.1-RELEASE-p8` | `thin` |
