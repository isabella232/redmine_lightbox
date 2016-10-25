class RenameAttachmentPreviewsToPdfPreviews < ActiveRecord::Migration
  def up
    rename_table :attachment_previews, :pdf_previews
    add_index :pdf_previews, :attachment_id, unique: true
  end

  def down
    remove_index :pdf_previews, :attachment_id
    rename_table :pdf_previews, :attachment_previews
  end
end
