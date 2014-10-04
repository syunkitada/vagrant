# named

## 環境
* windows7
* BIND

## インストール
[ダウンロードサイト](http://www.isc.org/downloads/bind/)よりインストール

インストール時の設定項目は以下のようにした（デフォルトのまま、パスワードだけ変えただけ）
* Target Directory: C:\Program Files\ISC BIND 9
* Service Account Name: named
* Password: ****

インストール後、"C:\Program Files\ISC BIND 9\bin"  は、PATHに登録しておく。

C:\Program Files\ISC BIND 9\etc に設定ファイルを配置し、
namedサービスを起動すると完了。  
また、初期状態では設定ファイルが存在しないので起動に失敗します。


restart_named.bat を管理者権限で実行すると、カレントディレクトリのetcを
"C:\Program Files\ISC BIND 9\etc"にコピー（上書き）し、namedサービスをリスタートします。


## リゾルバの設定
### 現在の設定を確認
``` bash
# digでデフォルトのリゾルバを見てみる
$ dig
...
;; SERVER: 192.168.11.1#53(192.168.11.1)

# localhostをリゾルバにしてdigすると、設定したipがとれる
$ dig dev01.vagrant.mydns.jp @localhost

;; ANSWER SECTION:
test01.vagrant.mydns.jp. 86400  IN      A       192.168.11.50

;; SERVER: 127.0.0.1#53(127.0.0.1)
```

### リゾルバをlocalhostに変更する
Linuxだと/etc/resolv.confでリゾルバを設定するが、Windowsだと各ネットワークデバイスのプロパティを編集する必要がある。

* プログラムとファイルの検索から"ネットワーク接続の表示"を開く。
* ネットワークデバイスのプロパティを開く
* 接続項目から"インターネット プロトコル バージョン 4"の選択肢プロパティを開く
* "次のDNSサーバのアドレスを使う"にチェックを入れて、DNSサーバのIPを設定する
    * 優先DNSサーバ: 127.0.0.1
    * 代替DNSサーバ: 192.168.11.1

設定後にdigをすると、デフォルトのリゾルバが127.0.0.1となる。
```
$ dig dev01.vagrant.mydns.jp

;; ANSWER SECTION:
test01.vagrant.mydns.jp. 86400  IN      A       192.168.11.50

;; SERVER: 127.0.0.1#53(127.0.0.1)
```


## 参考
* http://www.zelazny.mydns.jp/archives/002787.php
* http://www.bit-drive.ne.jp/support/technical/dns/pdf/dns_dnsserver_guide.pdf
