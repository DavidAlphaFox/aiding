# 钉钉SDK

## 说明
由于[钉钉(DingTalk)](https://open-doc.dingtalk.com/)并未提供官方的Erlang版本的
	SDK，因此才编写的这个Erlang版本的SDK，用来完成钉钉平台所有的操作

## 功能


## 如何使用

### 依赖

因使用erlang.mk进行的构建管理，因此需要 GNU Make 4 及以上来进行构建

依赖的类库

* cowlib
* gun
* ranch
* cowboy
* poolboy
* jsx
* ailib
* aihttp

### 使用

#### 配置微信相关信息

在项目启动后需要使用ai_ding_conf来进行钉钉配置

    ai_ding_conf:start(Module)

其中的`Module`为包含钉钉配置信息的模块，该模块需要支持以下行为

    -callback app_token(Context) -> string().
    -callback app_isv(Context)-> boolean().
    -callback app_secret(Context)-> string().
    -callback app_key(Context)-> string().
    -callback app_id(Context) -> string().
    

`Context` 是一个获取各配置的上下文，需要使用者去指定

* `app_key`为`基础信息`中的`AppKey`当为ISV应用时是`suiteKey`
* `app_secret`为`基础信息`中的`AppSecret`当为ISV应用时是`suiteSecret`
* `app_token`为`基础消息`中的`Token` (仅限ISV应用)
* `app_key`为`基础消息`中的`数据加密密钥(ENCODING_AES_KEY)` (仅限ISV应用)
* `app_isv`在ISV应用时应返回`true`
* `app_id`为`基础消息`中的`AgentId`

#### 消息处理handler
