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
		_bottle.owner
		_bottle.time
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

exports.reply = (_id, reply, callback) ->
	reply.time = reply.time || Date.now()
	bottleModel.findById _id, (err, _bottle) ->
		return callback {
			code: 0
			msg: "回复漂流瓶失败"
		} if err
		newBottle = {}
		newBottle.bottel = _bottle.bottle
		newBottle.message = _bottle.message
		# 如果捡瓶子的人第一次回复漂流瓶，则在bottle键添加漂流瓶的主人
		# 如果已经回复过漂流瓶，则不再添加
		newBottle.bottle.push _bottle.message[0][0] if newBottle.bottle.length == 1
		# 在message中添加一条回复信息
		newBottle.message.push [reply.user, reply.time, reply.content]
		# 更新数据库中该漂流瓶信息
		bottleModel.findByIdAndUpdate _id, newBottle, (err, bottle) ->
			return callback {
				code: 0
				msg: '回复漂流瓶失败'
			} if err
			callback {
				code: 1
				msg: bottle
			}


exports.delete = (_id, callback) ->
	# 通过id删除瓶子
	bottleModel.findByIdAndRemove _id, (err) ->
		return callback {
			code: 0
			msg: '删除漂流瓶失败...'
		} if err
		callback {
			code: 1
			msg: '删除成功'
		}



