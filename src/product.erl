-module (product).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

-define(PRODUCT,wf:state(product)).

%load(Product) ->
    
load(Product) when is_record(Product,product)->
    wf:state(product,Product);
load(ProdId) ->
    wf:state(product,db:get_product(ProdId)),
    
    ProdStr = integer_to_list(ProdId),
    Path = "./tpl/112" ++ ProdStr ++ ".tpl",
    case file:read_file_info(Path) of
	{ok,_} ->
	    #template { file=Path };
	{error,_} ->
	    #template{ file="./tpl/CC_product.tpl" }
    end.
    
id() ->
    (?PRODUCT)#product.id.

name() ->
    (?PRODUCT)#product.name.

url() ->
    (?PRODUCT)#product.url.

img() ->
    image:load((?PRODUCT)#product.img).

description() ->
    (?PRODUCT)#product.description.

price() ->
    price:toString((?PRODUCT)#product.price).

buyLink() ->
    Delegate = #event{type=click, delegate=product, postback={buy,id(),1}},
    #link{text="add to cart", class="icon cart_put", actions=Delegate}.

event({buy,ProdId,Qty}) ->
    cart:add(Qty,ProdId);
event(Event) ->
    ?PRINT(Event).
