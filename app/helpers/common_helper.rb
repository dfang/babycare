# frozen_string_literal: true

module CommonHelper
  def format_date_to_ymd(date)
    if date.present?
      date.strftime('%Y-%m-%d') if date.is_a?(Date) || date.is_a?(Time) || date.is_a?(DateTime)
    else
      "无"
    end
  end

  def format_date_to_ymdhms(date)
    if date.present?
      date.strftime('%Y-%m-%d %H:%M:%S') if date.is_a?(Date) || date.is_a?(Time) || date.is_a?(DateTime)
    else
      "无"
    end
  end

  def format_gender(str)
    if str == 'male' || str == '1'
      "男"
    elsif str == 'female' || str == '0'
      "女"
    else
      "未知"
    end
  end

  def format_child_gender_relationship(str)
    if str == 'male'
      "儿子"
    elsif str == 'female'
      "女儿"
    else
      "未知"
    end
  end
end
