# repositories

`source`を呼び出して機能を作り出します。

ユーザーのデータを保存、作成、更新、削除する`UserRepository`

アプリ内での通知機能を提供する`LocalNotificationRepository`

上記の内容より誤解してはいけないのは一つの`repository`内で複数の`source`を呼び出すことがダメではありません。
一対一の関係ではないのです。

あくまで関心事に対して行う操作の方法を提供するのです。
ここがserviceと混同しがちな部分なので、注意しましょう。
