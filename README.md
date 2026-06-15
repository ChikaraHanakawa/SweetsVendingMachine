# SweetsVendingMachine-研究室菓子自販機システム

PaSoRi（Sony RC-S380）で学生証（FeliCa）を読み取って利用者を認証し，研究室の菓子を
払い出す自動販売機システムです．利用は一人一日一個に制限し，払い出しやレーン選択に
あわせてずんだもんの音声・効果音を再生します．あわせて 21:30 に退室を促すチャイムを鳴らします．

C++ と Python を pybind11 で連携し，NFC カード読み取りは Python（nfcpy），
音声再生は SFML，利用者情報は Notion API による管理を予定しています．

## 想定する動作（自販機としての最終形）

1. NFC リーダーに学生証をかざす
2. FeliCa から学籍番号を読み取る
3. Notion 上の学生データベースと照合し，登録メンバーか，当日まだ利用していないかを判定する
4. GUI（Avalonia）でレーン（商品）を選択する
5. Arduino 経由でモータを制御し，選択されたレーンから商品を 1 個払い出す
6. 払い出しにあわせて効果音を再生し，利用記録を更新する（毎日 0 時にリセット）
7. 21:30 に退室を促すチャイムを再生する

## 実装状況

本リポジトリは開発途中であり，現時点では以下の範囲が実装されています．

- 実装済み: 学生証の読み取り（`nfc_reader.py` + pybind11 ブリッジ），読み取った学籍番号に
  応じた音声フィードバック（登録／未登録／エラー），現在時刻の取得（`leaving_time`）
- 未実装（実装予定）: Notion API 連携によるメンバー照合，当日利用の制限と利用記録，
  GUI（Avalonia）でのレーン選択，Arduino によるモータ制御・払い出し，21:30 チャイムの発火，
  払い出し時の効果音

> **注意:** 利用者情報を管理していた `database/db.h` は Notion 管理へ移行するため削除済みです．
> Notion 連携が未実装のため，現状では認証・照合は動作しません（後述「メンバー登録」を参照）．

## 依存関係

### システムパッケージ

```bash
# Ubuntu / Debian
sudo apt install cmake libsfml-dev
```

> NFC 読み取りは Python の nfcpy で行うため，`libnfc-dev` は不要です（nfcpy は uv 管理の
> Python 依存として導入されます）．

### Python パッケージ

`uv` で管理しています．未インストールの場合は導入してください．

```bash
pip install uv
```

依存パッケージはリポジトリルートで `uv sync` を実行すると，`pyproject.toml` / `uv.lock` に
従って仮想環境（`.venv`）に一括導入されます（後述のビルド手順を参照）．

## USBデバイスの権限設定（Linux）

一般ユーザーが PaSoRi（RC-S380）にアクセスできるよう，udev ルールを設定します．

```bash
# udev ルール作成（RC-S380: idVendor=054c, idProduct=06c1）
echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="06c1", MODE="0666", GROUP="plugdev"' \
    | sudo tee /etc/udev/rules.d/99-pasori.rules

# ルール反映
sudo udevadm control --reload-rules
sudo udevadm trigger

# ユーザーを plugdev グループに追加
sudo usermod -aG plugdev $USER

# グループ確認（plugdev が含まれていれば OK）
groups
```

> グループ変更を反映するには一度ログアウト・ログインが必要です．

### 動作確認

```bash
python3 -c "import nfc; nfc.ContactlessFrontend('usb')"
```

エラーが出なければ認識されています．

## ビルド

```bash
# リポジトリのルートで実行
uv sync                                            # Python 仮想環境と依存パッケージを準備

mkdir build && cd build
cmake -DPython_EXECUTABLE=../.venv/bin/python ..   # CMake 設定
make                                               # ビルド
```

ビルドに成功すると `build/entry_system` が生成されます．

## 実行

wav ファイルのパスが相対パスのため，**プロジェクトルートからの実行を推奨**します．

```bash
# プロジェクトルートから実行（推奨）
./build/entry_system
```

```bash
# build ディレクトリから実行する場合
cd build
./entry_system
```

カードをかざすと学籍番号が読み取られ，登録／未登録に応じた音声が再生されます
（払い出し等は実装後に動作します）．
終了するには `Ctrl+C` を押してください．

## 音量調整
alsamixer -c 1
↑で音量を上げる．Mでミュート解除．

## メンバー登録

メンバー情報（氏名・学籍番号）は **Notion のデータベースで管理**する方針です．
システムが Notion API を介して情報を取得し，学生証から読み取った学籍番号と照合します．
メンバーの追加・削除は Notion 上のデータベースを編集するだけで済み，ソースコードの変更は不要です．

> **注意:** Notion API 連携は現在未実装です（実装予定）．
> 以前はメンバー定義を `database/db.h` に直接記述していましたが，Notion 管理へ移行するため
> 同ファイルは削除しました．連携が実装されるまでの間，認証・照合は動作しません．

連携実装後は，本セクションに Notion データベースの準備手順（データベースの作成，
API トークン・データベース ID の設定方法など）を追記します．

## ディレクトリ構成

```
.
├── CMakeLists.txt        # ビルド設定
├── pyproject.toml        # Python パッケージ管理（uv）
├── uv.lock               # 依存パッケージのロックファイル
├── LICENSE
├── README.md
├── include/              # ヘッダ（宣言・変数・STL等の定義）
│   ├── common.h          # 共通定義（STL 等）
│   ├── aplay.h           # 音声再生の宣言
│   ├── nfc_bridge.h      # Python 呼び出し（pybind11）の宣言
│   └── leaving_time.h    # 退室促進（時刻取得・21:30判定用）の宣言
├── src/                  # 実装（C++ / Python）
│   ├── main.cpp          # エントリポイント
│   ├── aplay.cpp         # 音声再生（SFML）
│   ├── nfc_bridge.cpp    # FeliCa 読み取りの C++ 側ブリッジ（pybind11）
│   ├── nfc_reader.py     # FeliCa 読み取り（Python / nfcpy）
│   └── leaving_time.cpp  # 退室促進（現在時刻の取得）の実装
└── database/
    └── wav/              # 音声ファイル（.wav）
        └── good_children.wav
```
