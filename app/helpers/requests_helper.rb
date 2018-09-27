module RequestsHelper
  def status_label(request)
    return 'btn btn-success btn-xs' if request.complete?
    return 'btn btn-warning btn-xs' if request.progress?

    'btn btn-default btn-xs'
  end

  # ignore lint, required for html formatting
  def request_placeholder
    "JIRA Number: HIANDEV-XXXX
Solution: HealtheAnalytics
Test Date: 10-May-2017
Environment: Staging
Operating System: OS-X
Associate ID: AA00000
Prerequisite Evidence: N/A"
  end
end
