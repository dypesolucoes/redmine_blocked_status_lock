# Settings-reading policy shared by the Issue patch and the form hook, so the
# mode/role rule is written once and both call sites stay in sync.
module BlockedStatusLock
  VALID_MODES = %w(strict confirm_all confirm_roles).freeze

  def self.settings
    Setting.plugin_redmine_blocked_status_lock || {}
  end

  def self.restriction_active?
    settings['enabled'].to_s != '0'
  end

  def self.mode
    m = settings['mode'].to_s
    VALID_MODES.include?(m) ? m : 'confirm_all'
  end

  # Can this user, on this project, ever see/use the override control?
  def self.overridable_by?(user, project)
    case mode
    when 'strict'
      false
    when 'confirm_all'
      true
    when 'confirm_roles'
      role_ids = Array(settings['allowed_role_ids']).map(&:to_i)
      return false if role_ids.empty? || project.nil?
      user.roles_for_project(project).map(&:id).any? { |id| role_ids.include?(id) }
    end
  end

  # Does a bypass flag actually submitted with the request count, given policy?
  def self.bypass_allowed?(user, project, bypass_flag_present)
    bypass_flag_present && overridable_by?(user, project)
  end
end
