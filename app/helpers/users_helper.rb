# frozen_string_literal: true

module UsersHelper
  def age_in_natural_language(age)
    age_in_natural_language = ''
    %w[岁 个月 天].each_with_index do |unit, index|
      age_in_natural_language += age[index].to_s + unit if age[index] != 0
    end
    age_in_natural_language.remove!(age[2].to_s + '天') if age[0] > 0
    age_in_natural_language
  end

  def relationship_from_gender(gender)
    if gender == 'male'
      '儿子'
    else
      '女儿'
    end
  end
end
