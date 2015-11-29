// Generated by CoffeeScript 1.10.0
(function() {
  window.api_definitions = {
    github: {
      url: function(base_url, api_version) {
        return "https://api.github.com/";
      },
      repos: "repos",
      issues: "issues",
      milestone: "milestone",
      state: "state",
      labels: "labels",
      order_by: "sort",
      sort: "direction",
      fetch_all: function(owner, name, token, get_params) {
        if (get_params == null) {
          get_params = "";
        }
        return "repos/" + owner + "/" + name + "/issues?access_token=" + token + "&" + get_params;
      }
    },
    gitlab: {
      url: function(base_url, api_version) {
        if (api_version == null) {
          api_version = 3;
        }
        return "https://" + base_url + "api/v" + api_version + "/";
      },
      repos: "projects",
      issues: "issues",
      milestone: "milestone",
      state: "state",
      labels: "labels",
      order_by: "order_by",
      sort: "sort",
      fetch_all: function(owner, name, token, get_params) {
        if (get_params == null) {
          get_params = "";
        }
        return "projects/" + name + "/issues?access_token=" + token + "&" + get_params;
      }
    }
  };

}).call(this);
