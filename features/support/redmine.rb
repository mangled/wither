require 'rubygems'
require 'uri'
require 'rest-client'
require 'json'

module Redmine

  def Redmine.get_with_pagination(url, params, field)
    offset = 0
    while true
      params[:params][:offset] = offset
      json = JSON.parse(RestClient.get(url, params.dup).to_str)
      yield json[field]
      read = json[field].length
      remaining ||= json['total_count'].to_i
      remaining -= read
      raise 'Total count does not match the read count' if remaining < 0
      offset += read
      break if remaining == 0
    end
  end

  def Redmine.get_issues(issues_url, params)
    issues = []
    Redmine.get_with_pagination(issues_url, params, 'issues') do |fetched|
      fetched.each {|issue| issues << issue }
    end
    issues
  end

  def Redmine.issues(config, status_id = 'open')
    params = {
        :params => {
            :status_id => status_id,
            :limit => config['max_fetch_size'],
            :project_id => config['parent_project_id'],
            :subproject_id => config['sub_project_id']
        }
    }
    issues_url = URI.join(config['redmine_site'], 'issues.json').to_s
    Redmine.get_issues(issues_url, params)
  end

  def Redmine.user(config, user_id)
    users_root_url = URI.join(config['redmine_site'], 'users/')
    user_url = URI.join(users_root_url, "#{user_id}.json")
    response = RestClient.get(user_url.to_s, { :params => { :key => config['redmine_key'] }})
    JSON.parse(response.to_str)['user']
  end

  # This uses a heuristic to try to find the most sensible assignee, if one is missing
  def Redmine.assignee(config, issue_id)
    issues_root_url = URI.join(config['redmine_site'], 'issues/')
    issues_url = URI.join(issues_root_url, "#{issue_id}.json")
    response = RestClient.get(issues_url.to_s, { :params => { :key => config['redmine_key'], :include => 'journals' }})
    issue = JSON.parse(response.to_str)['issue']

    # if assigned to is set, then we are done
    assigned_to = nil
    assigned_to = issue['assigned_to']['id'] if issue.has_key?('assigned_to')

    if assigned_to.nil?
      # Go backwards through the journals, find the last change to the assigned to property
      # When this went to "nil" essentially, i.e. the old value had the last assignee
      journals = issue['journals']
      unless journals.empty?
        journals.reverse_each do |journal|
          journal['details'].each do |detail|
            if detail['name'] == 'assigned_to_id'
              raise 'new value is present - logic error' if detail.has_key?('new_value')
              assigned_to = detail['old_value']
            end
          end
          break if assigned_to
        end
      end
      # We have run out of options, so pick the author of the ticket
      assigned_to = issue['author']['id'] unless assigned_to
    end

    # Now get the users details from Redmine
    assigned_to.nil? ? nil : Redmine.user(config, assigned_to)
  end

end
