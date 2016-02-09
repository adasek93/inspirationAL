path = require 'path'
global.rootDir = path.normalize "#{__dirname}/../.."

module.exports =
  port: process.env.VCAP_APP_PORT || 3000
  sessionSecret: '1234567890QWERTY'
  admin:
    name: 'MarkMartin'
    password: 'MarkMartin2013'

  urbanairship:
    baseUrl: 'https://go.urbanairship.com'