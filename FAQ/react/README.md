# React版FAQクライアントを本番環境にセットアップする手順

## api設定

```
set app("NameSpace") = "FAQ"
set app("DispatchClass") = "FAQ.RestAPI"
set app("AutheEnabled") = 64 + 32
set status = ##class(Security.Applications).Create("/api/faq",.app)  
```

## webgatewayのドキュメントルートにbuildデータをコピー

この場所の以下ディレクトリ一式をwebgatewayのドキュメントルートにコピー

faqdirect
faqmobile
faqsearch

ドキュメントルートは設定次第でカスタマイズ可能だが、デフォルトは以下の通り

/var/www/html

## CSP.confの変更

webgatewayコンテナのCSP.confに以下の行を追加

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
