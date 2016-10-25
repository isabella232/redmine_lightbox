require File.expand_path('../../../test_helper', __FILE__)

class RedmineLightbox::AttachmentTest < ActiveSupport::TestCase
  fixtures :users, :projects, :roles, :members, :member_roles,
           :enabled_modules, :issues, :trackers, :attachments

  def setup
    set_tmp_attachments_directory
  end

  def test_transformed_preview_should_not_generate_the_preview_for_jpg
    attachment = Attachment.find(16)

    # Ensure that no pdf preview exist before test
    refute attachment.has_pdf_preview?

    # Trying to generate preview
    attachment.generate_pdf_preview
    attachment.reload

    refute attachment.has_pdf_preview?
  end

  def test_manual_generate_pdf_preview
    attachment = create_document_attachment

    # Delete automatically generated preview
    attachment.pdf_preview.try(:destroy)
    attachment.reload

    # Ensure that no pdf preview exist before test
    refute attachment.has_pdf_preview?

    # Trying to generate preview
    attachment.generate_pdf_preview
    attachment.reload

    assert attachment.has_pdf_preview?
  end

  def test_pdf_preview_generates_automatically
    attachment = create_document_attachment
    assert attachment.has_pdf_preview?
  end

  def test_text_attachment_do_not_generate_pdf_preview
    attachment = create_text_attachment
    refute attachment.has_pdf_preview?
  end
end
