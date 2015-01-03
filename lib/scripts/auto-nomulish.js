// Description
//   A Hubot script that translates into the nomulish words automatically
//
// Configuration:
//   HUBOT_AUTO_NOMULISH_P
//   HUBOT_AUTO_NOMULISH_LEVEL
//
// Commands:
//   None
//
// Author:
//   bouzuya <m@bouzuya.net>
//
var cheerio, config, request, _ref, _ref1;

request = require('request-b');

cheerio = require('cheerio');

config = {
  p: parseFloat((_ref = process.env.HUBOT_AUTO_NOMULISH_P) != null ? _ref : '0.1'),
  level: (_ref1 = process.env.HUBOT_AUTO_NOMULISH_LEVEL) != null ? _ref1 : '4'
};

module.exports = function(robot) {
  return robot.hear(/(.+)/i, function(res) {
    var words;
    if (!(Math.random() < config.p)) {
      return;
    }
    words = res.match[1];
    return request({
      method: 'post',
      url: 'http://racing-lagoon.info/nomu/translate.php',
      headers: {
        Referer: 'http://racing-lagoon.info/nomu/translate.php'
      },
      form: {
        before: words,
        level: config.level,
        option: 'nochk',
        new_japanese: '',
        new_nomulish: '',
        trans_btn: '_'
      }
    }).then(function(r) {
      var $, nomulish;
      $ = cheerio.load(r.body);
      nomulish = $('textarea[name=after]').val();
      if (nomulish != null) {
        return res.send(nomulish);
      }
    })["catch"](function(e) {
      robot.logger.error(e);
      return res.send('hubot-auto-nomulish: error');
    });
  });
};
