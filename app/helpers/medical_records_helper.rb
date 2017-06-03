# frozen_string_literal: true

module MedicalRecordsHelper
  def show_medical_record_cell(mr, attr)
    html = content_tag('div', class: 'weui-cell') do
      content_tag('div', class: 'weui-cell__bd weui-cell_primary') do
        content_tag('p', MedicalRecord.human_attribute_name(attr.to_sym))
      end +
        content_tag('div', mr.send(attr.to_sym), class: 'weui-cell__ft')
    end
    html
  end
end
