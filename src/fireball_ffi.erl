-module(fireball_ffi).
-export([post_file_erl/2]).

% A function to upload a file to Google Firebase Storage.
% Takes a URL and a file location on disk.
post_file_erl(URL, File) ->
    % Start inets and ssl
    inets:start(),
    ssl:start(),

    % Send the file!

    % Stop inets and ssl
    ssl:stop(),
    inets:stop().
