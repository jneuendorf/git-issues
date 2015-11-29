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
                parts = project.name.split "/"
                projects_select_box.append "<option value='#{index}'>#{parts[1]} (#{parts[0]})</option>"
            if select_last
                # NOTE: index - 1 because after the loop index == projects.length
                projects_select_box.val("#{index - 1}")
        else
            projects = []

        if not select_last
            if window.project_index?
                projects_select_box.val(window.project_index or "choose")
            else
                projects_select_box.val("choose")
                delete_project_btn.prop("disabled", true)

        return projects

    create_project = (name, base_url, account_id, kind) ->
        if base_url and name and account_id?
            if name[name.length - 1] isnt "/"
                name += "/"
            base_url = checkboxes.filter(":checked").closest(".radio").siblings("input").val()
            if base_url[base_url.length - 1] isnt "/"
                base_url += "/"

            if name in (project.name for project in window.projects)
                throw new Error("Project '#{name}' already exists.")

            new_project =
                base_url: base_url
                name: name
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
    load_issues = () ->
        if localStorage.getItem("issues")
            return JSON.parse(localStorage.getItem("issues"))
        return []

    show_issues = (project_index) ->
        data = projects[project_index]
        if data?
            $.get "", {} , () ->
        throw new Error("Could not find a project at index #{project_index}.")

    fetch_issues = (project_index) ->
        data = projects[project_index]
        if data?
            $.get "", {} , () ->
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

    delete_project_btn = $(".delete_project")
    new_project_options = $(".new_project_options")
    checkboxes = $("[name='vcs']")
    project_name_input = $(".project_name")
    projects_select_box = $(".projects")
    accounts_select_box = $(".accounts")

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
                project_name_input.val()
                checkboxes.filter(":checked").closest(".radio").siblings("input").val()
                accounts_select_box.find("option:selected").val()
                checkboxes.filter(":checked").val()
            )
        catch error
            show_error error.message
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

    return true
