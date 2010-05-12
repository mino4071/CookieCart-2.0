%% @hidden
-module(web_admin).
-include_lib("nitrogen/include/wf.inc").

-define(txt2(Text),Text).

-compile(export_all).

%% @doc Template binding
main() ->
    #template { file="./wwwroot/admin/template.html" }.

%% @doc Get name of page module and send it to title(module_name)
title() -> 
    PageModule = wf:get_page_module(),
    "Cookie Cart - Administrator" ++ " - "++title(PageModule).

%% @doc The navigation menu for the admin pages
navigation() ->
    %% Navigation lists

    DList = [overview,nodes,statistics],
    MList = [products,orders,customers,categories,content],
    CList = [preferences,users,roles,themes,pages,plugins],
    PList = [],
    

    %% Make listitems
    DListitems = [[#listitem { body=get_link(X) }] || X <-DList],
    MListitems = [[#listitem { body=get_link(X) }] || X <-MList],
    CListitems = [[#listitem { body=get_link(X) }] || X <-CList],
    PListitems = [[#listitem { body=get_link(X) }] || X <-PList],

    DL = case DListitems of
	     [] -> [];
	     DLS ->
		 [#h3{text="Dashboard",class=dashboard},
		  #list{body=DLS}]
	 end,

    ML = case MListitems of
	     [] -> [];
	     MLS ->
		 [#h3{text="Manage",class=manage},
		  #list{body=MLS}]
	 end,

     CL = case CListitems of
	     [] -> [];
	     CLS ->
		 [#h3{text="Configuration",class=configuration},
		  #list{body=CLS}]
	 end,

    PL = case PListitems of
	     [] -> [];
	     PLS ->
		 [#h3{text="Custom pages",class=legos},
		  #list{body=PLS}]
	 end,

    [DL,ML,CL,PL].
    
get_link(overview) ->
    #link{text="Overview", url="./overview", class=overview };
get_link(nodes) ->
    #link{text="Nodes", url="./nodes", class=nodes };
get_link(statistics) ->
    #link{text="Statistics", url="./statistics", class=statistic };
get_link(products) ->
    #link{text="Products", url="./productlist", class=product };
get_link(orders) ->
    #link{text="Orders", url="./orderlist", class=order };
get_link(customers) ->
    #link{text="Customers", url="./customerlist", class=customer };
get_link(categories) ->
    #link{text="Categories", url="./category", class=category };
get_link(content) ->
    #link{text="Content", url="./content", class=content };
get_link(preferences) ->
    #link{text="Preferences", url="./preferences", class=preference };
get_link(users) ->
    #link{text="Users", url="./userlist", class=user };
get_link(roles) ->
    #link{text="Roles", url="./role", class=role };
get_link(themes) ->
    #link{text="Themes", url="./theme", class=theme };
get_link(pages) ->
    #link{text="Pages", url="./pagelist", class=page };
get_link(plugins) ->
    #link{text="Plugins", url="./pluginlist", class=plugin }.

%% @doc Login status
loginstatus() ->
    StatusBody = [
		  #literal { text=?txt2("You are now logged in as ") },
		  "Username",
		  #literal { text=" | " },
		  #link { text=?txt2("Log out"), url="/web/admin/logoff" }
		 ],
    wf:render([#panel { id=loginStatus, class=right, body=StatusBody }]).

%% @doc The page titles
title(web_admin) -> ?txt2("Index");
title(web_admin_category) -> ?txt2("Categories");
title(web_admin_content) -> ?txt2("Content");
title(web_admin_currency) -> ?txt2("Add/edit currency");
title(web_admin_currencylist) -> ?txt2("Currencies");
title(web_admin_customer) -> ?txt2("Edit customer");
title(web_admin_customercart) -> ?txt2("Customer cart");
title(web_admin_customerinfo) -> ?txt2("Customer information");
title(web_admin_customerlist) -> ?txt2("Customers");
title(web_admin_languages) -> ?txt2("Languages");
title(web_admin_login) -> ?txt2("Login");
title(web_admin_nodes) -> ?txt2("Nodes");
title(web_admin_order) -> ?txt2("Order details");
title(web_admin_orderlist) -> ?txt2("Orders");
title(web_admin_overview) -> ?txt2("Overview");
title(web_admin_pagelist) -> ?txt2("Pages");
title(web_admin_pages) -> ?txt2("Custom pages");
title(web_admin_plugin) -> ?txt2("Plugin configuration");
title(web_admin_pluginlist) -> ?txt2("Plugins");
title(web_admin_preferences) -> ?txt2("Preferences");
title(web_admin_product) -> ?txt2("Edit product");
title(web_admin_productadd) -> ?txt2("Add product");
title(web_admin_productlist) -> ?txt2("Products");
title(web_admin_productsearch) -> ?txt2("Search product");
title(web_admin_role) -> ?txt2("Roles");
title(web_admin_rolelink) -> ?txt2("Edit accesslist");
title(web_admin_statistics) -> ?txt2("Statistics");
title(web_admin_tax) -> ?txt2("Taxes");
title(web_admin_theme) -> ?txt2("Themes");
title(web_admin_translations) -> ?txt2("Translations");
title(web_admin_user) -> ?txt2("Add/edit user");
title(web_admin_userlist) -> ?txt2("Users");
title(web_admin_help) -> ?txt2("Help");
title(_) -> ?txt2("Untitled").
