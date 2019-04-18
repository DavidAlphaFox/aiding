-module(ai_ding_http).
-include_lib("aihttp/include/ai_url.hrl").
-include("priv/ai_ding_internal.hrl").

-export([post/3,post_multipart/3]).

-export([get/1]).

-define(DING_COMMON_HEADERS,[
                             {<<"Content-Type">>, <<"application/json">>},
                             {<<"accept">>, "application/json"},
                             {<<"user-agent">>, "ai_ding/0.1.0"}
                            ]).


query(URL,Query)->
    Parsed = ai_url:parse(URL),
    Q1 =
        case Parsed#ai_url.qs of 
            undefined -> [];
            QS -> QS 
        end,
    Q2 = ai_proplists:merge(Query,Q1),
    Parsed0 = Parsed#ai_url{qs = Q2},
    ai_url:build(Parsed0).


get(Request)->
    {ok, ConnPid} = gun:open(?DING_HOST,443, #{transport => tls}),
    {ok, _Protocol} = gun:await_up(ConnPid),
    Path = Request#ai_ding_request.url,
    Params = Request#ai_ding_request.params,
    Headers = Request#ai_ding_request.headers,
    Path0 = query(Path,Params),
    Headers0 = ai_proplists:merge(Headers,?DING_COMMON_HEADERS),
    StreamRef = gun:get(ConnPid,Path0,Headers0),
    case gun:await(ConnPid, StreamRef) of
        {response, fin, Status, Headers} -> {Status,Headers};
        {response, nofin, Status, Headers} ->
            {ok, Body} = gun:await_body(ConnPid, StreamRef),
            {Status,Headers,jsx:decode(Body)}
    end.
post(HOST,Path, ReqBody) ->
    {ok, ConnPid} = gun:open(HOST,443, #{transport => tls}),
    {ok, _Protocol} = gun:await_up(ConnPid),

    StreamRef = gun:post(ConnPid,Path,[
        {<<"Content-Type">>, <<"application/json">>},
        {<<"accept">>, "application/json"},
        {<<"user-agent">>, "ai_ding/0.1.0"}
    ],ReqBody),
    case gun:await(ConnPid, StreamRef) of
        {response, fin, Status, Headers} -> {Status,Headers};
        {response, nofin, Status, Headers} ->
            {ok, ResBody} = gun:await_body(ConnPid, StreamRef),
            {Status,Headers,jsx:decode(ResBody)}
    end.
post_multipart(HOST,Path,File)->
    {ok, ConnPid} = gun:open(HOST,443, #{transport => tls}),
    {ok, _Protocol} = gun:await_up(ConnPid),
    {Boundary,EncodeForm,Length} =  ai_multipart:encode([{file,<<"media">>,File,[]}]),
    StreamRef = gun:post(ConnPid,Path,[
        {<<"Content-Type">>, <<"multipart/form-data; boundary=",Boundary/binary>>},
        {<<"Content-Length">>,ai_string:to_string(Length)},
        {<<"accept">>, "application/json"},
        {<<"user-agent">>, "ai_ding/0.1.0"}
    ],EncodeForm),
    case gun:await(ConnPid, StreamRef) of
        {response, fin, Status, Headers} -> {Status,Headers};
        {response, nofin, Status, Headers} ->
            {ok, ResBody} = gun:await_body(ConnPid, StreamRef),
            {Status,Headers,jsx:decode(ResBody)}
    end.
