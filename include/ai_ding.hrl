-record(ai_ding_link_msg,{
                          message_url,
                          pic_url,
                          title,
                          text
                         }).
-record(ai_ding_media_msg,{
                           media_id,
                           duration
                         }).
-record(ai_ding_oa_msg_header,{
                               bgcolor,
                               text
                              }).
-record(ai_ding_oa_msg_body,{
                             title,
                             form,
                             rich,
                             content,
                             image,
                             file_count,
                             author
                            }).
-record(ai_ding_oa_msg,{
                        message_url,
                        pc_message_url,
                        header,
                        body
                       }).
-record(ai_ding_markdown_msg,{
                              title,
                              text
                             }).
-record(ai_ding_action_card_msg,{
                                 title,
                                 markdown,
                                 single_title,
                                 single_url,
                                 btn_orientation,
                                 btn_json_list
                                }).
-record(ai_ding_message,{
                         type,
                         content
                        }).
%% @doc 获得access_token
-define(DING_OAPI_GETTOKEN,<<"dingtalk.oapi.gettoken">>).
%% @doc 异步发送工作消息
-define(DING_OAPI_MESSAGE_CORP_ASYNC,<<"dingtalk.oapi.message.corpconversation.asyncsend_v2">>).
%% @doc 获取部门列表
-define(DING_OAPI_DEPARTMENT_LIST,<<"dingtalk.oapi.department.list">>).
%% @doc 获取子部门ID列表
-define(DING_OAPI_DEPARTMENT_ID_LIST,<<"dingtalk.oapi.department.list_ids">>).
%% @doc 获取部门详情
-define(DING_OAPI_DEPARTMENT,<<"dingtalk.oapi.department.get">>).
%% @doc 查询指定用户的所有上级父部门路径
-define(DING_OAPI_USER_PARENT_DEPARTMENTS,<<"dingtalk.oapi.department.list_parent_depts">>).
%% @doc 查询部门的所有上级父部门路径
-define(DING_OAPI_DEPARTMENT_PARENT_DEPARTMENTS,<<"dingtalk.oapi.department.list_parent_depts_by_dept">>).
%% @doc 获取部门用户userid列表
-define(DING_OAPI_DEPARTMENT_MEMBER,<<"dingtalk.oapi.user.getDeptMember">>).
%% @doc 获取部门用户
-define(DING_OAPI_DEPARTMENT_MEMBER_PAGE,<<"dingtalk.oapi.user.simplelist">>).
%% @doc 获取部门用户详情
-define(DING_OAPI_DEPARTMENT_MEMBER_DETAILS,<<"dingtalk.oapi.user.listbypage">>).
