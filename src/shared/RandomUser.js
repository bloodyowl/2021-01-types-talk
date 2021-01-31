module.exports = {
  query: () => {
    return fetch("https://randomuser.me/api/")
      .then((res) => (res.status != 200 ? Promise.reject(res.status) : res))
      .then((res) => res.json())
      .then((res) => {
        let random = Math.random();
        return random > 0.66
          ? res.results[0]
          : random > 0.33
          ? undefined
          : Promise.reject(404);
      });
  },
};
