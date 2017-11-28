module UsersHelper
  def age_in_natural_language(age)
    age_in_natural_language = ""
    ["岁", "个月", "天"].each_with_index do |unit, index|
      if age[index] != 0
        age_in_natural_language += age[index].to_s + unit
      end
    end
    age_in_natural_language
  end
end
