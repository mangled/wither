When(/^i check an issues eldest parent/) do
  @elders = @issues.values.collect do |issue|
    {:id => issue.id, :root_is_eb => find_root_parent(issue).is_effort_bucket? }
  end
end

Then(/^it should be an effort bucket$/) do
  check_non_conformities(@elders) do |issue|
    assert_includes(issue, :root_is_eb)
    'does not have an effort bucket as a root parent' unless issue[:root_is_eb]
  end
end
