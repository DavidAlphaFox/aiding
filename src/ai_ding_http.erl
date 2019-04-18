-module(ai_ding_http).
-include_lib("aihttp/include/ai_url.hrl").
-include("priv/ai_ding_internal.hrl").

-export([get/1,post/1,post_multipart/3]).
-export([exec/1]).

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


exec(Request)->
    Method = Request#ai_ding_request.method,
    ai_ding_http:Method(Request).

get(Request)->
    {ok, ConnPid} = gun:open(?DING_HOST,443, #{transport => tls,protocols => [http]}),
    {ok, _Protocol} = gun:await_up(ConnPid),
    Path = Request#ai_ding_request.url,
    Params = Request#ai_ding_request.params,
    ReqHeaders = Request#ai_ding_request.headers,
    Path0 = query(Path,Params),
    ReqHeaders0 = ai_proplists:merge(ReqHeaders,?DING_COMMON_HEADERS),
    StreamRef = gun:get(ConnPid,Path0,ReqHeaders0),
    case gun:await(ConnPid, StreamRef) of
        {response, fin, Status, RepHeaders} -> {Status,RepHeaders};
        {response, nofin, Status, RepHeaders} ->
            {ok, RepBody} = gun:await_body(ConnPid, StreamRef),
            {Status,RepHeaders,jsx:decode(RepBody)}
    end.
post(Request)->
    {ok, ConnPid} = gun:open(?DING_HOST,443, #{transport => tls,protocols => [http]}),
    {ok, _Protocol} = gun:await_up(ConnPid),
    Path = Request#ai_ding_request.url,
    Params = Request#ai_ding_request.params,
    ReqHeaders = Request#ai_ding_request.headers,
    Path0 = query(Path,Params),
    ReqHeaders0 = ai_proplists:merge(ReqHeaders,?DING_COMMON_HEADERS),
    StreamRef = 
        case Request#ai_ding_request.body of 
            undefined -> gun:post(ConnPid,Path0,ReqHeaders0);
            ReqBody -> gun:post(ConnPid,Path0,ReqHeaders0,ReqBody)
        end,
    case gun:await(ConnPid, StreamRef) of
        {response, fin, Status, RepHeaders} -> {Status,RepHeaders};
        {response, nofin, Status, RepHeaders} ->
            {ok, RepBody} = gun:await_body(ConnPid, StreamRef),
            {Status,RepHeaders,jsx:decode(RepBody)}
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
