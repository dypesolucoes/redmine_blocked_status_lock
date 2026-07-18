# Redmine Blocked Status Lock

Redmine's core only prevents an issue from being **closed** while it has an open
"blocked by" relation — every other status transition (New → In Progress →
Resolved → Feedback, etc.) is left completely open. This plugin generalizes that
restriction to **any** status change, with a configurable escape hatch.

## Behavior

Three modes, set in Administration > Plugins > Blocked Status Lock > Configure:

| Mode | What happens |
|------|--------------|
| **Always block, no override** (`strict`) | While an issue is blocked by an open issue, its status field is locked to the current value for everyone. No exceptions. |
| **Block, but allow anyone to override with confirmation** (`confirm_all`) | Same lock by default, but any user sees an "Override — I understand" control; clicking it, then confirming a dialog, unlocks the status field for that submission. |
| **Block, but allow override only for selected roles** (`confirm_roles`) | Same as above, but only users holding one of the roles chosen in the settings see and can use the override control. Everyone else is hard-blocked as in `strict`. |

A master **enable/disable** checkbox turns the whole plugin off, restoring stock
Redmine behavior (only closing is blocked) without uninstalling.

The lock also applies to `new_statuses_allowed_to`, the same method Redmine core
uses to compute allowed statuses for the issue form, bulk-edit, and the REST API.
That means the restriction is consistently enforced everywhere — but since there
is no confirmation dialog over the API or in bulk-edit, those two paths can never
use the override, regardless of mode. This is a known v1 limitation.

## Requirements

Redmine 4.1.0 or newer.

## Installation

```
cd /path/to/redmine/plugins
git clone https://github.com/dypesolucoes/redmine_blocked_status_lock.git
cd ../
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

Restart Redmine (Passenger/Puma/whatever your setup uses) afterwards.

## License

MIT — see [LICENSE](LICENSE).
