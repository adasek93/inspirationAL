fs = require 'fs'

exports.filesInDirectory = (path, options = {}) ->
  path = rootDir + path
  omitDirectory = options.omitDirectory
  fs.readdirSync(path).forEach (file) ->
    newPath = "#{path}/#{file}"
    stat = fs.statSync newPath
    if (stat.isFile())
      if (/(.*)\.(js$|coffee$)/.test(file))
        np = require(newPath)
        np(options.app) if options.app and typeof np is 'function'
        
    else if (stat.isDirectory() and file is not omitDirectory)
      walk(newPath)
