from libc.stdint cimport uint16_t


cdef extern from "h2o.h":

    ctypedef struct h2o_iovec_t:
        char* base
        size_t len

    h2o_iovec_t h2o_iovec_init(const void* base, size_t len)

    ctypedef struct h2o_globalconf_t:
        h2o_hostconf_t** hosts

    ctypedef struct h2o_hostconf_t:
        pass

    ctypedef struct h2o_pathconf_t:
        pass

    void h2o_config_init(h2o_globalconf_t* conf)
    h2o_hostconf_t* h2o_config_register_host(h2o_globalconf_t* conf, h2o_iovec_t host, uint16_t port)
    h2o_pathconf_t* h2o_config_register_path(h2o_hostconf_t* hostconf, const char* path, int flags)
    void h2o_config_dispose(h2o_globalconf_t* conf)

    ctypedef struct h2o_handler_t:
        int (*on_req)(h2o_handler_t* self, h2o_req_t* req)

    h2o_handler_t* h2o_create_handler(h2o_pathconf_t* pathconf, size_t sz)

    ctypedef struct h2o_loop_t:
        pass

    h2o_loop_t* h2o_evloop_create()
    int h2o_evloop_run(h2o_loop_t* loop, int max_wait) nogil

    ctypedef struct h2o_context_t:
        pass

    void h2o_context_init(h2o_context_t* ctx, h2o_loop_t* loop, h2o_globalconf_t* conf)

    ctypedef struct h2o_socket_t:
        void* data

    ctypedef void (*h2o_socket_cb)(h2o_socket_t* sock, const char* err)

    h2o_socket_t* h2o_evloop_socket_create(h2o_loop_t* loop, int fd, int flags)
    h2o_socket_t* h2o_evloop_socket_accept(h2o_socket_t* listener)
    void h2o_socket_read_start(h2o_socket_t* sock, h2o_socket_cb cb)
    void h2o_socket_close(h2o_socket_t* sock)

    ctypedef struct h2o_accept_ctx_t:
        h2o_context_t* ctx
        h2o_hostconf_t** hosts

    void h2o_accept(h2o_accept_ctx_t* ctx, h2o_socket_t* sock)

    ctypedef struct h2o_res_t:
        int status

    ctypedef struct h2o_req_t:
        h2o_iovec_t authority
        h2o_iovec_t method
        h2o_iovec_t path
        int version
        h2o_res_t res

    ctypedef struct h2o_generator_t:
        void (*proceed)(h2o_generator_t* self, h2o_req_t* req)
        void (*stop)(h2o_generator_t* self, h2o_req_t* req)

    void h2o_start_response(h2o_req_t* req, h2o_generator_t* generator)
    void h2o_send(h2o_req_t* req, h2o_iovec_t* bufs, size_t bufcnt, int state)
    void h2o_send_inline(h2o_req_t* req, const char* body, size_t len)

    void* alloca(size_t size)
