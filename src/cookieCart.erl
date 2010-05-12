%% @hidden
-module (cookieCart).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").


categories() ->
    category:main().
categories(Template) ->
    category:main(Template).

template(Template) ->
    %% Hacka-dodel-doo
    wf:state(template_was_called,false),
    #template { file="./wwwroot/" ++ Template }.

event(Event) ->
    ?PRINT(Event).
