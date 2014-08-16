
{Promise} = require 'q'
request = require 'request'
cheerio = require 'cheerio'

requestArm = (params) ->
  options = params.armOptions ? {}
  delete params.armOptions
  new Promise (resolve, reject) ->
    request params, (err, res) ->
      return reject(err) if err?
      switch
        when options.format is 'html'
          try
            res.$ = cheerio.load res.body
          catch e
            reject e
        when options.format is 'json'
          try
            res.json = JSON.parse res.body
          catch e
            reject e
      resolve res

module.exports = (robot) ->

  robot.arm = (type) ->
    if type is 'request'
      requestArm
    else
      throw new Error 'unknown arm type: ' + type

  robot
