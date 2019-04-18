-module(ai_ding_request).
-include("priv/ai_ding_internal.hrl").
-include("ai_ding.hrl").

-export([request/2,request/3]).

new(Name,Url)-> new(Name,Url,[]).
new(Name,Url,Params)-> new(Name,Url,Params,get).
new(Name,Url,Params,Method)->
    #ai_ding_request{
       name = Name,
       url = Url,
       params = Params,
       method = Method,
       headers = [],
       body = undefined
      }.


%% 
%% @doc 获取access_token，正常情况下access_token有效期为7200秒，有效期内重复获取返回相同结果，并自动续期。
%% @params Params中的key为appkey，appsecret,corpid,corpsecret
%%
-spec request(binary(),proplists:proplists()) -> ai_ding_request().
request(?DING_OAPI_GETTOKEN,Params)->
    new(?DING_OAPI_GETTOKEN,<<"/gettoken">>,Params);
%% 
%% @doc 获取部门列表
%% @params Params中的key为access_token,lang,fetch_child,id 其中access_token和id为必须参数
%%         如果id不传，经默认为1,fetch_child ISV微应用固定传递false,lang 默认zh_CN
%%
request(?DING_OAPI_DEPARTMENT_LIST,Params) ->
    Params0 =
        case proplists:get_value(<<"id">>,Params) of
            undefined -> [{<<"id">>,1}|Params];
            _ -> Params
        end,
    new(?DING_OAPI_DEPARTMENT_LIST,<<"/department/list">>,Params0);
%% 
%% @doc 查询指定用户的所有上级父部门路径
%% @params Params中的key为access_token,userId
%%
request(?DING_OAPI_USER_PARENT_DEPARTMENTS,Params) ->
    new(?DING_OAPI_USER_PARENT_DEPARTMENTS,<<"/department/list_parent_depts">>,Params);
%%
%% @doc 查询部门的所有上级父部门路径
%% @params Params中的key为access_token,id
%%
request(?DING_OAPI_DEPARTMENT_PARENT_DEPARTMENTS,Params) ->
    new(?DING_OAPI_DEPARTMENT_PARENT_DEPARTMENTS,<<"/department/list_parent_depts_by_dept">>,Params).

%%
%% @doc 发送工作通知消息
%% @params Params中的key为access_token
%% @params Body为ai_ding_message中所构建的message消息体
%%
request(?DING_OAPI_MESSAGE_CORP_ASYNC,Params,Body)->
    Req0 = new(?DING_OAPI_MESSAGE_CORP_ASYNC,<<"/topapi/message/corpconversation/asyncsend_v2">>,Params,post),
    Req0#ai_ding_request{body = Body}.

