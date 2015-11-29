# MAIN
$(document).ready () ->
    # BEGIN - INNER FUNCTIONS
    # PROJECTS
    load_and_show_projects = (select_last = false) ->
        projects_select_box.empty().append "<option value='choose' disabled>Choose project</option>"
        # load projects from localStorage
        if localStorage.getItem("projects")
            projects = JSON.parse(localStorage.getItem("projects"))
            for project, index in projects
                # parts = project.name.split "/"
                projects_select_box.append "<option value='#{index}'>#{project.name} (#{project.owner})</option>"
            if select_last
                # NOTE: index - 1 because after the loop index == projects.length
                projects_select_box.val("#{index - 1}")
                load_project(index - 1)
        else
            projects = []

        if not select_last
            if window.project_index?
                projects_select_box.val(window.project_index)

            else
                projects_select_box.val("choose")
                delete_project_btn.prop("disabled", true)

        return projects

    fill_in_options = () ->
        url = project_url.val()
        if url.indexOf("github.com") >= 0
            kind = "github"
        else
            kind = "gitlab"

        checkboxes.filter("[value='#{kind}']").prop("checked", true)
        return true

    create_project = (owner, name, base_url, account_id, kind) ->
        if owner and name and base_url and account_id?
            # if name[name.length - 1] isnt "/"
            #     name += "/"
            base_url = checkboxes.filter(":checked").closest(".radio").siblings("input").val()
            if base_url[base_url.length - 1] isnt "/"
                base_url += "/"

            if name in (project.name for project in window.projects)
                throw new Error("Project '#{name}' already exists.")

            new_project =
                owner: owner
                name: name
                base_url: base_url
                account_id: account_id
                kind: kind
            projects.push new_project
            localStorage.setItem("projects", JSON.stringify(projects))

            load_and_show_projects(true)
            $(".modal").modal("hide")
            new_project_options.slideUp(200)
            return new_project
        throw new Error("Invalid data given.")

    delete_project = (project_index) ->
        if 0 <= project_index < window.projects.length
            window.projects.splice project_index, 1
            localStorage.setItem("projects", JSON.stringify(projects))
            window.project_index = null
            load_and_show_projects()
            return true
        throw new Error("Cannot delete project at index #{project_index}")

    load_project = (project_index) ->
        console.log project_index

        if 0 <= project_index < window.projects.length
            window.project_index = project_index
            new_project_options.slideUp(200)
            actions_options.find(".btn").prop("disabled", false)
            delete_project_btn.prop("disabled", false)

            return true
        throw new Error("Cannot load project at index #{project_index}")

    # ACCOUNTS
    load_and_show_accounts = (select_last) ->
        accounts_select_box.empty().append "<option value='choose' disabled>Choose account</option>"
        # load projects from localStorage
        if localStorage.getItem("accounts")
            accounts = JSON.parse(localStorage.getItem("accounts"))
            for account, index in accounts
                accounts_select_box.append "<option value='#{index}'>#{account.name}</option>"
            accounts_select_box.val("#{index - 1}")
        else
            accounts = []

        if not select_last
            accounts_select_box.val("choose")

        return accounts

    create_account = (user_name, auth_token, is_default) ->
        if user_name and auth_token

            if user_name in (account.name for account in window.accounts)
                throw new Error("Account '#{user_name}' already exists.")

            # make sure new default account is the only one!
            if is_default
                for account in window.accounts
                    account.is_default = false

            new_account =
                name: user_name
                token: auth_token
                is_default: is_default
            window.accounts.push new_account
            localStorage.setItem "accounts", JSON.stringify(window.accounts)

            load_and_show_accounts(true)
            $(".modal").modal("hide")
            return new_account
        throw new Error("Invalid data given.")

    # ISSUES
    parse_date_string = (date_str) ->
        month_names = [
            "Jan"
            "Feb"
            "Mar"
            "Apr"
            "May"
            "Jun"
            "Jul"
            "Aug"
            "Sep"
            "Oct"
            "Nov"
            "Dec"
        ]
        # 2014-09-29T15:38:28Z
        parts = date_str.slice(0, -1).split "T"
        date_parts = parts[0].split "-"
        time_parts = parts[1].split ":"
        return {
            date: "#{date_parts[2]} #{month_names[parseInt(date_parts[1], 10)]} #{date_parts[0]}"
            time: "#{time_parts[0]}:#{time_parts[1]}"
        }


    load_issues = () ->
        if localStorage.getItem("issues")
            return JSON.parse(localStorage.getItem("issues"))
        return []

    ###
    {
      "url": "https://api.github.com/repos/mishoo/UglifyJS/issues/520",
      "labels_url": "https://api.github.com/repos/mishoo/UglifyJS/issues/520/labels{/name}",
      "comments_url": "https://api.github.com/repos/mishoo/UglifyJS/issues/520/comments",
      "events_url": "https://api.github.com/repos/mishoo/UglifyJS/issues/520/events",
      "html_url": "https://github.com/mishoo/UglifyJS/pull/520",
      "id": 110745545,
      "number": 520,
      "title": "Update README.org",
      "user": {
        "login": "jareddbc",
        "id": 4805277,
        "avatar_url": "https://avatars.githubusercontent.com/u/4805277?v=3",
        "gravatar_id": "",
        "url": "https://api.github.com/users/jareddbc",
        "html_url": "https://github.com/jareddbc",
        "followers_url": "https://api.github.com/users/jareddbc/followers",
        "following_url": "https://api.github.com/users/jareddbc/following{/other_user}",
        "gists_url": "https://api.github.com/users/jareddbc/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/jareddbc/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/jareddbc/subscriptions",
        "organizations_url": "https://api.github.com/users/jareddbc/orgs",
        "repos_url": "https://api.github.com/users/jareddbc/repos",
        "events_url": "https://api.github.com/users/jareddbc/events{/privacy}",
        "received_events_url": "https://api.github.com/users/jareddbc/received_events",
        "type": "User",
        "site_admin": false
      },
      "labels": [

      ],
      "state": "open",
      "locked": false,
      "assignee": null,
      "milestone": null,
      "comments": 0,
      "created_at": "2015-10-09T22:23:37Z",
      "updated_at": "2015-10-09T22:23:37Z",
      "closed_at": null,
      "pull_request": {
        "url": "https://api.github.com/repos/mishoo/UglifyJS/pulls/520",
        "html_url": "https://github.com/mishoo/UglifyJS/pull/520",
        "diff_url": "https://github.com/mishoo/UglifyJS/pull/520.diff",
        "patch_url": "https://github.com/mishoo/UglifyJS/pull/520.patch"
      },
      "body": ""
    }
    ###
    show_issues = (project_index) ->
        _issues = window.issues[project_index]
        if _issues?
            res = ""
            for issue in _issues
                created_at = parse_date_string(issue.created_at)
                # get icon
                if issue.pull_request?
                    icon = "octicon-git-pull-request"
                else
                    if issue.state is "open"
                        icon = "octicon-issue-opened"
                    else
                        icon = "octicon-issue-closed"
                # TODO: labels using string_to_color: <span class="label label-default">Default</span>
                res += """<div class="row list-group-item issue">
                            <!--span class="badge">14</span-->
                            <div class="col-xs-1 icon">
                                <span class="octicon #{icon} #{issue.state}"></span>
                            </div>
                            <div class="col-xs-10">
                                <h4>#{issue.title}</h4>
                                ##{issue.number} updated on #{created_at.date} at #{created_at.time} by #{issue.user.login}
                            </div>
                            <div class="col-xs-1">
                                <img class="avatar" src="#{issue.user.avatar_url}" />
                                <!--span class="octicon octicon-comment"></span-->
                            </div>
                        </div>"""
            issues_output.empty().append res

            return true
        throw new Error("Could not find a project at index #{project_index}.")

    fetch_issues = (project_index) ->
        project_data = projects[project_index]
        if project_data?
            account_data = window.accounts[project_data.account_id]
            url = api_definitions[project_data.kind].url(project_data.base_url)
            suffix = api_definitions[project_data.kind].fetch_all(project_data.owner, project_data.name, account_data.token)
            $.get url + suffix, (response) ->
                window.issues[project_index] = response
                localStorage.setItem "issues", JSON.stringify(window.issues)
                show_issues(project_index)
                return true
            return true
        throw new Error("Could not find a project at index #{project_index}.")

    # MISC
    show_error = (message) ->
        $(".modal").modal("hide")
        error_alert.fadeIn(200)
            .find(".content")
            .empty()
            .append message
        return true
    # END - INNER FUNCTIONS

    #######################################################################################################################
    #######################################################################################################################

    delete_project_btn = $(".delete_project")
    project_url = $(".project_url")
    new_project_options = $(".new_project_options")
    checkboxes = $("[name='vcs']")
    project_owner_input = $(".project_owner")
    project_name_input = $(".project_name")
    projects_select_box = $(".projects")
    accounts_select_box = $(".accounts")
    issues_output = $(".issues_output")

    actions_options = $(".actions_options")
    show_issues_btn = $(".show_issues")
    fetch_issues_btn = $(".fetch_issues")

    create_account_modal = $("#create_account_modal")
    error_alert = $(".alert.error")

    window.projects = load_and_show_projects()
    window.project_index = null
    window.accounts = load_and_show_accounts()
    window.issues = load_issues()

    console.log(projects)

    projects_select_box.change () ->
        index = projects_select_box.find("option:selected").val()
        if index isnt "choose"
            load_project parseInt(index, 10)
        return true

    project_url.keyup (event) ->
        fill_in_options()
        return true

    # toggle new project options
    $(".new_project").click () ->
        new_project_options.slideToggle(200)
        return true

    delete_project_btn.click () ->
        delete_project(window.project_index)
        return true

    # toggle user accounts
    $(".user_icon").click () ->
        $(@).closest(".row").children().not(":first").fadeToggle(200)
        return true


    # create new project
    $(".create_project").click () ->
        try
            create_project(
                project_owner_input.val()
                project_name_input.val()
                checkboxes.filter(":checked").closest(".radio").siblings("input").val()
                accounts_select_box.find("option:selected").val()
                checkboxes.filter(":checked").val()
            )
        catch error
            show_error error.message
        return true

    $(".customize_project").click () ->
        $(".customize_project_target").slideToggle(200)
        $(@).find("span").toggleClass("glyphicon-chevron-down glyphicon-chevron-up")
        return true

    # create new account
    $(".create_account").click () ->
        try
            create_account(
                create_account_modal.find(".user_name").val()
                create_account_modal.find(".auth_token").val()
                create_account_modal.find("input[type='checkbox']").prop("checked")
            )
        catch error
            show_error error.message
        return true

    # checkbox github/gitlab toggling
    gitlab_url = $(".gitlab_url")

    checkboxes.change (event) ->
        gitlab_url.prop("disabled", not gitlab_url.prop("disabled"))
        return true

    error_alert.find(".close").click () ->
        error_alert.fadeOut(200)
        return true


    # ISSUES
    fetch_issues_btn.click () ->
        if window.project_index?
            fetch_issues(window.project_index)
            return true
        throw new Error("There is no current project.")

    show_issues_btn.click () ->
        show_issues(window.project_index)
        return true

    return true
