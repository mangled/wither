require 'time'

When(/^i check how long a ticket has been waiting$/) do
  @waiting_times = @issues.values.collect do |issue|
    {:id => issue.id, :days_wait_time => (DateTime.now - DateTime.iso8601(issue.created_on)).to_i }
  end
end

Then(/^the waiting time should not exceed "([^"]*)" days$/) do |days|
  check_non_conformities(@waiting_times) do |issue|
    assert_includes(issue, :days_wait_time)
    "waiting time of #{issue[:days_wait_time]} exceeds #{days} days" unless issue[:days_wait_time] <= days.to_i
  end
end
