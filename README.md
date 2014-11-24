INTRODUCTION
-------------------
This is a drifter program which is written by nodejs and redis

ROUTER RULE
-------------------
pick up a drifter
```
GET /?user=xxx[&type=xxx]
// SUCCESS return
{"code": 1, "msg": {"time": "...", "owner": "...", "type": "...", "content": "..."}}
// ERROR return
{"code": 0, "msg": "..."}
```

throw out a drifter
```
POST owner=xxx&type=xxx&content=xxx[&time=xxx]
// SUCCESS return 
{"code": 1, "msg": "..."}
// ERROR return 
{"code": 0, "msg": "..."}