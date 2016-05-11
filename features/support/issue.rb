module Issue

  Fields ||= Struct.new(
      :id,
      :parent_id,
      :t_shirt_size,
      :source,
      :assigned_to,
      :strategic_estimate,
      :analysis_estimate,
      :status,
      :project,
      :fixed_version,
      :tracker,
      :created_on
  ) do

    def is_effort_bucket?
      return tracker =~ /Effort Bucket/i
    end

    def t_shirt_size_eds
      case t_shirt_size
        when /tiny/i then 1
        when /small/i then 3
        when /medium/i then 5
        when /large/i then 10
        else
          0
        end
    end
  end

  def Issue.dehydrate(issue)
    Fields.new(
        issue['id'],
        Issue.field(issue, 'parent'),
        Issue.custom_field(issue, 'T-shirt size'),
        Issue.custom_field(issue, 'Source'),
        Issue.field(issue, 'assigned_to'),
        Issue.custom_field(issue, 'Strategic Estimate'),
        Issue.custom_field(issue, 'Analysis Estimate'),
        Issue.field(issue, 'status'),
        Issue.field(issue, 'project'),
        Issue.field(issue, 'fixed_version'),
        Issue.field(issue, 'tracker'),
        issue['created_on']
    )
  end

  def Issue.custom_field(issue, name)
    Issue.nill_if_empty(Issue.value(issue['custom_fields'].find {|field| field['name'] =~ /#{name}/i }))
  end

  def Issue.field(issue, name)
    Issue.value(issue[name]) if issue.has_key?(name)
  end

  def Issue.nill_if_empty(value)
    (value.nil? || value.empty?) ? nil : value
  end

  # This assumes we care about things in a preferential order, i.e.
  # value over name over id. If you have a field where you want the id and there
  # is a name, for example, then this will not work for you :-)
  def Issue.value(field)
    return nil unless field
    if field.has_key?('value')
      field['value']
    elsif field.has_key?('name')
      field['name']
    elsif field.has_key?('id')
      field['id']
    elsif field.has_key?('on')
      field['on']
    end
  end

end
