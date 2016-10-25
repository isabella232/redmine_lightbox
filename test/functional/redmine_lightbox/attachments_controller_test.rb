require File.expand_path('../../../test_helper', __FILE__)
require 'attachments_controller'

# Re-raise errors caught by the controller.
class AttachmentsController;
  def rescue_action(e)
    raise e
  end

  ;
end

class RedmineLightbox::AttachmentsControllerTest < ActionController::TestCase
  tests AttachmentsController

  fixtures :users, :projects, :roles, :members, :member_roles,
           :enabled_modules, :issues, :trackers, :attachments,
           :versions, :wiki_pages, :wikis, :documents

  def setup
    @attachment_storage_path = Attachment.storage_path
    set_fixtures_attachments_directory
  end

  def teardown
    Attachment.storage_path = @attachment_storage_path
  end

  def test_text_preview_ok
    @request.session[:user_id] = 2
    attachment                 = create_text_attachment
    get :text_preview, id: attachment.id, filename: attachment.filename
    assert_response :success
  end

  def test_pdf_preview_ok
    @request.session[:user_id] = 2
    attachment                 = create_document_attachment
    get :pdf_preview, id: attachment.id, filename: attachment.filename
    assert_response :success
  end

  def test_text_preview_should_be_denied_without_permission
    @request.session[:user_id] = nil
    attachment                 = create_text_attachment
    get :text_preview, id: attachment.id, filename: attachment.filename
    assert_redirected_to "/login?back_url=http%3A%2F%2Ftest.host%2Fattachments%2Ftext_preview%2F#{attachment.id}%2F#{attachment.filename}"
  end

  def test_pdf_preview_should_be_denied_without_permission
    @request.session[:user_id] = nil
    attachment                 = create_document_attachment
    get :pdf_preview, id: attachment.id, filename: attachment.filename
    assert_redirected_to "/login?back_url=http%3A%2F%2Ftest.host%2Fattachments%2Fpdf_preview%2F#{attachment.id}%2F#{attachment.filename}"
  end

end
