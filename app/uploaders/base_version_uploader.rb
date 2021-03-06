# frozen_string_literal: true

require 'carrierwave/processing/mini_magick'

class BaseVersionUploader < BaseUploader
  DEFAULT_VERSION = nil
  VERSIONS = {}.freeze
  THUMBNAIL_MODEL = 1

  # https://docs.qiniutek.com/v3/api/foimg/#imageView
  # <URL>?imageView/2/w/130/h/200
  def url(opts = {})
    to_crop = false
    version = self.class::DEFAULT_VERSION

    if opts.present?
      if opts.is_a?(Hash)
        version = opts[:version] if opts[:version].present?
        to_crop = opts[:to_crop] if opts[:to_crop].present?
      elsif opts.is_a?(Symbol) || opts.is_a?(String)
        version = opts
      end
    end

    version = version.to_s

    _url = super()

    _url = replace_with_croped_filename(_url) if to_crop

    return version_default_url(version) if _url.blank?
    return _url if version.blank?

    unless defined_versions.key?(version)
      raise "CoverUploader version: #{version} is not allow."
    end

    _url << version_string(version)
  end

  protected

  # 因为override了url方法，default_url方法不能拼接version
  # https://<QINIU_DOMAIN>/default/covers/<GENRE>.jpg
  def version_default_url(_version)
    nil
  end

  def version_string(version)
    return '' if version.blank?
    size = defined_versions[version]

    str = '?imageView/' << (size[:thumbnail_model].present? ? size[:thumbnail_model] : self.class::THUMBNAIL_MODEL).to_s
    str = [str, 'w', size[:width]].join('/') if size[:width]
    str = [str, 'h', size[:height]].join('/') if size[:height]

    # force format to jpg
    str += '/format/jpg'
    str
  end

  def defined_versions
    @defined_versions ||= self.class::VERSIONS.each_with_object({}) { |(k, v), memo| memo[k.to_s] = v; }
  end

  def replace_with_croped_filename(url)
    uri = URI.parse url
    paths = uri.path.split('/')
    paths[-1] = model.croped_image
    uri.path = paths.join('/')
    uri.to_s
  end
end
