# string_format

[![Package Version](https://img.shields.io/hexpm/v/string_format)](https://hex.pm/packages/string_format)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/string_format/)

```sh
gleam add string_format
```
```gleam
import string_format

pub fn main() {
  let fibo_list = [1, 1, 2, 3, 5, 8]

  let mystr =
    format("PI is {} and the First fibonacci numbers are: {}")
    |> f(3.14)
    |> f(fibo_list)
    |> end()

  io.println(mystr)
}
```

Further documentation can be found at <https://hexdocs.pm/string_format>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
