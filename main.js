$(document).ready(function() {
    var gitlab_url = $(".gitlab_url");

    $("[name='vcs']").change(function(event) {
        gitlab_url.prop("disabled", !gitlab_url.prop("disabled"));
        return true;
    });

    return true;
});
