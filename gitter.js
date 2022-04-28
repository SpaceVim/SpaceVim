var https = require('https');

var roomId    = '586c6a98d73408ce4f410f71';
var token     = '7b7b7d7e032656f9a22db6e9582b56fd416cdf07';
var heartbeat = " \n";

var options = {
  hostname: 'stream.gitter.im',
  port:     443,
  path:     '/v1/rooms/' + roomId + '/chatMessages',
  method:   'GET',
  headers:  {'Authorization': 'Bearer ' + token}
};

var req = https.request(options, function(res) {
  res.on('data', function(chunk) {
    var msg = chunk.toString();
    if (msg !== heartbeat) console.log(msg);
  });
});

req.on('error', function(e) {
  console.log('Something went wrong: ' + e.message);
});

req.end();
