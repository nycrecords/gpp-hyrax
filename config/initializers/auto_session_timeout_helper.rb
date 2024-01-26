module AutoSessionTimeoutHelper
  def auto_session_timeout_js(options={})
    frequency = options[:frequency] || 60
    attributes = options[:attributes] || {}
    code = <<JS
$(document).on('click', '#renew-session-btn', function(){ 
     $("#timeout-modal").modal('toggle');
});

function PeriodicalQuery() {
  var request = new XMLHttpRequest();
  request.onload = function (event) {
    var status = event.target.status;
    var response = event.target.response;
    if (status === 200 && response === 'warn') {
      $("#timeout-modal").modal('show');
    }
    if (status === 200 && (response === false || response === 'false' || response === null)) {
      window.location.href = '#{main_app.timeout_path}';
    }
  };
  request.open('GET', '#{main_app.active_path}', true);
  request.send();
  setTimeout(PeriodicalQuery, (#{frequency} * 1000));
}
setTimeout(PeriodicalQuery, (#{frequency} * 1000));
JS
    javascript_tag(code, attributes)
  end
end

ActionView::Base.send :include, AutoSessionTimeoutHelper