module RedmineBlockedStatusLock
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
              :partial => 'hooks/issue_blocked_status_notice'
  end
end
