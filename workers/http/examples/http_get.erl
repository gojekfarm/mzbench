[ % this example is almost similar to simple_http the only difference is worker interface
    {assert, always, {gt, "http_ok.rps", 0.5}},
    {make_install, [{git, "https://github.com/gojekfarm/mzbench.git"},
                    {dir, "workers/http"}]},
    {pool, [{size, {numvar, "conn_count", 20}},
            {worker_start, {linear, {10, rps}}},
            {worker_type, http_worker}], [

        {connect, {var, "host", "172.21.3.3"}, {numvar, "port", 80}}, % each of these variables could be set
        {loop, [{time, {60, sec}},
                {rate, {ramp, linear, {1, rps}, {{numvar, "max_rps", 2000}, rps}}}],
            [{get, {var, "endpoint", "/index.html"}}]}]}
].
