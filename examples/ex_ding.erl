%% -*- coding: utf-8 -*-
-module(ex_ding).
-include("ai_ding.hrl").
-export([all_users_id/0,all_users/0]).
-export([organization/0]).
-export([corp_send_to_user/1,corp_send_to_depart/1]).
access_token()->
    case erlang:get(access_token) of 
        undefined ->
            AppKey = ai_ding_conf:app_key(undefined),
            AppSecret = ai_ding_conf:app_secret(undefined),
            Req = ai_ding_request:request(<<"dingtalk.oapi.gettoken">>,
                                          [{<<"appkey">>,AppKey},{<<"appsecret">>,AppSecret}]),
            {_S,_H,Rep} = ai_ding_http:exec(Req),
            case proplists:get_value(<<"errcode">>,Rep) of
                0 ->
                    AccessToken = proplists:get_value(<<"access_token">>,Rep),
                    erlang:put(access_token,AccessToken),
                    AccessToken;
                _ ->
                    io:format("AccessToken Response: ~p~n",[Rep]),
                    throw(error)
            end;
        AccessToken -> AccessToken
    end.
all_users_id()->
    AccessToken = access_token(),
    ai_ding_organization:department_member(AccessToken).
all_users()-> all_users(true,1,0,[]).
all_users(false,_Depart,_Offset,Acc)->Acc;
all_users(true,Depart,Offset,Acc) ->
    AccessToken = access_token(),
    {_S,_H,Rep} = ai_ding_organization:department_member_page(AccessToken,Depart,Offset,100),
    case proplists:get_value(<<"errcode">>,Rep) of
        0 ->
            UserList = proplists:get_value(<<"userlist">>,Rep),
            Acc0 = lists:foldl(fun(I,A)->[I|A] end,Acc,UserList),
            HasMore = proplists:get_value(<<"hasMore">>,Rep),
            all_users(HasMore,Depart,Offset+100,Acc0);
        42001 ->
            erlang:put(access_token,undefined),
            all_users(true,Depart,Offset,Acc)
    end.
organization()-> 
    Departments = fetch_departments(),
    lists:foreach(fun(Department)->
                          ID = proplists:get_value(<<"id">>,Department),
                          Name = proplists:get_value(<<"name">>,Department),
                          Parent = proplists:get_value(<<"parentid">>,Department),
                          Members = proplists:get_value(<<"member">>,Department),
                          io:format("ID: ~p, Name: ~ts, Parent: ~p~n",[ID,Name,Parent]),
                          io:format("Members: ~n"),
                          lists:foreach(fun(Member)->
                                              MID = proplists:get_value(<<"userid">>,Member),
                                              MName = proplists:get_value(<<"name">>,Member),
                                              io:format("    +ID: ~p, Name: ~ts ~n",[MID,MName])
                                      end,Members),
                          io:format("~n")
                  end,Departments).


fetch_departments()->
    AccessToken = access_token(),
    {_S,_H,Rep} = ai_ding_organization:departments(AccessToken),
    case proplists:get_value(<<"errcode">>,Rep) of 
        0 ->
            Departments = proplists:get_value(<<"department">>,Rep),
            lists:map(fun(Department)->
                              ID = proplists:get_value(<<"id">>,Department),
                              Member = all_users(true,ID,0,[]),
                              [{<<"member">>,Member}|Department]
                      end,Departments);
        42001 ->
            erlang:put(access_token,undefined),
            fetch_departments()
    end.
corp_send_to_user(UserID)->
    AgentID = ai_ding_conf:app_id(undefined),
    AccessToken = access_token(),
    ai_ding_message:corp_send_to_users(AgentID,AccessToken,#ai_ding_message{
                                                         type = text,
                                                         content = <<"单条测试消息"/utf8>>
                                                        },UserID).
corp_send_to_depart(DepartID)->
    AgentID = ai_ding_conf:app_id(undefined),
    AccessToken = access_token(),
    ai_ding_message:corp_send_to_departs(AgentID,AccessToken,#ai_ding_message{
                                                         type = text,
                                                         content = <<"部门测试消息"/utf8>>
                                                        },DepartID).
