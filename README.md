## Remotty連携アプリの実装
### 概略
* remotty_railsGemを導入すると、導入したアプリケーションでremotty認証できるようになる
* remotty_rails_rooms（ルーム）、remotty_rails_users（ユーザ）、remotty_rails_participations（ルーム参加者）という3つのテーブルのcreate migrationファイルが作成される
  - 認証はRemotty経由になるのでDeviseの導入やUserモデルの作成は不要
* remottyのREADME.mdにもアプリ連携の情報が記載されているため、目を通しておくこと

### 手順
#### 新規アプリケーションを作る
1. rails newする、もしくは既存のRemotty連携アプリをコピーする
1. Gem追加
  * Gemfileに追加
  1. gem 'remotty_rails', git: 'https://github.com/SonicGarden/remotty_rails'

#### ローカルにremottyを入れて動作させる
* 新規アプリケーションとは別にローカルにRemotty本体をクローンする
  * ローカルのremottyに認証して、新規アプリケーションの実装を進めていくため

#### 認証アプリの登録、認証情報を取得・設定
1. ローカルのremottyでhttp://remotty.dev/oauth/applications にアクセス
1. 開かれた画面でOAuthProviderアプリの情報を下記のように入力(xxxxx.devのところは自分が作るWebアプリケーションのドメイン)
  * Name: 任意の名前をつける
  * Url : http://xxxxx.dev/  
  * Redirect Url : http://xxxxx.dev/auth/remotty/callback
  * Script Url：？
    - 公式アプリ、ルーム単位のアプリ、公開する：ひとまずチェックを入れ良い（用途に応じてチェックの有無を変更）
    - ※注意としては、この時点では認証アプリケーションの情報は登録されるが、ルームとの紐付けはまだ行われていない

1. 登録して遷移後の画面の情報を元に、新規アプリケーション側でconfig/remotty.ymlを作成（項目は他の連携アプリのremotty.ymlを参照）
  - Applicationにremotty_keyの値を入れる
  - Secretにremotty_secretの値を入れる

#### remottyルームと新規アプリケーションの紐付け
1. ローカルのremotty側に戻り、コンソールでルームとアプリケーションの紐付けを行う。  
  - `room = Room.find( XX )`
  - `room.room_applications.create(oauth_application_id: XX)`
1. ここで、Roomとapplicatioの紐付けが行われたことを確認する
  * Remmotyのアプリの一覧に追加されていることを確認する
    - https://www.remotty.net/ 右上のドロップダウン

#### 新規アプリケーション側で認証処理が実行されるようにする
* `rake remotty_rails:install:migrations`でmigration fileをコピーする
* `rake db:migrate`して、remotty_rails_rooms（ルーム）、remotty_rails_users（ユーザ）、remotty_rails_participations（ルーム参加者）という3つのテーブルを作る
* 既存のremotty連携アプリから認証関連のクラスやメソッドをコピーしてくる
  - AuthorizationsControllerをコピーして、新規アプリケーションに追加
  - また、ApplicationControllerを参照し、新規アプリケーション側にも以下の2つを追加
    - RemottyRails::Sessionのインクルードを追加
    - before_action :store_location, :authenticate_remotty_user!
- ここまでやると新規アプリケーションのroot_pathにアクセスした時点で認証処理が実行されるようになっている
- もしこの時点で認証に失敗するようであれば、remotty側の認証アプリケーションの登録とroomが紐付いていることを確認する必要がある
  - 認証に失敗すると認証に失敗したことを示すメッセージが画面に表示される
  - ローカルのremottyと新規アプリケーションのDBのテーブルを確認して紐付けを確認する。
  - 認証アプリとremottyルームが紐付いているかを確認する場合、以下のテーブルを確認する
    - remotty側
      - roomsテーブル（IDを確認してルームIDを確認）
      - oauth_applicationsテーブル（IDを確認して新規アプリケーションのIDを確認する）
      - ↑2つの紐付けを行っているroom_applicationにレコードあることを確認（room_id、oauth_application_idにそれぞれ確認したIDが入っていることを確認）
    - 認証アプリケーション側
      - remotty_rails_roomsテーブルにレコードが作成されていることを確認
      - ※何度かApplicationControllerのbefore_actionで認証処理を実行すると勝手に登録されている。（ここに登録されているトークン情報を元に認証処理を行っている。）
