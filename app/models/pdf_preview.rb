class PdfPreview < ActiveRecord::Base
  EXT         = 'pdf'
  ALLOWED_FOR = %w(doc docx rtf)

  belongs_to :attachment

  validates :attachment, presence: true

  after_destroy :delete_from_disk!

  class << self

    # Can pdf preview be generated for this attachment?
    def can_generate_from?(attachment)
      ALLOWED_FOR.include? attachment.filename.rpartition('.')[2].downcase
    end

    # Generate pdf preview for this attachment
    def generate_for(attachment, force = false)
      return nil unless can_generate_from?(attachment)

      pdf_preview = attachment.pdf_preview

      # Do not generate preview for existing one (unless force option is set)
      return pdf_preview if pdf_preview && pdf_preview.file_exist? && !force

      # Create record in DB for pdf preview if not created yet
      unless pdf_preview
        pdf_preview = attachment.create_pdf_preview
      end

      # Generate pdf file
      pdf_preview.create_preview

      pdf_preview
    end
  end

  def filename
    source = attachment.filename
    RedmineLightbox::Services::DocumentConverter::preview_filename_for(source, EXT)
  end

  def content_type
    Redmine::MimeType.of(filename)
  end

  def diskfile
    source = attachment.diskfile
    RedmineLightbox::Services::DocumentConverter::preview_filename_for(source, EXT)
  end

  def file_exist?
    diskfile.present? && File.exist?(diskfile)
  end

  def create_preview
    Workers::DocumentConverter.defer(attachment.diskfile, EXT)
  end

  private

  def delete_from_disk!
    File.delete(diskfile) if file_exist?
  end
end
