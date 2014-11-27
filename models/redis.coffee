redis = require 'redis'
client = redis.createClient()
client2 = redis.createClient()
client3 = redis.createClient()

# 扔一个瓶子
exports.throw = (bottle, callback) ->
	client2.SELECT 2, () ->
		client2.GET bottle.owner, (err, result) ->
			# 大于10次就不让丢
			return callback {
				code: 0
				msg: '今天的瓶子已经丢完啦！'
			} if result >= 10
			# 扔瓶子的次数+1
			client2.INCR bottle.owner, () ->
				# 检查是不是当天第一次丢瓶子
				# 如果是，设置键的生存周期
				# 如果不是，保持生存周期不变
				client2.TTL bottle.owner, (err, ttl) ->
					client2.EXPIRE bottle.owner, 86400 if ttl == -1
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
exports.pick = (info, callback) ->
	# 先到3号数据库检查用户是否超过捡瓶子的次数
	client3.SELECT 3, () ->
		client3.GET info.user, (err, result) ->
			return callback {
				code: 0
				msg: '今天的瓶子已经捡完啦！'
			} if result >= 10
			# 捡的次数+1
			client3.INCR info.user, () ->
				# 如果是当天第一次捡瓶子
				# 记录的有效期设为1天
				# 如果不是第一次，则不管有效期
				client3.TTL info.user, (err, ttl) ->
					client3.EXPIRE info.user, 84600
			# 海星的几率
			return callback {
				code: 0,
				msg: '海星'
			} if Math.random() <= 0.2

			type = 
				all: Math.round(Math.random())
				male: 0
				female: 1
			info.type = info.type || 'all'
			# 根据请求类型去数据库中查询
			client.SELECT type[info.type], () ->
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


# 扔回瓶子
exports.throwBack = (bottle, callback) ->
	type = 
		male: 0
		female: 1
	bottleId = Math.random().toString(16)
	client.SELECT type[bottle.type], ()->
		client.HMSET bottleId, bottle, (err, result) ->
			return callback {
				code: 0
				msg: '过会儿再试试吧！'
			} if err
			callback {
				code: 1
				msg: result
			}
			client.PEXPIRE bottleId, bottle.time + 84600000 - Date.now()