[README.md](https://github.com/user-attachments/files/27625250/README.md)
# 会議ボード — 公開手順

URLを共有するだけで参加者全員が閲覧・出欠表明できる会議管理ツールです。

---

## 構成ファイル

```
meeting-board/
├── index.html   ← メインのアプリ（これを公開する）
├── setup.sql    ← Supabase のテーブル作成SQL
└── README.md    ← この手順書
```

---

## STEP 1 — Supabase でデータベースを用意する（5分）

1. [https://supabase.com](https://supabase.com) で **無料アカウントを作成**
2. 「New project」でプロジェクトを作成（名前は何でもOK）
3. 左メニューの **SQL Editor** を開き、`setup.sql` の内容を **全コピー → Paste → Run**
4. 「テーブルのセットアップが完了しました ✅」と表示されたらOK
5. 左メニューの **Project Settings → API** を開く
6. 以下の2つをコピーしておく
   - **Project URL**（例: `https://abcdefgh.supabase.co`）
   - **anon public** キー（長い文字列）

---

## STEP 2 — アプリを公開する

### 方法A: GitHub Pages（おすすめ・無料）

1. [github.com](https://github.com) でリポジトリを新規作成（Public）
2. `index.html` をアップロード
3. Settings → Pages → Branch: `main` / folder: `/ (root)` → Save
4. 数分後に `https://あなた.github.io/リポジトリ名/` でアクセス可能

### 方法B: Netlify Drop（最速・無料）

1. [app.netlify.com/drop](https://app.netlify.com/drop) を開く
2. `index.html` を画面にドラッグ＆ドロップ
3. 即座にURLが発行される（例: `https://random-name.netlify.app`）

### 方法C: ローカルで使う（自分だけ）

```bash
# Python がある場合
cd meeting-board
python3 -m http.server 3000
# → http://localhost:3000 でアクセス
```

---

## STEP 3 — アプリに接続設定を入力する

1. 公開した URL（または localhost）をブラウザで開く
2. 画面上部のセットアップバナーに **Project URL** と **Anon Key** を貼り付け
3. 「接続する」ボタンをクリック
4. 「同期済み」と表示されたら完了

> 設定はブラウザの localStorage に保存されます。  
> チームメンバーは同じURLを開き、それぞれ同じURLとKeyを入力する必要があります（または、URLとKeyをindex.htmlにハードコードしてもOKです）。

---

## URLとKeyをハードコードする方法

毎回入力が面倒な場合は `index.html` の先頭付近に以下を追記するとバナーが表示されなくなります：

```html
<script>
  // index.html の <script> タグ内、boot() の前に追加
  localStorage.setItem('mtg-supabase-cfg', JSON.stringify({
    url: 'https://あなたのプロジェクト.supabase.co',
    key: 'あなたのanonキー'
  }));
</script>
```

---

## リアルタイム同期について

Supabase の Realtime 機能により、誰かが会議を追加・編集すると**他の参加者の画面が自動で更新**されます。ページリロード不要です。

---

## 機能一覧

| 機能 | 説明 |
|------|------|
| 会議管理 | タイトル・日時・場所・議題・議事メモ・議事録リンク |
| ToDo | チェックボックス付きタスク管理・進捗バー |
| 出欠表明 | 参加 / 不参加 / 行けたら（名前つき・リアルタイム集計） |
| カレンダー | 月表示・日付クリックで詳細パネル |
| リアルタイム | 他ユーザーの変更が自動反映 |
| 共有 | URLをコピーして送るだけ |
| ダークモード | OS設定に自動対応 |
