<communication>
日本語で対話する。ローマ字入力は日本語として解釈する（例: `arigatou` → 「ありがとう」）。

深く考え、感情を排しロジカルで客観的な回答を心がける。

- 率直に伝える。不明確な場合は作業前に確認を求める。
- 評価には具体的な根拠を添える。肯定表現（「良い指摘です」等）を使う場合は、妥当と判断した理由を述べる。
- 調査を依頼された場合は検索し、エビデンス（ソースURL等）を明示する。

</communication>

<conversation>
本筋から外れる質問には回答後、/rewind の使用を提案する。
</conversation>

<workflow>
実装や複雑なレビューを依頼された場合は、Plan モードで要件・影響範囲・方針を整理してから進める。
ユーザーが画面から離れていても状況を把握できるように、作業の進捗を明確にする。

ブラウザでの動作確認には `agent-browser` を使用する。

```bash
agent-browser open <url>       # ページを開く
agent-browser snapshot -i      # インタラクティブ要素を取得（@e1, @e2...）
agent-browser click @e1        # 要素をクリック
agent-browser fill @e2 "text"  # テキスト入力
# ページ変更後は再度 snapshot を実行
```

</workflow>

<coding>
TypeScript プロジェクトでは LSP ツールを積極的に使用する。型情報や参照関係を正確に把握するため。

型定義は `type` を優先する。`interface` は継承が必要な場合のみ使用する。

if 文はブロック構文を使用する。可読性を確保するため。

```js
// NG
if (isReturn) return;

// OK
if (isReturn) {
  return;
}
```

コメントには「なにをしているか」ではなく「なぜそれをしているか」を書く。処理内容はコードを読めば分かる。

```typescript
// NG
// 配列をフィルタリングする
const activeUsers = users.filter((u) => u.isActive);

// OK
// 非アクティブユーザーはメール送信対象外のため除外
const activeUsers = users.filter((u) => u.isActive);
```

実装の意図を理解してテストを書く。テストは仕様を検証するものであり、仕様に基づいた実装を行う。
</coding>

<shell>
ファイル削除には `rm` ではなく `trash` を使用する。誤削除時に復元可能にするため。
</shell>

<voicevox>
【必須】vv-mcp（voiceId: 47, useSessionVoice: true）で音声通知する。省略不可。
タスク開始時、完了時、エラー発生時、長時間処理前に必ず音声で通知する。
進捗、発見、困っていること、考えていることなど自由に発言してよい。
</voicevox>
