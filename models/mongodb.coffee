mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/drifter'

bottleModel = mongoose.model 'Bottle', new mongoose.Schema({
	bottle: Array
	message: Array
	}, {
		collection: 'bottles'
	})

exports.save = (picker, _bottle, callback) ->
	bottle = 
		bottle: []
		message: []

	bottle.bottle.push picker
	bottle.message.push [
		_bottle.time
		_bottle.owner
		_bottle.content
	]
	bottle = new bottleModel bottle
	bottle.save (err) ->
		console.log err,12121212
		callback err


exports.getAll = (user, callback) ->
	bottleModel.find {
		bottle: user
	}, (err, bottles) ->
		return callback {
			code: 0
			msg: '获取漂流瓶失败'
		} if err
		callback {
			code: 1
			msg: bottles
		}

exports.getOne = (_id, callback) ->
	bottleModel.findById _id, (err, bottle) ->
		return callback {
			code: 0
			msg: '读取漂流瓶失败'
		} if err
		console.log bottle,999999
		callback {
			code: 1
			msg: bottle
		}