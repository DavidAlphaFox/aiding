-module(ai_ding_message).
-include("ai_ding.hrl").
-export([send_to_all/2,send_to_departs/3,send_to_users/3,send_to/4]).

send_to_all(AgentID,Message)-> 
    send_to(AgentID,Message,undefined,undefined).
send_to_departs(AgentID,Message,DepartList)->
    send_to(AgentID,Message,DepartList,undefined).
send_to_users(AgentID,Message,UserList)->
    send_to(AgentID,Message,undefined,UserList).
send_to(AgentID,Content,DepartList,UserList)->
    Message = build(Content#ai_ding_message.type,Content#ai_ding_message.content),
    Base = [
            {<<"agent_id">>,AgentID},
            {<<"msg">>,Message}
           ],
    case {DepartList,UserList} of 
        {undefined,undefined} ->
            [{<<"to_all_user">>,true} | Base];
        {_,undefined}->
            [{<<"dept_id_list">>,DepartList} | Base];
        {undefined,_}->
            [{<<"userid_list">>,UserList} | Base];
        _ ->
            [{<<"dept_id_list">>,DepartList} ,
             {<<"userid_list">>,UserList}
             | Base]
    end.

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

