# fireball

[![Package Version](https://img.shields.io/hexpm/v/fireball)](https://hex.pm/packages/fireball)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/fireball/)

```sh
gleam add fireball@1
```
```gleam
import gleam/io

import fireball

pub fn main() {
  //Get a document from your database
  let assert Ok(my_doc) = firebase.get_doc(apikey: "my_key", apiver: "v1beta1", database: "(default)", doc: "path/to/my_doc/without/leading/slash", proj_id: "my_project_id")

  //Print some data from it!
  io.println(my_doc.data)
}
```

Further documentation can be found at <https://hexdocs.pm/fireball>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
