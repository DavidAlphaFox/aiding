-module(ai_ding_message).
-export([text/1]).
-export([send_to_all/2,send_to_departs/3,send_to_users/3,send_to/4]).

send_to_all(AgentID,Message)-> 
    send_to(AgentID,Message,undefined,undefined).
send_to_departs(AgentID,Message,DepartList)->
    send_to(AgentID,Message,DepartList,undefined).
send_to_users(AgentID,Message,UserList)->
    send_to(AgentID,Message,undefined,UserList).
send_to(AgentID,Message,DepartList,UserList)->
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
text(Content)->
    Content0 = ai_string:to_string(Content),
    [
     {<<"msgtype">>,<<"text">>},
     {<<"text">>,[{<<"content">>,Content0}]}
     ].
