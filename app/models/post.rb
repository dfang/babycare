class Post < ActiveRecord::Base
  acts_as_taggable

  TAGS = %w(
      3个月以下
      3个月到一岁
      一岁到三岁
      三到六岁
      六到十二岁
      给医生看的文章
      给患者看的文章
  )

	def publish!
    self.published = true
    self.save!
  end

end
