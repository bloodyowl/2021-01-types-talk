open Belt

type picture = {
  large: string,
  medium: string,
  small: string,
}
type name = {
  first: string,
  last: string,
}
type t = {
  picture: option<picture>,
  email: string,
  name: name,
}

type payload = {results: array<t>}

let query = () => {
  Request.make(
    ~url="https://randomuser.me/api/",
    ~responseType=(JsonAsAny: Request.responseType<payload>),
    (),
  )
  ->Future.flatMap(~propagateCancel=true, result => {
    switch result {
    | Ok({ok, response, status}) =>
      switch (ok, status, response) {
      | (true, _, Some({results})) => Future.value(Ok(results[0]))
      | _ => Future.value(Error(#UnknownError))
      }
    | Error(_) => Future.value(Error(#UnknownError))
    }
  })
  ->Future.flatMapOk(~propagateCancel=true, value => {
    let random = Js.Math.random()
    Future.value(
      if random > 0.66 {
        Ok(value)
      } else if random > 0.33 {
        Ok(None)
      } else {
        Error(#UnknownError)
      },
    )
  })
}
