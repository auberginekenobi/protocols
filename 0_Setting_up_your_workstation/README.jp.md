# Session 0 - `conda` でワークステーションを構築する

[English](README.md) | 日本語

更新日 2026-06-11

> この文書は AI（Claude Opus 4.8）によって `README.md` から翻訳されました。正式な原文は英語版です。誤りや不自然な表現に気づいた場合は、英語版を参照してください。

## 目的
バイオインフォマティクスを行うには、誰かが書いて配布している既存のソフトウェア
*（パッケージ、packages）* を実行する必要があります。それらのパッケージは動作のために、さらに別の
サードパーティ製パッケージを必要とし（*依存関係、dependencies*） 、それらもまた
さらに別の依存関係を必要とする、というように続いていきます。外部のバイオインフォマティクス
ソフトウェアを簡単にインストールして実行するには、*パッケージマネージャ（package manager）* を
使う必要があります。ここでは `conda` パッケージマネージャを使って、バイオインフォマティクスの
ワークステーションを構築します。

## 動作環境（Dependencies）

このチュートリアルは Mac OS 13.5 と Ubuntu 16 で作成・テストされています。WSL2（Windows）でも
同様の結果が得られます。

## チュートリアル
0. コマンドラインのプロンプトを開きます。[^1]
1. お使いのオペレーティングシステムに対応した miniforge[^2] のインストーラを[ダウンロード](https://github.com/conda-forge/miniforge)して実行します。EULA に同意し、デフォルトの場所にインストールし、conda に `.bashrc`[^3]、`$PATH`[^4]、環境変数を変更させます。
   ```
   curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
   chmod +x Miniforge3-$(uname)-$(uname -m).sh # 実行可能になるよう権限を変更
   ./Miniforge3-$(uname)-$(uname -m).sh # 実行
   ```
2. `conda` を `$PATH` に追加します。
   ```
   conda init
   # conda はシェルを閉じて再度開くよう促しますが、次でも構いません
   source ~/.bashrc
   ```
   これで、シェルのプロンプトに `(base)` という接頭辞が付くことに気づくかもしれません。たとえば `(base) ochapman@12005L4953 %` のようになり、現在 *base* *環境* で作業していることを示します。これについては後ほど説明します。
3. python をインストールします。
   ```
   conda install python
   ```
##########################
### チェックポイント
これで Python 3 の最小限の動作環境が整いました。ターミナルで `python` というコマンドを入力すると、python でのプログラミングを始められます。終了するには `Ctrl+d` です。
##########################

次に、*環境（environments）* と *jupyter* ノートブックインターフェースをセットアップします。

4. よく使うバイオインフォマティクスのパッケージリポジトリを追加します。
   ```
   conda config --prepend channels r
   conda config --prepend channels bioconda
   conda config --prepend channels conda-forge
   conda config --set channel_priority strict
   ```
   [^5]
5. `jupyter` プロジェクトは、データサイエンス言語である Python と R のためのインタラクティブなユーザーインターフェースを提供しようという、長年にわたる取り組みです。[^6]
   ```
   conda install jupyter
   ```

   これで *base 環境（base environment）*、つまり他の conda パッケージをインストールして実行するために必要な最小限のソフトウェアが整いました。一番良い方法は、ここには conda の最小限のインストールだけを残し、よく使う用途ごとに新しい環境を作成することです。次にそれを行いましょう。

6. 私の基本的なデータ解析ツールボックスは、Python 3 といくつかの一般的なパッケージを使います。
   ```
   # "py3" という名前の新しい conda 環境を作成
   conda create --name py3

   # 環境を「アクティベート」して切り替える
   conda activate py3

   # データ解析ツールをインストール
   conda install python numpy pandas scipy statsmodels scikit-learn openpyxl --yes

   # データ可視化ツール
   conda install matplotlib seaborn --yes

   # ipykernel は jupyter からこの環境とここにインストールされた全パッケージへのアクセスを可能にします。
   conda install ipykernel --yes
   # このコマンドで、新しい環境を jupyter のインストールに追加します。
   python -m ipykernel install --user --name py3 --display-name "py3"

   # 作業が終わったらデアクティベート
   conda deactivate
   ```
   [^7]

   conda 環境がアクティベートされている間、その環境にインストールされたパッケージは `$PATH` に追加され、Python や bash など、普段使っている方法で利用できるようになります。

7. これで新しい Python 環境を使う準備が整いました。次を実行してください。
   ```
   jupyter lab
   ```
   インストールが成功していれば、このコマンドで `jupyter lab` インターフェースが表示されたウェブブラウザが開きます。jupyter が初めての場合は、ガイドツアーに従ってください。今後のチュートリアルもお楽しみに。
   ![jupyter](../docs/0-jupyter-landing.png)

## アンインストール
```
# Jupyter の設定などを削除
jupyter --paths | grep '^\s' | xargs -I{} rm -rf {}

# ルートプレフィックスを削除
rm -rf $(conda info --base)

# 設定ファイル（conda のインストール間で共通）
rm ~/.condarc
# 環境の場所とシステム情報
rm -rf ~/.conda
```
（任意）`.zshrc`/`.bashrc` にシェルフックを追加していた場合は、それらも削除して構いません。

# トラブルシューティング
- [Windows 上の WSL2] `CondaHTTPError: HTTP 000 CONNECTION FAILED for url <https://repo.anaconda.com/pkgs/main/linux-64/current_repodata.json>
要点：シェルを閉じて開き直してください。` [出典](https://stackoverflow.com/questions/67923183/miniconda-on-wsl2-ubuntu-20-04-fails-with-condahttperror-http-000-connection)
- [Apple シリコンアーキテクチャの Mac OS] 多くのパッケージ（特に bioconductor）は、まだ Apple シリコン用のビルドがありません。`PackageNotFoundError` が出て、かつ Apple シリコンで動作している場合（`conda info` で conda のインストールの詳細を確認できます。`platform : osx-arm64` であれば Apple シリコンです）、`conda config --env --set subdir osx-64` を実行すると、conda に旧来の Intel アーキテクチャを使わせることができます。[出典](https://stackoverflow.com/questions/65415996/how-to-specify-the-architecture-or-platform-for-a-new-conda-environment-apple)

[^1]: [Mac OS] Terminal アプリです。[Windows] [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) が頼りになりますが、ドライブのマウントは難しいです。[Linux] Bash シェルです。
[^2]: `conda` はパッケージマネージャのソフトウェアそのものです。本質的には同じものにいくつかの種類があり、主な違いは次のとおりです。
    - `anaconda` は Anaconda, Inc. が開発しており、多数のパッケージがあらかじめインストールされています。
    - `miniconda` は anaconda の最小限のインストールで、Python、conda、その他いくつかの便利なパッケージだけを含みます。
    - `miniforge` は conda の最小限のオープンソース版インストールです。
[^3]: `.bashrc`、`.bash_profile` などは、コマンドプロンプトを開くたびに実行されるスクリプトです。[^8]
[^4]: `$PATH` は、OS が実行可能なコマンドを探す場所です。これにより、「conda init」と入力したときに、システムが `conda` コマンドを `init` パラメータ付きで実行すべきだと分かります。
[^5]: `# 注意：多くのプログラミング言語（python、bash、R を含む）では、コメントは '#' で示され、その右側はすべてコマンドの一部ではありません。`
[^6]: Jupyter プロジェクトには、比較的新しいプログラミング言語である Julia も含まれており、それが「ju-pyt-r」という名前の由来です。
[^7]: 自分の環境を記録しておき、どこにでもすばやくインストールできるよう、私はコマンドラインからではなくファイルからインストールすることがよくあります。このための conda コマンドは `conda env create -f environment.yml` です。
[^8]: Mac OS では `.zshrc` と `.zsh_profile` です。
