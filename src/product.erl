%%%-------------------------------------------------------------------
%%% File    : product.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 29 Apr 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module (product).
-compile(export_all).

%%-API-----------------------------------------------------------------
-export([load/1,
	 load/0,
	 raw_price/0,
	 get_Id/1,
	 get_price/1]).

%%-Template------------------------------------------------------------
-export([loadFromPath/0,
	 id/0,
	 name/0,
	 url/0,
	 img/0,
	 description/0,
	 price/0,
	 buyLink/0,
	 quantity/0,
	 quantityTextbox/1]).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").
-include("utils.hrl").

-define(PRODUCT,wf:state(product)).
%% @type prodId() = integer()

%% @type product() = #product{id=integer(), name=string(),
%%	                      url=string(), cat_id=catId(),
%%	                      img=string(), price=integer(),
%%	                      quantity=integer(), 
%%                            description=string()}

%%====================================================================
%% API Functions
%%====================================================================

%%--------------------------------------------------------------------
%% @private
%% @spec load(prodId()|product()) -> ok
%% @doc Load a product into memory.

%% TODO: handle failure
%% @end
%%--------------------------------------------------------------------
load(Product) when is_record(Product,product)->
    wf:state(product,Product);
load(ProdId) ->
    wf:state(product,(db:get_product(ProdId))#product{quantity="1"}).

%%--------------------------------------------------------------------
%% @private
%% @spec load() -> bool()
%% @doc Uses pathinfo to load a product into memory.
%% @end
%%--------------------------------------------------------------------
load() ->
    case wf:state(pathInfo) of
	"112"++ProdId ->
	    load(list_to_integer(ProdId)),
	    true;
	_ -> false
    end.

%%--------------------------------------------------------------------
%% @private
%% @spec get_Id(Product::product()) -> integer()
%% @doc return the id of the currently loaded product.
%% @end
%%-------------------------------------------------------------------
get_Id(Product) ->
    Product#product.id.

%%--------------------------------------------------------------------
%% @private
%% @spec get_price(product()) -> integer()
%% @doc returns the unformatted price of the currently loaded product.
%% @end
%%-------------------------------------------------------------------
get_price(Product) ->
    Product#product.price.

%%====================================================================
%% Template Functions
%%====================================================================

%%--------------------------------------------------------------------
%% @spec loadFromPath() -> []
%% @doc Uses pathinfo to load a product into memory.
%% @end
%%-------------------------------------------------------------------
loadFromPath() ->
    load(),
    [].

%%--------------------------------------------------------------------
%% @spec name() -> string()
%% @doc returns the name of the currently loaded product.
%% @end
%%-------------------------------------------------------------------
name() ->
    (?PRODUCT)#product.name.

%%--------------------------------------------------------------------
%% @deprecated no longer needed
%% @spec url() -> string()
%% @doc returns the url of the currently loaded product.
%% @end
%%-------------------------------------------------------------------
url() ->
    (?PRODUCT)#product.url.

%%--------------------------------------------------------------------
%% @spec img() -> string() 
%% @doc returns the path to the image of the currently loaded product.
%% @end
%%--------------------------------------------------------------------
img() ->
    image:load((?PRODUCT)#product.img).

%%--------------------------------------------------------------------
%% @spec description() -> string()
%% @doc returns the description of the currently loaded product.
%% @end
%%--------------------------------------------------------------------
description() ->
    (?PRODUCT)#product.description.

%%--------------------------------------------------------------------
%% @spec price() -> string()
%% @doc returns the price of the currently loaded product.
%% @end
%%--------------------------------------------------------------------
price() ->
    price:toString((?PRODUCT)#product.price).

%%--------------------------------------------------------------------
%% @spec buyLink() -> HTML
%% @doc returns a link that places the currently loaded product 
%%      in the cart.
%% @end
%%--------------------------------------------------------------------
buyLink() ->
    Delegate = #event{type=click, delegate=product, postback={buy,?PRODUCT}},
    #link{text="add to cart", class="icon cart_put", actions=Delegate}.

%%--------------------------------------------------------------------
%% @spec quantityTextbox(class()) -> HTML
%% @doc returns a texbox used to enter the quantity of the currently
%%      loaded product to add to the cart.
%% @end
%%--------------------------------------------------------------------
quantityTextbox(Class) ->
    #textbox{id="Qty" ++ ?i2l(id()),
	     class=Class, 
	     text=(?PRODUCT)#product.quantity}.

%% @hidden
event({buy,Product}) ->
    Qty = case wf:q("Qty"++ ?i2l(get_Id(Product))) of
	      [] -> 1;
	      Quantity -> ?l2i(hd(Quantity))
	  end,
    cart:add(Qty,Product);
event(Event) ->
    ?PRINT(Event).
