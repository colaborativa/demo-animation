var connect = require('connect');
var serveStatic = require('serve-static');
console.log("live on 8080 port");
connect().use(serveStatic(__dirname)).listen(8080);