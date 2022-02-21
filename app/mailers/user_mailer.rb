class UserMailer < ApplicationMailer
  def like_post
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @post = params[:post]
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたの投稿にいいねしました")
  end

  def comment_post
    # コメントを受けたユーザー
    @user_from = params[:user_from]
    # コメントをしたユーザー
    @user_to = params[:user_to]
    @comment = params[:comment]
    #コメントを受けたことを通知するメールを設定
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたの投稿にコメントしました")
  end

  def follow
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたをフォローしました")
  end
end
