# README

# 12 メールのジョブの永続化を実装

## 内容
- メールのジョブを永続化できるように実装してください。
- ActiveJobのアダプターにはsidekiqを利用してください。

## 補足
- ダッシュボード用にsinatraもインストールする

# 予習
## ActiveJobとは？
- バックグラウンドでさまざまな処理を非同期に行うためのRailsのフレームワーク(現場Rails)
## sidekiqとは？(以前にも使ったが復習)
- sidekiqはresqueやdelayed_jobのような非同期実行を実現するgemです<br>
- キーバリュー型のデータベースのRedisを使う。
>https://qiita.com/nysalor/items/94ecd53c2141d1c27d1f
## sinatraとは？
- Sinatraは最小の労力でRubyによるWebアプリケーションを手早く作るためのDSLです。
- 今回はsidekiqのダッシュボードを表示するために使われる
>http://sinatrarb.com/intro-ja.html

# 実装
## gemのインストール
1. gemの記述
2. `bundle install`

```
#gemfile

# 非同期実行を実現するgem
gem 'sidekiq'
# 最小の労力でRubyによるWebアプリケーションを手早く作るためのDSL
gem 'sinatra'

```
## sidekiqの設定
1. `redis-surver`でredisを起動する
2. `bundle exec sidekiq`
- `bundle exec sidekiq -q default -q mailers`でdefaultというキューとmailersという２種類のキューを受け付ける
```bigquery
$ bundle exec sidekiq -q default -q mailers


               m,
               `$b
          .ss,  $$:         .,d$
          `$$P,d$P'    .,md$P"'
           ,$$$$$b/md$$$P^'
         .d$$$$$$/$$$P'
         $$^' `"/$$$'       ____  _     _      _    _
         $:     ,$$:       / ___|(_) __| | ___| | _(_) __ _
         `b     :$$        \___ \| |/ _` |/ _ \ |/ / |/ _` |
                $$:         ___) | | (_| |  __/   <| | (_| |
                $$         |____/|_|\__,_|\___|_|\_\_|\__, |
              .d$$                                       |_|
      

2022-02-01T09:33:47.292Z pid=67433 tid=oxds3zho5 INFO: Booted Rails 5.2.6 application in development environment
2022-02-01T09:33:47.292Z pid=67433 tid=oxds3zho5 INFO: Running in ruby 2.6.4p104 (2019-08-28 revision 67798) [x86_64-darwin20]
2022-02-01T09:33:47.292Z pid=67433 tid=oxds3zho5 INFO: See LICENSE and the LGPL-3.0 for licensing details.
2022-02-01T09:33:47.292Z pid=67433 tid=oxds3zho5 INFO: Upgrade to Sidekiq Pro for more features and support: https://sidekiq.org
2022-02-01T09:33:47.293Z pid=67433 tid=oxds3zho5 INFO: Booting Sidekiq 6.4.0 with redis options {}
2022-02-01T09:33:47.308Z pid=67433 tid=oxds3zho5 INFO: Starting processing, hit Ctrl-C to stop


```
3. Railsとsidekiqを連携させるための設定を追記して、サーバーの再起動
```bigquery
#config/application.rb

# Railsとsidekiqを連携させるための追記
config.active_job.queue_adapter = :sidekiq
```
```bigquery
#config/sidekiq.rb

# Redisの場所を特定するのにSidekiq.configure_serverブロックとSidekiq.configure_clientブロックの両方を定義する
Sidekiq.configure_server do |config|
  config.redis = {
      url: 'redis://localhost:6379'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
      url: 'redis://localhost:6379'
  }
end
```
```bigquery
#sidekiq.yml

# 同時に処理できるprocessの数を設定
:concurrency: 25
# キューの実行順を設定
:queues:
  - default
  - mailers
```
## sinatraダッシュボードの追加
```bigquery
 # routes.rb

require 'sidekiq/web'

Rails.application.routes.draw do
if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
--     以下を追記
    mount Sidekiq::Web, at: '/sidekiq'
end
```

# 確認してみよう！
1. 投稿にコメントをする
2. メールが送信される(http://localhost:3000/letter_opener/)
- **送れていることを確認!**
   [![Image from Gyazo](https://i.gyazo.com/80a0fa730ecf6751f4ef27a3dd64211d.png)](https://gyazo.com/80a0fa730ecf6751f4ef27a3dd64211d)
3. ダッシュボードで確認(http://localhost:3000/sidekiq/)
- **ダッシュボードでsidekiqが動作していることを確認！**
   [![Image from Gyazo](https://i.gyazo.com/b23ae9a7047e68164bbcad3c8bb5990a.png)](https://gyazo.com/b23ae9a7047e68164bbcad3c8bb5990a)
4. ログでも確認
- **Railsがsidekiqへ指示を出している**
   [![Image from Gyazo](https://i.gyazo.com/5dd9c671a3a5f8c3f23812b6af3e8eb0.png)](https://gyazo.com/5dd9c671a3a5f8c3f23812b6af3e8eb0)
- **sidekiqが動き出した**  
[![Image from Gyazo](https://i.gyazo.com/81982fa609bb326d6a2a97b7d1c8432a.png)](https://gyazo.com/81982fa609bb326d6a2a97b7d1c8432a)
# まとめ
- 今回の目的はsidekiqを用いて、メールに関する処理を別のレールで並行して行えるようにすることと理解
- そしてsidekiqを使うためにはRedisが必要
- また今回はsidekiqの動作を確認するためにsinatraを用いてダッシュボードを使った。

# コメント
- メールなどの重い処理の際にsidekiqは必要であると感じました。
- おそらく規模の大きいアプリになると重要度は増すのではないかと思いました。