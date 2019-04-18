-module(ai_ding_request).
-include("priv/ai_ding_internal.hrl").

-export([request/2]).

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
    new(?DING_OAPI_GETTOKEN,<<"/gettoken">>,Params).

