# セッション2 - 遺伝子発現差解析（differential gene expression）

[English](README.md) | [日本語](README.jp.md)

> この文書は AI（Claude Opus 4.8）によって `README.md` から翻訳されました。正式な原文は英語版です。誤りや不自然な表現に気づいた場合は、英語版を参照してください。

更新日 2026-06-19

## チュートリアル 2.0 ファイルから R 環境をインストールする

ここまでは Python を使ってきましたが、バイオインフォマティクスの多くの場面、とりわけ
発現差解析（differential expression analysis）では、最も優れたツールが
`R` というプログラミング言語で書かれています。RNA-seq の発現差解析における標準的なツールである
`DESeq2` と `edgeR` も `R` のパッケージです。そこでこのセッションでは言語を切り替え、
専用の `differential-expression` 環境を構築します。

各パッケージを手作業でインストールするのではなく、ファイルから環境全体をまとめて
インストールします。[チュートリアル 0](/0_Setting_up_your_workstation/README.md) では、
`conda install` コマンドを一つずつ実行して環境を作りました。ここではその代わりに、
環境の内容をファイルに記述し、`conda` に一括で構築させます。この方法はより再現性が高く、
同じファイルさえあれば誰でも同一の環境を再現できます。

### 2.0.1 環境ファイル

[`differential-expression.yml`](differential-expression.yml) をテキストエディタで開いて
中身を見てみましょう。次の項目が記載されています。
- 環境の `name`（名前）
- インストール元となる `channels`（パッケージリポジトリ）
- `dependencies` — 必要なすべてのパッケージ。目的ごとにコメント付きでまとめられています。

今の段階ですべてのパッケージを理解する必要はありません。順を追って取り上げていきます。

### 2.0.2 インストールスクリプトを理解する

環境を構築し、Jupyter に接続するための [`install.sh`](install.sh) スクリプトが用意されています。
Bash スクリプト（拡張子 `.sh`）は、ターミナルで使われる `bash` 言語[^1]で書かれています。
このスクリプトを含め、多くのスクリプトには使い方を説明する「ヘルプ」メッセージが付いています。

ターミナルで
```bash install.sh --help```
を実行すると、ヘルプメッセージが表示されます。

次に、`install.sh` スクリプトの中身を見てみましょう。お好みのテキストエディタで `install.sh`
を開いてください。`bash` は最も読みやすい言語とは言えませんが、スクリプトが行っていることの
おおまかな説明は次のとおりです。**下記のコードは実行しないでください**。あくまで説明用です。

1. _ファイルから環境を作成する_:  
   `# conda env create -f differential-expression.yml`  
   これは `.yml` ファイルを読み込み、そこに記載されたすべてを `differential-expression` という
   名前の新しい環境にインストールします。

2. _(Apple シリコンのみ) Intel 版パッケージを使う。_ 多くの Bioconductor パッケージには
   Apple シリコン用のネイティブビルドが存在しないため、代わりに Intel 版（`osx-64`）を
   インストールします。これはエミュレーション下でも問題なく動作します。`--apple-silicon`
   フラグを付けると、`CONDA_SUBDIR=osx-64` を指定して環境を構築し、以降のインストールでも
   `osx-64` が使われるように固定します。  
   `# conda run -n differential-expression conda config --env --set subdir osx-64`

3. _環境を Jupyter に接続する。_ これにより環境の R インタープリタが Jupyter のカーネルとして
   登録され、ノートブックを開いたときに選択できるようになります。  
   `# conda run -n differential-expression Rscript -e "IRkernel::installspec(name = 'differential-expression', displayname = 'differential-expression')"`

### 2.0.3 インストールスクリプトを実行する
`install.sh` スクリプトが何をしているか理解できたので、実際に実行してみましょう。
`2_Differential_gene_expression` ディレクトリで、次を実行します。
```
bash install.sh
```
Apple シリコン（M1/M2/M3/…）の Mac を使っている場合は、代わりに `--apple-silicon`
フラグを付けて実行してください。
```
bash install.sh --apple-silicon
```

スクリプトが完了したら、レッスン 2.1 に進みましょう。

## 2.1 発現差解析

この演習のためのノートと解説は、レッスンのノートブックに含まれています。次を実行し、
```
jupyter lab
```
[`2-1_differential-expression.ipynb`](2-1_differential-expression.ipynb) を開いて、
`differential-expression` カーネルを選択して始めましょう。

[^1]: Mac OS では `bash` の派生版である `zsh` が使われています。いくつかのコマンドは異なりますが、ほとんどは同じです。
