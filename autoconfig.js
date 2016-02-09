process.argv[1] = require("path").resolve("server.js");
require("cf-autoconfig");
process.nextTick(require("module").Module.runMain);
