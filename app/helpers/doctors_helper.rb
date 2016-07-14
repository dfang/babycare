module DoctorsHelper
  def show_holder_or_image(obj, prop, size)
    if obj.present? && obj.send(prop.to_sym).present?
      image_tag obj.send(prop.to_sym), size: size
    else
      holder_tag size
    end
  end
end
