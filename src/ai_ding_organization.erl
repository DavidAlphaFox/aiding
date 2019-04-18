-module(ai_ding_organization).
-include("ai_ding.hrl").

-export([departments/2,departments/1,departments/3]).
-export([department_parent_departments/2,user_parent_departments/2]).
departments(AccessToken)-> departments(AccessToken,1).
departments(AccessToken,DepartID)-> departments(AccessToken,DepartID,[]).
departments(AccessToken,DepartID,Others)->
    Base =
        [
         {<<"access_token">>,AccessToken},
         {<<"id">>,DepartID}
        ],
    Params = ai_proplists:merge(Others,Base),
    Req = ai_ding_request:request(?DING_OAPI_DEPARTMENT_LIST,Params),
    ai_ding_http:exec(Req).
user_parent_departments(AccessToken,UserID)->
    Req = ai_ding_request:request(?DING_OAPI_USER_PARENT_DEPARTMENTS,
                                  [
                                   {<<"access_token">>,AccessToken},
                                   {<<"userId">>,UserID}
                                  ]),
    ai_ding_http:exec(Req).
department_parent_departments(AccessToken,DepartID)->
    Req = ai_ding_request:request(?DING_OAPI_DEPARTMENT_PARENT_DEPARTMENTS,
                                  [
                                   {<<"access_token">>,AccessToken},
                                   {<<"id">>,DepartID}
                                  ]),
    ai_ding_http:exec(Req).
