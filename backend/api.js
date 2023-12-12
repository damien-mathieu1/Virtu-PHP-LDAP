const express = require("express");
const jwt = require("jwt-decode");
const dbconfig = {
  host: "mysql",
  user: "keycloak",
  password: "password",
  database: "keycloak",
};
const jsORM = require("js-hibernate");
const session = jsORM.session(dbconfig);

const app = express();
const port = 3000;

const authenticateToken = (req, res, next) => {
  const token = req.header("Authorization");

  if (!token) {
    return res.sendStatus(401);
  }

  let decode = jwt.jwtDecode(token);
  if (!decode) {
    return res.sendStatus(403);
  } else {
    req.user = decode;
  }

  next();
};

function stringify(obj) {
  let cache = [];
  let str = JSON.stringify(obj, function (key, value) {
    if (typeof value === "object" && value !== null) {
      if (cache.indexOf(value) !== -1) {
        // Circular reference found, discard key
        return;
      }
      // Store value in our collection
      cache.push(value);
    }
    return value;
  });
  cache = null; // reset the cache
  return str;
}

app.get("/api/public", (req, res) => {
  res.send("Public API route access");
});

app.get("/api/private", authenticateToken, (req, res) => {
  var sql = "select username from `USER_ENTITY`";
  var query = session.executeSql(sql);

  query
    .then(function (result) {
      res.send("Private API route access <h3>authenticated user :</h3> " + stringify(req.user) +"<br> <h3>list of users in keycloak :</h3>" + stringify(result));
    })
    .catch(function (error) {
      res.send("Private API route access <h3>authenticated user :</h3>  " + stringify(req.user) + "<br> <h3>error :</h3>" + stringify(error));

    });
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
