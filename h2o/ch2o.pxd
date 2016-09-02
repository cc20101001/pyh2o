cdef extern from "h2o.h":

    ctypedef struct h2o_globalconf_t:
        void* dummy[1024]

    void h2o_config_init(h2o_globalconf_t* config)
    void h2o_config_dispose(h2o_globalconf_t* config)
