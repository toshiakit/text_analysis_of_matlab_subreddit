function s = getReddit(args)
%GETREDDIT retrives posts from Reddit in specified subreddit based on
% specified sorting method. This is RSS feed, so no authentication is
% needed

    arguments
        args.subreddit (1,1) string = 'matlab'; % subreddit
        args.sortby (1,1) string {mustBeMember(args.sortby,["hot","new","top"])} = 'hot';
        args.limit = 100; % number of items to return
        args.max_requests = 1; % Increase this for more content
    end

    after = '';
    s = [];

    for requests = 1:args.max_requests
        [response,~,~] = send(matlab.net.http.RequestMessage,...
            "https://www.reddit.com/r/"+urlencode(args.subreddit) ...
            + "/"+args.sortby+"/.json?t=all&limit="+num2str(args.limit) ...
            + "&after="+after);
        newdata = response.Body.Data.data.children;
        s = [s; newdata];
        after = response.Body.Data.data.after;
    end

end