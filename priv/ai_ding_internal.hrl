-record(ai_ding_request,{
                         url,
                         name,
                         params,
                         body,
                         method,
                         headers
                        }).
-type ai_ding_request() :: #ai_ding_request{}.
-define(DING_OAPI_GETTOKEN,<<"dingtalk.oapi.gettoken">>).
