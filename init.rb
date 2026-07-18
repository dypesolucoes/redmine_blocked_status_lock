require 'redmine'

require_relative 'lib/redmine_blocked_status_lock'
require_relative 'lib/redmine_blocked_status_lock/patches/issue_patch'
require_relative 'lib/redmine_blocked_status_lock/hooks'

Redmine::Plugin.register :redmine_blocked_status_lock do
  name 'Blocked Status Lock'
  author 'Dype Soluções'
  description 'Prevents any status change on an issue while it is blocked by ' \
              'another open issue, not just closing. Configurable to hard-block ' \
              'everyone, warn everyone with an override, or warn only selected roles.'
  version '1.0.0'
  url 'https://github.com/dypesolucoes/redmine_blocked_status_lock'
  author_url 'https://github.com/dypesolucoes'
  requires_redmine :version_or_higher => '4.1.0'

  settings :default => {
    'enabled' => '1',
    'mode' => 'confirm_all',
    'allowed_role_ids' => []
  }, :partial => 'settings/redmine_blocked_status_lock'
end
