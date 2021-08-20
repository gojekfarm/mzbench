[
%    {make_install, [{git, "https://github.com/djcruz93/mzbench.git"},
%                    {dir, "worker_templates/python_empty"}]},
    {pool, [
        {size, 3},
        {worker_type, python_empty, python}
    ],
    [
        {my_print, "hello"}
    ]}
].