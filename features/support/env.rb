require 'rubygems'
require 'minitest'

module MiniTestAssertions
  def self.extended(base)
    base.extend(MiniTest::Assertions)
    base.assertions = 0
  end

  attr_accessor :assertions
end
World(MiniTestAssertions)

module IssueWorld

  def issue_uri(uri_base, issue_id)
    "#{uri_base}issues/#{issue_id}"
  end

  def html_link_to_issue(uri_base, issue_id)
    "<a target=\"_blank\" href=\"#{issue_uri(uri_base, issue_id)}\">##{issue_id}</a>"
  end

  def report_error_as_html(issue_id, error_text)
    if $config[:html]
      '<p>Issue ' + html_link_to_issue($config['redmine_site'], issue_id) + ' ' + error_text + '</p>'
    else
      "Issue #{issue_uri($config['redmine_site'], issue_id)} #{error_text}"
    end
  end

  def check_non_conformities(issues)
    non_conformities = []
    issues.each do |issue|
      failure_s = yield issue
      non_conformities.push(report_error_as_html(issue[:id], failure_s)) if failure_s
    end
    if $config[:html]
      non_conformities.each {|failure| puts "#{failure}" }
      assert(non_conformities.empty?)
    else
      assert_empty(non_conformities)
    end
  end

  def children(issue)
    $issues.values.select{|where| where.parent_id and (where.parent_id == issue.id)}
  end

  def a_child_has_a_tshirt_size(issue, exclude_root = true, ignore_node = lambda{|_| false })
    children(issue).each do |child|
       unless ignore_node.(child)
         return true if a_child_has_a_tshirt_size(child, false, ignore_node)
       end
     end
    (ignore_node.(issue) or exclude_root) ? nil : (issue.t_shirt_size != nil and issue.t_shirt_size != 'Not Specified')
  end

  def find_parents(issue)
    parents = []
    parent_id = issue.parent_id
    while parent_id
      parent = $issues[parent_id]
      parents << parent
      parent_id = parent.parent_id
    end
    parents
  end

  def find_root_parent(issue)
    parent = issue.parent_id ? $issues[issue.parent_id] : nil
    return issue unless parent
    find_root_parent(parent)
  end

end

World(IssueWorld)
