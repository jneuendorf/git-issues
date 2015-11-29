window.api_definitions =
    github:
        url: (base_url, api_version) ->
            return "https://api.github.com/"
        repos: "repos"
        issues: "issues"
        milestone: "milestone"
        state: "state"
        labels: "labels"
        order_by: "sort"
        sort: "direction"
        fetch_all: (owner, name, token, get_params = "") ->
            return "repos/#{owner}/#{name}/issues?access_token=#{token}&#{get_params}"
    gitlab:
        url: (base_url, api_version = 3) ->
            return "https://#{base_url}api/v#{api_version}/"
        repos: "projects"
        issues: "issues"
        milestone: "milestone"
        state: "state"
        labels: "labels"
        order_by: "order_by"
        sort: "sort"
        fetch_all: (owner, name, token, get_params = "") ->
            return "projects/#{name}/issues?access_token=#{token}&#{get_params}"
