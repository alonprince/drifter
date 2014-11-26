// var request = require('request')

// for(var i = 1; i < 6; i++) {
// 	(function(i) {
// 		request.post({
// 			url: 'http://127.0.0.1:3000',
// 			json: {"owner": 'bottle' + i, type: 'male', content: 'content' + i}
// 		},function(err,response) {
// 			console.log(err,1)
// 		})
// 	})(i)
// }

// for(var i = 6; i < 11; i++) {
// 	(function(i) {
// 		request.post({
// 			url: 'http://127.0.0.1:3000',
// 			json: {"owner": 'bottle' + i, type: 'female', content: 'content' + i}
// 		},function(err,response) {
// 			console.log(err, 2)
// 		})
// 	})(i)
// }

require('coffee-script/register')
require('./init_redis.coffee')