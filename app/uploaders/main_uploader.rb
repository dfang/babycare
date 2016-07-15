class MainUploader < BaseVersionUploader
  # 图片version定义在 lib/extras/images/definition
  include Images::Definition

  def store_dir
    current_user_id = model.user_id

    if current_user_id.present?
      "users/#{current_user_id}"
    else
      "common"
    end
  end

end
