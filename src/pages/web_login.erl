-module (web_login).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").

main() -> 
    #template { file="./wwwroot/main.html"}.

render() ->
    wf:wire("obj('username').focus()"),
    #panel{body=
        [#literal{text="if you don't have a password you can register " },
	 #link{text="here", url="/web/registration"},#br{},
	 #label{text="Username"},#br{},
	 #textbox{id=username, next=password},#br{},
	 #label{text="Password"},#br{},
	 #password{id=password, next=login_btn},#br{},#br{},
	 #button{id=login_btn, text="Login", postback=login}
	]}.

event(Event)->
    error:event(Event).

%%% Never call handle_event directly! %%%
handle_event(login) ->
    User = hd(wf:q(username)),
    Pass = hd(wf:q(password)),
    case db:auth_user(User,Pass) of
	false ->
	    wf:wire(#alert { text="Wrong Username or Password" });
	true ->
	    wf:user(User),
	    wf:redirect_from_login("/")
    end.
