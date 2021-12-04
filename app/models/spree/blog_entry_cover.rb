class Spree::BlogEntryCover < Spree::Image
  default_scope { where(position: 1 ) }

  def attachment_file_name
    if attachment.attached?
      attachment.filename
    else
      self[:attachment_file_name]
    end
  end
end
