class BaseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def generate_image_url(image)
    return unless image.attached?

    variant = image.variant(resize: '500x500')
    rails_representation_url(variant)
  end

  def generate_image_urls(images)
    return unless images.attached?

    images.map do |image|
      variant = image.variant(resize: '500x500')
      rails_representation_url(variant)
    end
  end

  def generate_file_url(file)
    return unless file.attached?

    Rails.env.development? || Rails.env.test? ? url_for(file) : file.url
  end

  def generate_file_urls(files)
    return unless files.attached?

    files.map do |file|
      Rails.env.development? || Rails.env.test? ? url_for(file) : file.url
    end
  end
end
