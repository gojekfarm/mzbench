-module(mzb_utility).

-export(
   [
    random_binary/1,
    random_list/1,
    random_number/1,
    random_number/2,
    random_string/1,
    to_integer_with_default/2,
    int_ceil/1,
    any_to_num/1,
    hostname_str/1,
    cast_to_type/2
   ]).

-ifdef(USE_STRONG_RAND_BYTES).

random_binary(N) -> crypto:strong_rand_bytes(N).

-else.

random_binary(N) -> crypto:rand_bytes(N).

-endif.

random_list(N) -> erlang:binary_to_list(random_binary(N)).

random_string(N) -> lists:flatten(io_lib:format('{"timestamp":"~p", "string":~p}', [os:system_time(), base64:encode_to_string(random_binary(N))])).

random_number(N) -> crypto:rand_uniform(0, N).

random_number(N, M) -> crypto:rand_uniform(N, M).

to_integer_with_default(N, _) when is_integer(N) ->
    N;
to_integer_with_default(S, Default) when is_binary(S) ->
    try
        list_to_integer(binary_to_list(S))
    catch _:_ ->
        Default
    end;
to_integer_with_default(S, Default) when is_list(S) ->
    try
        list_to_integer(S)
    catch _:_ ->
        Default
    end;
to_integer_with_default(_, Default) ->
    Default.

int_ceil(X) ->
    T = trunc(X),
    case (X - T) of
        Pos when Pos > 0 -> T + 1;
        _ -> T
    end.

any_to_num(Value) when is_integer(Value) or is_float(Value) -> Value;
any_to_num(Value) when is_binary(Value) ->
    any_to_num(binary_to_list(Value));
any_to_num(Value) when is_list(Value) ->
    case string:to_float(Value) of
        {error,no_float} -> list_to_integer(Value);
        {F,_Rest} -> F
    end.

hostname_str(Node) when is_atom(Node) ->
    hostname_str(atom_to_list(Node));
hostname_str(NodeStr) ->
    hd(tl(string:tokens(NodeStr, "@"))).

cast_to_type(Value, TypedValue) when is_binary(Value) and not is_binary(TypedValue) ->
    cast_to_type(binary_to_list(Value), TypedValue);
cast_to_type(Value, TypedValue) when is_list(Value) and (is_integer(TypedValue) or is_float(TypedValue)) ->
    any_to_num(Value);
cast_to_type(Value, TypedValue) when is_integer(Value) and is_float(TypedValue) ->
    float(Value);
cast_to_type(Value, TypedValue) when is_list(Value) and is_float(TypedValue) ->
    try
        list_to_float(Value)
    catch error:badarg ->
        float(list_to_integer(Value))
    end;
cast_to_type(Value, TypedValue) when is_list(Value) and is_binary(TypedValue) ->
    list_to_binary(Value);
cast_to_type(Value, _) -> Value.
