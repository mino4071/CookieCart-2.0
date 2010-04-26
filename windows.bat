erl -make
erl -name nitrogen@127.0.0.1 -pa ebin apps -eval "application:start(cookieCart)"