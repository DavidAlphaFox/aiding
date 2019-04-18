-module(aiding).

%% API
-export([start/0]).

start() ->
    ok = application:start(crypto),
    ok = application:start(asn1),
    ok = application:start(public_key),
    ok = application:start(ssl),
    ok = application:start(inets),
    ok = application:start(ranch),
    ok = application:start(cowlib),
    ok = application:start(cowboy),
    ok = application:start(gun),
    ok = application:start(jsx),
    ok = application:start(ailib),
    ok = application:start(aihttp).
