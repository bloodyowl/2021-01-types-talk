open Belt

module App = {
  @react.component
  let make = () => {
    let (user, setUser) = React.useState(() => AsyncData.NotAsked)

    let loadNewItem = () => {
      setUser(_ => Loading)
      RandomUser.query()->Future.get(value => {
        setUser(_ => Done(value))
      })
    }

    <>
      <button onClick={_ => loadNewItem()} disabled={user == Loading}>
        {React.string(
          switch user {
          | NotAsked => "Get a random person"
          | Loading => "Loading"
          | Done(Error(_) | Ok(None)) => "Try again"
          | Done(Ok(Some(_))) => "Get another one"
          },
        )}
      </button>
      <br />
      {switch user {
      | NotAsked | Loading => React.null
      | Done(Error(_)) => "An error occured"->React.string
      | Done(Ok(Some({email, picture, name: {first, last}}))) => <>
          {switch picture {
          | Some({large}) => <img src={large} width="200" height="200" alt={`${first} ${last}`} />
          | None => <div className="default-image" />
          }}
          {email->React.string}
        </>
      | Done(Ok(None)) => "No result was received"->React.string
      }}
    </>
  }
}

ReactDOM.querySelector("#root")->Option.map(ReactDOM.render(<App />))
