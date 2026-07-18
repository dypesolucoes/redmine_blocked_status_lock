document.addEventListener('DOMContentLoaded', function() {
  var link = document.getElementById('blocked-status-lock-override-link');
  if (!link) { return; }

  link.addEventListener('click', function(e) {
    e.preventDefault();

    var confirmText = window.blockedStatusLockConfirmText || 'Are you sure?';
    if (!window.confirm(confirmText)) { return; }

    var select = document.getElementById('issue_status_id');
    var bypassField = document.getElementById('blocked_status_bypass_field');
    var options = window.blockedStatusLockUnblockedOptions || [];

    if (select) {
      var currentValue = select.value;
      while (select.firstChild) {
        select.removeChild(select.firstChild);
      }
      options.forEach(function(pair) {
        var opt = document.createElement('option');
        opt.value = pair[1];
        opt.text = pair[0];
        if (String(pair[1]) === String(currentValue)) {
          opt.selected = true;
        }
        select.appendChild(opt);
      });
      select.disabled = false;
    }

    if (bypassField) {
      bypassField.value = '1';
    }

    link.style.display = 'none';
  });
});
