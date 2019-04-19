-module(ai_ding_message).
-include("ai_ding.hrl").
-export([corp_send_to_all/3,corp_send_to_departs/4,corp_send_to_users/4,corp_send_to/5]).

corp_send_to_all(AgentID,AccessToken,Message)-> 
    corp_send_to(AgentID,AccessToken,Message,undefined,undefined).
corp_send_to_departs(AgentID,AccessToken,Message,DepartList)->
    corp_send_to(AgentID,AccessToken,Message,DepartList,undefined).
corp_send_to_users(AgentID,AccessToken,Message,UserList)->
    corp_send_to(AgentID,AccessToken,Message,undefined,UserList).

corp_send_to(AgentID,AccessToken,Content,undefined,undefined)->
    corp_send_to(AgentID,AccessToken,Content,[{<<"to_all_user">>,true}]);
corp_send_to(AgentID,AccessToken,Content,DepartList,undefined)->
    ToAll = lists:any(fun(Depart) -> (Depart == 1) or (Depart == <<"1">>) or (Depart == "1") end,DepartList ),
    Other = 
        if
            ToAll == true -> [{<<"to_all_user">>,true}];
            true ->
                DepartList0 = ai_string:join(DepartList,<<",">>),
                [{<<"dept_id_list">>,DepartList0}]
        end,
    corp_send_to(AgentID,AccessToken,Content,Other);
corp_send_to(AgentID,AccessToken,Content,undefined,UserList)->
    UserList0 = ai_string:join(UserList,<<",">>),
    corp_send_to(AgentID,AccessToken,Content,[{<<"userid_list">>,UserList0}]);
corp_send_to(AgentID,AccessToken,Content,DepartList,UserList)->
    ToAll = lists:any(fun(Depart) -> (Depart == 1) or (Depart == <<"1">>) or (Depart == "1") end,DepartList ),
    Other = 
        if 
            ToAll == true -> [{<<"to_all_user">>,true}];
            true ->
                DepartList0 = ai_string:join(DepartList,<<",">>),
                UserList0 = ai_string:join(UserList,<<",">>),
                [{<<"dept_id_list">>,DepartList0} ,
                 {<<"userid_list">>,UserList0}
                ]
        end,
    corp_send_to(AgentID,AccessToken,Content,Other).

corp_send_to(AgentID,AccessToken,Content,Other)->
    Message = build(Content#ai_ding_message.type,Content#ai_ding_message.content),
    Message0 = [
                {<<"agent_id">>,AgentID},
                {<<"msg">>,Message} | Other],
    Req = ai_ding_request:request(?DING_OAPI_MESSAGE_CORP_ASYNC,[{<<"access_token">>,AccessToken}],jsx:encode(Message0)),
    ai_ding_http:exec(Req).

build(text,Content)->
    Content0 = ai_string:to_string(Content),
    [
     {<<"msgtype">>,<<"text">>},
     {<<"text">>,[{<<"content">>,Content0}]}
    ];
build(image,Content) ->
    [
     {<<"msgtype">>,<<"image">>},
     {<<"image">>,[{<<"media_id">>,
                    ai_string:to_string(Content#ai_ding_media_msg.media_id)
                   }]}
    ];
build(voice,Content) ->
    [
     {<<"msgtype">>,<<"voice">>},
     {<<"voice">>,[
                   {<<"media_id">>,
                    ai_string:to_string(Content#ai_ding_media_msg.media_id)},
                   {<<"duration">>,
                    ai_string:to_string(Content#ai_ding_media_msg.duration)}
                  ]}
    ];
build(file,Content) ->
    [
     {<<"msgtype">>,<<"file">>},
     {<<"file">>,[{<<"media_id">>,
                   ai_string:to_string(Content#ai_ding_media_msg.media_id)
                  }]}
    ];
build(link,Content)->
    [
     {<<"msgtype">>,<<"link">>},
     {<<"link">>,[
                  {<<"messageUrl">>,
                   ai_string:to_string(Content#ai_ding_link_msg.message_url)},
                  {<<"picUrl">>,
                   ai_string:to_string(Content#ai_ding_link_msg.pic_url)},
                  {<<"title">>,
                   ai_string:to_string(Content#ai_ding_link_msg.title)},
                  {<<"text">>,
                   ai_string:to_string(Content#ai_ding_link_msg.text)}
                 ]}
    ].

