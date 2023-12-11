const express = require("express");
const jwt = require("jwt-decode");

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
  res.send("Private API route access with user " + stringify(req.user));
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
