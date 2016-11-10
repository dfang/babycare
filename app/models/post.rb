class Post < ActiveRecord::Base
  acts_as_taggable

  TAGS = %w(
      0到1岁
      1岁到3岁
      3到6岁
      6到12岁
      给医生看的文章
      给患者看的文章
      儿童外科
      儿童耳鼻喉咽
      儿童眼科
      儿童口腔
      儿童神经
      儿童心血管
      儿童内分泌
      儿童血液
      儿童消化
      儿童呼吸
      儿童保健
  )

	scope :published, -> { where(published: true) }


	def publish!
    self.published = true
    self.save!
  end

end
