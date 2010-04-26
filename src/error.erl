-module (error).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").


%% Use this module to trap errors you know how to handle
%% but could potentialy happen in many different places. 
%% i.e loss of database connection. 

event(Event) ->
    Module = wf:get_page_module(),
    try	Module:handle_event(Event)
    catch throw:dberror ->
	    wf:wire(#alert { text="Connection to database failed, please try again later" }),
	    []
    end.
    
