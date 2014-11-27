request = require 'request'

for i in [1...6]
	do (i) ->
		request.post {
			url: 'http://127.0.0.1:3000',
			json: 
				owner: "bottle1"
				type: 'male'
				content: "content #{i}"
		}, (err, response, body) ->
			console.log body

for i in [6...11]
	do (i) ->
		request.post {
			url: 'http://127.0.0.1:3000',
			json: 
				owner: "bottle#{i}"
				type: 'female'
				content: "content #{i}"
		}, (err, response, body) ->
			console.log body,22222
		
