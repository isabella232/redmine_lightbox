require File.dirname(__FILE__) + '/../../test_helper'
require 'issues_controller'

class RedmineLightbox::IssuesControllerTest < ActionController::TestCase
  tests IssuesController

  fixtures :users, :projects, :roles, :members, :member_roles,
           :enabled_modules, :issues, :issue_statuses, :trackers, :attachments,
           :versions, :wiki_pages, :wikis, :documents, :enumerations

  def setup
    @request.session[:user_id] = 2
    @attachment_storage_path = Attachment.storage_path
    set_fixtures_attachments_directory
  end

  def teardown
    Attachment.storage_path = @attachment_storage_path
  end

  def test_should_show_issue_with_attachments_and_previews
    get :show, id: 2
    assert_response :success
  end
end
