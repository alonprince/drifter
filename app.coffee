express = require 'express'
redis = require './models/redis'
mongodb = require './models/mongodb.coffee'

app = express()
app.use express.bodyParser()

# 扔一个瓶子
# owner=xxx&type=xxx&content=xxx[&time=xxx]
app.post '/', (req, res) ->
	unless req.body.type? && req.body.content? && req.body.owner
		return res.json({"code": 0, "msg": "类型错误"}) if req.body.type? && (['female', 'male'].indexOf(req.body.type) == -1)
		return res.json {
			"code": 0
			"msg": "信息不完整"
		}
	redis.throw req.body, (result) ->
		res.json result

# 捡一个瓶子
# /?user=xxx[&type=xxx]
app.get '/', (req, res) ->
	return res.json {
		"code": 0
		"msg": "信息不完整"
	} unless req.query.user

	if req.query.type? && (['male', 'female'].indexOf(req.query.type) == -1) 
		return res.json {
			"code": 0
			"msg": "类型错误"
		}

	redis.pick req.query, (result) ->
		if result.code == 1
			# 原书此处没有return掉，导致只return 出去了1层，继续执行下面的res.json
			# 会报错  Can't set headers after they are sent
			return mongodb.save req.query.user, result.msg, (err) ->
				return res.json {
					code: 0
					msg: '获取漂流瓶失败，请重试'
				} if err
				return res.json result

		res.json result

# 扔回海里
app.post '/back', (req, res) ->
	redis.throwBack req.body, (result) ->
		res.json result

# 获取一个用户所有的漂流瓶
app.get '/user/:user', (req, res) ->
	mongodb.getAll req.params.user, (result) ->
		res.json result

# 获取特定id的漂流瓶
app.get '/bottle/:id', (req, res) ->
	mongodb.getOne req.params._id, (result) ->
		res.json result

app.listen 3000