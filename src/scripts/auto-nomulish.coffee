# Description
#   A Hubot script that translates into the nomulish words automatically
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
request = require 'request-b'
cheerio = require 'cheerio'

config =
  p: parseFloat(process.env.HUBOT_AUTO_NOMULISH_P ? '0.1')
  level: process.env.HUBOT_AUTO_NOMULISH_LEVEL ? '4'

module.exports = (robot) ->
  robot.hear /(.+)/i, (res) ->
    return unless Math.random() < config.p

    words = res.match[1]

    request(
      method: 'post'
      url: 'http://racing-lagoon.info/nomu/translate.php'
      headers:
        Referer: 'http://racing-lagoon.info/nomu/translate.php'
      form:
        before: words
        level: config.level
        option: 'nochk'
        new_japanese: ''
        new_nomulish: ''
        trans_btn: '_'
    )
    .then (r) ->
      $ = cheerio.load r.body
      nomulish = $('textarea[name=after]').val()
      res.send(nomulish) if nomulish?
    .catch (e) ->
      robot.logger.error e
      res.send 'hubot-auto-nomulish: error'
