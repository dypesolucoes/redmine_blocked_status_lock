module RedmineBlockedStatusLock
  module IssuePatch
    def new_statuses_allowed_to(user=User.current, include_default=false)
      statuses = super

      if BlockedStatusLock.restriction_active? && !new_record? && blocked? &&
         !BlockedStatusLock.bypass_allowed?(user, project, @blocked_status_bypass)
        current = status
        statuses = statuses.select { |s| s.id == current.id }
        statuses << current if statuses.empty?
        statuses << default_status if include_default
        statuses = statuses.compact.uniq.sort
      end

      statuses
    end

    def safe_attributes=(attrs, user=User.current)
      @blocked_status_bypass = attrs.respond_to?(:delete) &&
        attrs.delete('bypass_blocked_status_check').to_s == '1'
      super
    end

    # Same list `new_statuses_allowed_to` would return if this issue weren't
    # blocked at all. Used by the form hook to populate the override control
    # without tripping the restriction above.
    def statuses_allowed_ignoring_block(user=User.current, include_default=false)
      saved = @blocked_status_bypass
      @blocked_status_bypass = true
      new_statuses_allowed_to(user, include_default)
    ensure
      @blocked_status_bypass = saved
    end
  end
end

Rails.configuration.to_prepare do
  unless Issue.included_modules.include?(RedmineBlockedStatusLock::IssuePatch)
    Issue.prepend(RedmineBlockedStatusLock::IssuePatch)
  end
end
