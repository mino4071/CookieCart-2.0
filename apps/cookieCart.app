{application, cookieCart, 
 [
  {description,  "CC Nitrogen"},
  {mod, {cookieCart_app, []}},
  {env, [
	 %% Nitrogen env
	 {platform, inets},
	 {port, 8000},
	 {session_timeout, 20},
	 {sign_key, "b37ca07"},
	 {wwwroot, "./wwwroot"},
	 %% CookieCart Env
	 {tpl_main, "./tpl/CC_main.tpl"},
	 {tpl_category, "./tpl/CC_main.tpl"},
	 {tpl_product, "./tpl/CC_main.tpl"}
	]}
 ]}.
