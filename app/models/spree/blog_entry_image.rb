class Spree::BlogEntryImage < Spree::Image
  default_scope { where(position: 2 ) }

  def attachment_file_name
    if attachment.attached?
      attachment.filename
    else
      self[:attachment_file_name]
    end
  end
end
