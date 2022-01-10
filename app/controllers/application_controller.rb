# frozen_string_literal: true

class ApplicationController < ActionController::Base
  #flashタイプ
  add_flash_types :success, :info, :warning, :danger
end
