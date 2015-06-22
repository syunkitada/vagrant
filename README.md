# Vagrant

これは、Vagrantファイル管理用のリポジトリです。  
また、VMで利用するBind(DNS)の設定ファイルもここで管理しています。


## Vagrantとは
VagrantとはVMM(主にVirtualBox)を利用して仮想の開発環境の作成、管理するためのツールです。  
使い勝手はvirshに似ている。


## インストール
まずは、公式サイトからVagrantとVirtualBoxのインストールしてください。 （インストール方法は割愛）

私の環境は、Windowsを利用しており、インストール後にCygwinからvagrantコマンドが実行できるようになりました。

しかし、vagrantコマンドを実行した時に以下の様なエラーが出ました。(出ない時もある)

```
Vagrant could not detect VirtualBox! Make sure VirtualBox is properly installed.

Vagrant uses the `VBoxManage` binary that ships with VirtualBox, and requires
this to be available on the PATH. If VirtualBox is installed, please find the
`VBoxManage` binary and add it to the PATH environmental variable.
```

どうやら、環境変数のVBOX_INSTALL_PATHにVBOX_MSI_INSTALL_PATHと同じ値を設定しておく必要があるらしい。

環境変数の追加方法は、[コントロールパネル]→[システム]→[システムの詳細設定]→[環境変数] と進み、新規ボタンから、変数名に「VBOX_INSTALL_PATH」、変数値に「%VBOX_MSI_INSTALL_PATH%」を入力して、OK。

環境変数を追加したのち、Cygwinを再起動したところ無事 vagrantコマンドが実行できるようになりました。

また、vagrantのデータは、デフォルトでは C:\Users/[username]/.vagrant.d に保存されます。これは、環境変数VAGRANT_HOMEに値を設定することで、データの格納先を変更できます。


## 使い方
### Boxのインストール
Boxとは、仮想マシンを作成する際に必要なOSのディスクイメージや設定ファイルをまとめたもの。まずは、このBoxを用意します。

以下のサイトから、一般的なBoxが公開されているので、ここから適当なものを選びます。

http://www.vagrantbox.es/

``` bash
# Boxを追加するためのコマンド
$ vagrant box add [box-name] [box-url]
 
# Box追加の例
$ vagrant box add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box
 
# box listで一覧表示
$ vagrant box list
centos65 (virtualbox, 0)
 
# boxは以下のようなファイル構造になっている
% ll ~/.vagrant.d/boxes/centos65/0/virtualbox
合計 278M
-rwxrwx---+ 1 owner None  11K 5月   5 17:46 box.ovf*
-rwxrwx---+ 1 owner None 278M 5月   5 17:46 box-disk1.vmdk*
-rwxrwx---+ 1 owner None   25 5月   5 17:46 metadata.json*
-rwxrwx---+ 1 owner None  505 5月   5 17:46 Vagrantfile*


# 不必要になったら以下のコマンドでboxを削除できる
$ vagrant box remove centos65
```


### 仮想マシンの定義ファイルを作成
仮想マシンは、カレントディレクトリのVagrantfileを参照して立ち上がります。 このVagrantfileには、どのBoxを利用するかや、ネットワークはどうするか、どんなファイル配置するか、puppetやchefを実行するかといった情報を記載します。

これは、コマンドで作成してもいいし、誰かが用意したものを使うのもありです。

``` bash
# Vagrantfileの作成
$ vagrant init [box-name]
 
# Boxがローカル上にない場合でも以下のコマンドでネットワーク上のBoxを指定することもできる
$ vagrant init [box-name] [box-url]
 
# 例
$ vagrant init centos65
```

### 仮想マシンの操作コマンド
Vagrantfileを作成したら、以下のコマンドで仮想マシンの起動や停止といった操作が可能になります。

| コマンド    | 操作                                                                                            |
|:------------|:------------------------------------------------------------------------------------------------|
| up          | 仮想マシンの起動（仮想マシンが作成されてなかったら作成も行う）                                  |
| status      | 仮想マシンの状態を表示する                                                                      |
| suspend     | サスペンド (vagrant upで再開)                                                                   |
| halt        | シャットダウン (vagrant upで起動)                                                               |
| ssh-config  | SSHの設定情報を表示                                                                             |
| ssh         | SSH接続する                                                                                     |
| reload      | 再起動する                                                                                      |
| destroy     | 仮想マシンをシャットダウンし破棄する (Vagrantfileは消えないので、再びvagrant upで再構成できる） |
                                                                                                                |

### Boxパッケージ化とその利用
既存のBoxを改造して、それを新しいBoxとして流用したい場合がある。

``` bash
# 以下のコマンドで仮想マシンを停止してパッケージ化する
$ vagrant package
 
# package.boxファイルが作成されるので、これをbox addすると利用できるようになります
# また、これをネットワーク上に公開することで、他者がこれを利用することもできます
$ ll
合計 281M
-rwxr-xr-x 1 owner None 281M 9月  21 20:59 package.box*
-rwxr-xr-x 1 owner None 4.8K 9月  21 19:08 Vagrantfile*
 
$ vagrant box add centos65_2 package.box
 
$ vagrant init centos65_2
 
$ vagrant up
```

### スナップショット
``` bash
# プラグインをインストールする
$ vagrant plugin install vagrant-vbox-snapshot

# スナップショットを取る
$ vagrant snapshot take <snapshot name>

# 一覧表示
$ vagrant snapshot list

# スナップショットの状態に移行する
$ vagrant snapshot go <snapshot name>

# スナップショットを削除する
$ vagrant snapshot delete <snapshot name>
```

## Vagrantfileの設定メモ

``` bash
# boxの設定
config.vm.box="centos64"
 
# ネットワークの設定
config.vm.network :private_network, ip:"192.168.33.10"
```
