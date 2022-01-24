# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # flashタイプ
  add_flash_types :success, :info, :warning, :danger
  # ログイン制御
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end
end
