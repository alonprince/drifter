redis = require 'redis'
client = redis.createClient()

# 扔一个瓶子
exports.throw = (bottle, callback) ->
	bottle.time = bottle.time || Date.now()
	# 生成一个id,这里我用的是时间戳
	bottleId = Math.random().toString(16)
	type = 
		male: 0
		female: 1

	# 根据type不同，选取不同的数据库
	client.SELECT type[bottle.type], () ->
		client.HMSET bottleId, bottle, (err, result) ->
			return callback {
				"code": 0
				"msg": "过会儿再试"
			} if err

			# 返回结果
			callback {
				"code": 1
				"msg": result
			}
			# 设置漂流瓶生存期限为1天
			client.EXPIRE bottleId, 86400


# 捡一个瓶子
exports.pick = (query, callback) ->
	# 海星的几率
	return callback {
		code: 0,
		msg: '海星'
	} if Math.random() <= 0.2

	type = 
		all: Math.round(Math.random())
		male: 0
		female: 1
	query.type = query.type || 'all'
	# 根据请求类型去数据库中查询
	client.SELECT type[query.type], () ->
		# 随机返回一个漂流瓶id
		client.RANDOMKEY (err, bottleId) ->
			return callback {
				code: 0
				msg: '海星'
			} unless bottleId

			# 根据id取到相关信息
			client.HGETALL bottleId, (err, bottle) ->
				return callback {
					code: 0
					msg: '您的漂流瓶破损了'
				} if err
				# 返回漂流瓶信息
				callback {
					code: 1,
					msg: bottle
				}
				# 看完就删
				client.DEL bottleId