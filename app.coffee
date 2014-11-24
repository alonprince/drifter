express = require 'express'
redis = require './models/redis'

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
		res.json result


app.listen 3000