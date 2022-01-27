class SearchPostsForm
  # ActiveModelのModelモジュールを導入しています。これで、ActiveRecordの機能が使えるようになります。
  include ActiveModel::Model
  # attributeメソッドが使えるようになります
  include ActiveModel::Attributes

  # post_content、comment_content、nameをstring型の属性として定義
  attribute :body, :string
  attribute :comment_body, :string
  attribute :username, :string

  def search
    scope = Post.distinct # ここでダブりのコメントがあれば2件となるのを防ぐ。
    scope = splited_bodies.map { |splited_body| scope.body_contain(splited_body) }.inject { |result, scp| result.or(scp) } if body.present?
    # コメント検索欄が埋まっていれば、Postの中で.00_containに当たるものを取ってくる
    scope = scope.comment_body_contain(comment_body) if comment_body.present?
    scope = scope.username_contain(username) if username.present?
    scope
  end

  private

  def splited_bodies
    # 前後の空白をなくして、間の空白で区切って配列を作っている
    body.strip.split(/[[:blank:]]+/)
  end
end
