# frozen_string_literal: true

module Images
  module VersionHelper
    MODE = 1

    def defined_versions
      @defined_versions ||= self.class::VERSIONS.each_with_object({}) { |(k, v), memo| memo[k.to_s] = v; }
    end

    def version_string(version)
      return '' if version.blank?
      size = defined_versions[version]

      str = '?imageView2/' << (size[:mode].present? ? size[:mode] : self.class::MODE).to_s
      str = [str, 'w', size[:width]].join('/') if size[:width]
      str = [str, 'h', size[:height]].join('/') if size[:height]

      # force format to jpg
      str += '/format/jpg'
      str
    end
  end
end
