-module (web_index).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

main() -> 
    PathInfo = wf:get_path_info(),
    select_template(PathInfo).

select_template([]) ->
    #template { file="./tpl/main.tpl"};
select_template("112" ++ ProdId) ->
    product:load(list_to_integer(ProdId));
select_template("99" ++ CatId) ->
    category:load(list_to_integer(CatId));
select_template(PathInfo) ->
    #template { file="./wwwroot/"++ PathInfo}.

render() ->
    wf:render(#label { text="2010-03-04 : Code Work is rolling and soon you will be able to start using this wonderful page. /admin" }).
render_page(String) ->
    String.

template() ->
    %% Hacka-dodel-doo
    wf:state(template_was_called,false),
    #template { file="./wwwroot/contact.tpl"}.

event(Event) ->
    ?PRINT(Event).
