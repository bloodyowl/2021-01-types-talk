let React = require("react");
let ReactDOM = require("react-dom");
let RandomUser = require("../shared/RandomUser");

function App() {
  let [user, setUser] = React.useState({
    isLoading: false,
    data: null,
    error: null,
  });

  let loadNewItem = () => {
    setUser({ isLoading: true, data: null, error: null });
    RandomUser.query().then(
      (data) => {
        setUser({ isLoading: false, data, error: null });
      },
      (error) => {
        setUser({ isLoading: false, data: null, error });
      }
    );
  };

  return (
    <>
      <button onClick={loadNewItem} disabled={user.isLoading}>
        {!user.isLoading && user.data == null && user.error == null
          ? "Get a random person"
          : user.isLoading
          ? "Loading"
          : user.error
          ? "Try again"
          : "Get another one"}
      </button>
      <br />
      {user.isLoading ||
      (user.data == null && user.error == null) ? null : user.error != null ? (
        "An error occured"
      ) :
      user.data != null ? (
        <>
          {user.data.picture != null ? (
            <img
              src={user.data.picture.large}
              width="200"
              height="200"
              alt={`${user.data.name.first} ${user.data.name.last}`}
            />
          ) : (
            <div className="default-image" />
          )}
          {user.data.email}
        </>
      ) : (
        "No result was received"
      )}
    </>
  );
}

let root = document.querySelector("#root");
if (root != null) {
  ReactDOM.render(<App />, root);
}
