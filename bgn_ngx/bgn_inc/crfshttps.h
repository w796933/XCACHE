/******************************************************************************
*
* Copyright (C) Chaoyong Zhou
* Email: bgnvendor@163.com
* QQ: 2796796
*
*******************************************************************************/
#ifdef __cplusplus
extern "C"{
#endif/*__cplusplus*/

#ifndef _CRFSHTTPS_H
#define _CRFSHTTPS_H

#include "type.h"
#include "debug.h"

#include "cstring.h"

#include "csocket.inc"
#include "task.inc"
#include "chttps.inc"

#include "cbuffer.h"
#include "cstrkv.h"
#include "chunk.h"

#include "http_parser.h"

#define CRFSHTTPS_SOCKET_TIMEOUT_NSEC  CONN_TIMEOUT_NSEC

#define CRFSHTTPS_REST_API_NAME            ("/rfs")

EC_BOOL crfshttps_log_start();

EC_BOOL crfshttps_commit_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_http_post(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_http_get(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_http_head(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_commit_end(CHTTP_NODE *chttp_node, EC_BOOL result);
EC_BOOL crfshttps_commit_response(CHTTP_NODE *chttp_node);
/**
    interface name rule:
    crfshttps_is_http_[get|post|put|head|delete]_<op>
    crfshttps_commit_<op>_[get|post|put|head|delete]_request
    crfshttps_handle_<op>_[get|post|put|head|delete]_request
    crfshttps_make_<op>_[get|post|put|head|delete]_response
    crfshttps_commit_<op>_[get|post|put|head|delete]_response
**/

EC_BOOL crfshttps_is_http_post_setsmf(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_setsmf_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_setsmf_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_setsmf_post_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_setsmf_post_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_head_getsmf(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_getsmf_head_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_getsmf_head_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_getsmf_head_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_getsmf_head_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_lock_req(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_lock_req_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_lock_req_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_lock_req_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_lock_req_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_unlock_req(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_unlock_req_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_unlock_req_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_unlock_req_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_unlock_req_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_unlock_notify_req(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_unlock_notify_req_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_unlock_notify_req_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_unlock_notify_req_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_unlock_notify_req_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_breathe(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_breathe_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_breathe_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_breathe_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_breathe_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_retire(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_retire_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_retire_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_retire_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_retire_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_recycle(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_recycle_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_recycle_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_recycle_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_recycle_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_flush(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_flush_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_flush_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_flush_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_flush_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_getsmf(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_getsmf_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_getsmf_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_getsmf_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_getsmf_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_dsmf(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_dsmf_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_dsmf_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_dsmf_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_dsmf_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_ddir(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_ddir_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_ddir_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_ddir_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_ddir_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_sexpire(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_sexpire_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_sexpire_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_sexpire_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_sexpire_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_post_update(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_update_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_update_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_update_post_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_update_post_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_post_renew(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_renew_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_renew_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_renew_post_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_renew_post_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_post_mexpire(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_mexpire_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_mexpire_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_mexpire_post_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_mexpire_post_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_post_mdsmf(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_mdsmf_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_mdsmf_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_mdsmf_post_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_mdsmf_post_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_post_mddir(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_mddir_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_mddir_post_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_mddir_post_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_mddir_post_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_logrotate(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_logrotate_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_logrotate_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_logrotate_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_logrotate_get_response(CHTTP_NODE *chttp_node);


EC_BOOL crfshttps_is_http_get_actsyscfg(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_actsyscfg_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_actsyscfg_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_actsyscfg_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_actsyscfg_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_qtree(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_qtree_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_qtree_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_qtree_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_qtree_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_file_notify(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_file_notify_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_file_notify_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_file_notify_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_file_notify_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_cond_wakeup(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_cond_wakeup_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_cond_wakeup_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_cond_wakeup_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_cond_wakeup_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_renew_header(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_renew_header_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_renew_header_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_renew_header_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_renew_header_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_locked_file_retire(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_locked_file_retire_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_locked_file_retire_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_locked_file_retire_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_locked_file_retire_get_response(CHTTP_NODE *chttp_node);

EC_BOOL crfshttps_is_http_get_paracfg(const CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_paracfg_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_handle_paracfg_get_request(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_make_paracfg_get_response(CHTTP_NODE *chttp_node);
EC_BOOL crfshttps_commit_paracfg_get_response(CHTTP_NODE *chttp_node);

#endif /*_CRFSHTTPS_H*/

#ifdef __cplusplus
}
#endif/*__cplusplus*/

