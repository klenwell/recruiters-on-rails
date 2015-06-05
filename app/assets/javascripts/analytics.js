// http://stackoverflow.com/a/19403068/1093087
$(document).on('page:change', function() {
  if (window._gaq != null) {
    return _gaq.push(['_trackPageview']);
  }
  else if (window.pageTracker != null) {
    return pageTracker._trackPageview();
  }
});
