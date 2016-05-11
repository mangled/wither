Given(/^all issues$/) do
  @issues = $issues
end

Given(/^issues with a status of ([^"]*)$/) do |status|
  @issues = $issues.select{|_, issue| issue.status == status }
end

And(/^those with a status of ([^"]*)$/) do |status|
  @issues = @issues.merge($issues.select{|_, issue| issue.status == status })
end

And(/^none in target version (.*)/) do |version_value|
  @issues = @issues.select { |_, issue| issue.fixed_version != version_value }
end

When(/^i check the ([^"]*) field/) do |field|
  @issues = @issues.values.collect { |issue| {:id => issue.id, field => issue.send(field)} }
end

Then(/^the ([^"]*) field must have a value greater than zero$/) do |field|
  check_non_conformities(@issues) do |issue|
    assert_includes(issue, field)
    'the fields value is not set or its equal to zero' unless (issue[field] and (issue[field].to_i > 0))
  end
end

Then(/^the ([^"]*) field must be one of the following:$/) do |field, table|
  valid_values = table.hashes.collect {|h| h[:value] }
  check_non_conformities(@issues) do |issue|
    assert_includes(issue, field)
    "had an invalid value of: #{issue[:value]}" unless valid_values.include?(issue[field])
  end
end

Then(/^the ([^"]*) field must be set$/) do |field|
  check_non_conformities(@issues) do |issue|
    assert_includes(issue, field)
    "#{field} is not set" if issue[field].nil?
  end
end

Then(/^the ([^"]*) field must not be set$/) do |field|
  check_non_conformities(@issues) do |issue|
    assert_includes(issue, field)
    "#{field} is set to #{issue[field]}" unless issue[field].nil?
  end
end

Then(/^the ([^"]*) field must be set to ([^"]*)$/) do |field, value|
  check_non_conformities(@issues) do |issue|
    assert_includes(issue, field)
    "has an invalid value of: #{issue[field]} instead of #{value}" unless issue[field] == value
  end
end

