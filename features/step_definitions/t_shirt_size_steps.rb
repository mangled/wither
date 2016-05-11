Given(/^an issue has a valid t\-shirt size$/) do
  @issues = @issues.select{|_, issue| !issue.t_shirt_size.nil? and issue.t_shirt_size != 'Not Specified' }
end

Given(/^an issue has a t\-shirt size$/) do
  @issues = @issues.select{|_, issue| !issue.t_shirt_size.nil? }
end

Given(/^an issue without a t\-shirt size$/) do
  @issues = @issues.select{|_, issue| issue.t_shirt_size.nil? or issue.t_shirt_size == 'Not Specified' }
end

And(/^i ignore any of its children with the status (.*)$/) do |with_status|
  @ignore_children ||= []
  @ignore_children << with_status
end

And(/^the analysis_estimate field must equal the t\-shirt size field$/) do
  @issues = @issues.values.collect do |issue|
    size = (issue.analysis_estimate.to_i != issue.t_shirt_size_eds) ? issue.analysis_estimate.to_i : nil
    { :id => issue.id, :analysis_equal_t_size => size, :t_shirt_eds => issue.t_shirt_size_eds }
  end
  check_non_conformities(@issues) do |issue|
    if issue[:analysis_equal_t_size]
      "analysis estimate of #{issue[:analysis_equal_t_size]} not equal to t-shirt size of #{issue[:t_shirt_eds]}"
    end
  end
end

When(/^i check it's children$/) do
  ignore_children = lambda{|issue| @ignore_children.include?(issue.status) }
  @children = @issues.values.collect do |issue|
    { :id => issue.id,
      :has_t_size => a_child_has_a_tshirt_size(issue, true, ignore_children)
    }
  end
end

When(/^i check each of its children$/) do
  ignore_children = lambda{|issue| @ignore_children.include?(issue.status) }
  @children = @issues.values.collect do |issue|
    child_has_t_shirt = []
    children(issue).each {|child| child_has_t_shirt.push(a_child_has_a_tshirt_size(child, false, ignore_children))}
    {:id => issue.id, :all_children_have_t_sizes =>  child_has_t_shirt.drop_while{|i| i or i.nil?}.empty?}
  end
end

When(/^i check parents for a t-shirt size$/) do
  @parents = @issues.values.collect do |issue|
    first_with_t_shirt_size = find_parents(issue).index do |parent|
      !parent.t_shirt_size.nil? and parent.t_shirt_size != 'Not Specified'
    end
    {:id => issue.id, :first_with_t_shirt_size => first_with_t_shirt_size }
  end
end

When(/^i check the t\-shirt size$/) do
  @issues = @issues.values.collect do |issue|
    {:id => issue.id, :t_shirt_size => issue.t_shirt_size}
  end
end

Then(/^none should have a t\-shirt size$/) do
  check_non_conformities(@children) do |child|
    assert_includes(child, :has_t_size)
    'a child has a t-shirt size' if child[:has_t_size]
  end
end

Then(/^each should trace to a t\-shirt size$/) do
  check_non_conformities(@children) do |child|
    assert_includes(child, :all_children_have_t_sizes)
    'not all children trace to a t-shirt size' unless child[:all_children_have_t_sizes]
  end
end

Then(/^the t\-shirt size must be one of the following:$/) do |table|
  valid_values = table.hashes.collect {|h| h[:value] }
  check_non_conformities(@issues) do |issue|
    assert_includes(issue, :t_shirt_size)
    "had an invalid t-shirt size of: #{issue[:t_shirt_size]}" unless valid_values.include?(issue[:t_shirt_size])
  end
end

Then(/^one must have a t\-shirt size set$/) do
  check_non_conformities(@parents) do |parent|
    assert_includes(parent, :first_with_t_shirt_size)
    'issue is missing a t-shirt size and does not trace to one' unless parent[:first_with_t_shirt_size]
  end
end
