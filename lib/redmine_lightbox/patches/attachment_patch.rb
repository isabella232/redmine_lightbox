require_dependency 'attachment'

module RedmineLightbox
  module Patches
    module AttachmentPatch
      extend ActiveSupport::Concern

      included do
        has_one :pdf_preview, dependent: :destroy

        after_save :generate_pdf_preview
      end

      def has_pdf_preview?
        pdf_preview && pdf_preview.file_exist?
      end

      def generate_pdf_preview(force = false)
        PdfPreview.generate_for self, force
      end

      def convertible_to_pdf?
        PdfPreview.can_generate_from? self
      end

      def is_image?
        Redmine::MimeType.is_type?('image', filename)
      end

      def is_pdf?
        Redmine::MimeType.of(filename) == 'application/pdf'
      end

    end
  end
end

unless Attachment.included_modules.include?(RedmineLightbox::Patches::AttachmentPatch)
  Attachment.send(:include, RedmineLightbox::Patches::AttachmentPatch)
end
