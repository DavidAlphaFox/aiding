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
-define(DING_OAPI_GETTOKEN,<<"dingtalk.oapi.gettoken">>).
-define(DING_OAPI_MESSAGE_CORP_ASYNC,<<"dingtalk.oapi.message.corpconversation.asyncsend_v2">>).
