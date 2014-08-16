# Description
#   A Hubot script that translates into the nomulish words automatically
#
# Dependencies:
#   "cheerio": "^0.17.0",
#   "q": "^1.0.1",
#   "request": "^2.40.0"
#
# Configuration:
#   HUBOT_AUTO_NOMULISH_P
#   HUBOT_AUTO_NOMULISH_LEVEL
#
# Commands:
#   None
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  require('../request-arm')(robot)

  P = parseFloat(process.env.HUBOT_AUTO_NOMULISH_P ? '0.1')
  LEVEL = process.env.HUBOT_AUTO_NOMULISH_LEVEL ? '4'

  robot.hear /(.+)/i, (res) ->
    return unless Math.random() < P

    words = res.match[1]

    robot
      .arm('request')
        method: 'post'
        url: 'http://racing-lagoon.info/nomu/translate.php'
        form:
          before: words
          level: LEVEL
          transbtn: '_'
        armOptions:
          format: 'html'
      .then (ret) ->
        nomulish = ret.$('textarea[name=after]').val()
        res.send(nomulish) if nomulish?
      .then null, (e) ->
        robot.logger.error e
        res.send e
