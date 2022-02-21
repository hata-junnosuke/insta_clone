# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      # サイト名
      site: Settings.meta.site,
      # trueを設定することで「タイトル | サイト名」の並びで出力してくれる
      reverse: true,
      # タイトルを設定
      title: Settings.meta.title,
      # descriptionを設定
      description: Settings.meta.description,
      # キーワードを「,」区切りで設定
      keywords: Settings.meta.keywords,
      # canonicalタグを設定
      canonical: request.original_url,
      # オープングラフ
      og: {
        title: :full_title,
        type: Settings.meta.og.type,
        url: request.original_url,
        image: image_url(Settings.meta.og.image_path),
        site_name: :site,
        description: :description,
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image'
      }
    }
  end
end
