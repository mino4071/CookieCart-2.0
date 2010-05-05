%%%-------------------------------------------------------------------
%%% File    : web_admin_productlist.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created :  3 May 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module (web_admin_productlist).
-include_lib ("nitrogen/include/wf.inc").

-include("records.hrl").

-compile(export_all).

-define(txt2(Txt),Txt).

main() ->
    #template { file="./wwwroot/admin/template.html" }.
    
toolbar() ->
    Products = #link{ text="Products",
		      postback=tab_products},
    
    AddProduct = #link { text="Add product",
			 postback=tab_addProduct, 
			 class=product_add },

    AddCategory = #link{ text="Add category",
			 postback=tab_addCategory},
    #list{ body=
       [#listitem{ body=Products},
	#listitem{ body=AddProduct},
	#listitem{ body=AddCategory}
       ]}.

content() -> 
    #panel{id=content, body=categories()}.

%%====================================================================
%% Category Tab
%%====================================================================
categories() ->
    Data = db:get_categories(),
    Rows = [bind_cat(X) || X <- Data],
    #table{ rows =
       [#tablerow{cells=
          [#tableheader{text="Categories"}] ++ Rows}
       ]}.


bind_cat(Data) ->
    Link = #link{ text=Data#category.name, postback=Data#category.id },
    LinkCell = #tablecell{ body=Link },
    ProdCell = #tablecell{ id= "P" ++ integer_to_list(Data#category.id),
			   actions=#hide{}
			  },
    [#tablerow{ cells=LinkCell },
     #tablerow{ cells=ProdCell }
    ].


products(CatId) ->
    Data = db:get_products(CatId),
    Rows = [bind_prod(X) || X <- Data],
    #table { rows=
       [#tablerow { cells=
          [#tableheader { text=?txt2("Product #") },
	   #tableheader { text=?txt2("Title"), class=fullwidth },
	   #tableheader { text=?txt2("Price") },
	   #tableheader { text=?txt2("Quantity") },
	   #tableheader { text=?txt2("Status") },
	   #tableheader { text=?txt2("Visible") },
	   #tableheader { text=?txt2("Duplicate") },       
	   #tableheader { text=?txt2("Remove") }
	  ] ++ Rows}]}.


bind_prod(Data) ->
    Cells = [#tablecell{text=integer_to_list(Data#product.id)},
	     #tablecell{text=Data#product.name},
	     #tablecell{text=price:toString(Data#product.price)},
	     #tablecell{text="Quantity"},
	     #tablecell{text="Status"},
	     #tablecell{text="Visible"},
	     #tablecell{text="Duplicate"},
	     #tablecell{text="Remove"}],
    #tablerow{cells=Cells}.

%%====================================================================
%% Add Product Tab
%%====================================================================
addProduct() ->
    [#label{text="Product #"},#br{},
     #textbox{},#br{},
     #label{text="Title"},#br{},
     #textbox{id=prod_name},#br{},
     #label{text="Price"},#br{},
     #textbox{},#checkbox{text="Tax included"},#br{},
     #label{text="Quantity"},#br{},
     #textbox{},#br{},
     #label{text="Category"},#br{},
     #dropdown{},#br{},
     #label{text="Description"},#br{},
     #textarea{id=prod_desc},#br{},
     #button{text="Add Product", postback=addProduct}].

%%====================================================================
%% Add Category Tab
%%====================================================================
addCategory() ->
    [#label{text="Name"},#br{},
     #textbox{id=cat_name},#br{},
     #button{text="Add Category", postback=addCategory}].
     
%%====================================================================
%% Event Handling
%%====================================================================
%%--------------------------------------------------------------------
%% Category Tab Events
%%--------------------------------------------------------------------
event(tab_products) ->
    wf:update(content,categories());
event(Id) when is_integer(Id) ->
    IdStr = "P"++integer_to_list(Id),
    wf:update(IdStr,
	      #tablecell{id = IdStr, body=products(Id)}),
    wf:wire(IdStr,#toggle{});
%%--------------------------------------------------------------------
%% Add Product Tab Events
%%--------------------------------------------------------------------
event(tab_addProduct) ->
    wf:update(content,addProduct());
event(addProduct) ->
    Product =#product{name = hd(wf:q(prod_name)),
		      cat_id = 1,
		      price = #price{price=1000,currency="SEK"},
		      description = hd(wf:q(prod_desc))},
    db:add_product(Product),
    wf:update(content,addProduct());
%%--------------------------------------------------------------------
%% Add Category Tab Events
%%--------------------------------------------------------------------
event(tab_addCategory) ->
    wf:update(content,addCategory());
event(addCategory) ->
    Category =#category{name = hd(wf:q(cat_name))},
    db:add_category(Category),
    wf:update(content,categories());
%%--------------------------------------------------------------------
%% Catch All
%%--------------------------------------------------------------------
event(_) ->
    ok.
