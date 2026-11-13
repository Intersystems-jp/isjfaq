# React版FAQクライアントを本番環境にセットアップする手順

## webgatewayのドキュメントルートにbuildデータをコピー

faqreaact.zipファイルを解凍すると、以下のディレクトリ一式をwebgatewayのドキュメントルートにコピー

faqdirect
faqmobile
faqsearch

ドキュメントルートは設定次第でカスタマイズ可能だが、デフォルトは以下の通り

/var/www/html

## csp.confの変更

webgatewayコンテナのcsp.confに以下の行を追加

### dir_moduleのロード

LoadModule dir_module /usr/lib/apache2/modules/mod_dir.so

### DirectyIndexの設定

DirectoryIndex index.html

### ドキュメントルートの設定

DocumentRoot "/var/www/html"

## 動作確認

正しく設定できていれば、ブラウザから以下のようにアクセスできるはず

### PC版FAQ検索

https://faq.intersystems.co.jp/faqsearch/

### モバイル版FAQ検索

https://faq.intersystems.co.jp/faqmobile/

### ID直接指定

DC記事が存在する場合には、そのリンクを表示する

https://faq.intersystems.co.jp/faqdirect/Contentdc/400

DC記事が存在する場合でも、FAQシステムの内容を表示する

https://faq.intersystems.co.jp/faqdirect/Content/400
