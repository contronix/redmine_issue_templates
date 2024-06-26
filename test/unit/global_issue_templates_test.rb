require File.expand_path('../test_helper', __dir__)

class GlobalIssueTemplatesTest < ActiveSupport::TestCase
  fixtures :global_issue_templates, :users, :trackers

  def setup
    @global_issue_template = GlobalIssueTemplate.find(1)
  end

  def test_truth
    assert_kind_of GlobalIssueTemplate, @global_issue_template
  end

  def test_template_enabled
    enabled = @global_issue_template.enabled?
    assert_equal true, enabled, @global_issue_template.enabled?

    @global_issue_template.enabled = false
    @global_issue_template.save!
    enabled = @global_issue_template.enabled?
    assert_equal false, enabled, @global_issue_template.enabled?
  end

  def test_sort_by_position
    a = GlobalIssueTemplate.new(title: 'Template4', position: 2, tracker_id: 1)
    b = GlobalIssueTemplate.new(title: 'Template5', position: 1, tracker_id: 1)
    assert_equal [b, a], [a, b].sort
  end

  def test_required_attributes_should_be_validated
    {
      title: ' ',
      tracker: nil,
      description: " \n\n ",
    }.each do |attr, val|
      @global_issue_template.reload
      @global_issue_template.__send__("#{attr}=", val)

      assert_raises ActiveRecord::RecordInvalid do
        @global_issue_template.save!
      end

      assert_includes @global_issue_template.errors[attr], 'cannot be blank'
    end
  end
end
