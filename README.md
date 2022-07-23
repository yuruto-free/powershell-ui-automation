# powershell-ui-automation
PowerShellによるGUI操作のサンプルスクリプト

## automation_sample.ps1
### 処理内容
以下の順に処理が実行されます。

1. 「設定→ネットワークとインターネット→状態」により「ネットワークの状態」が表示される。
1. 左側のリストにある「プロキシ」が選択される。
1. 「プロキシ サーバーを使う」のトグルスイッチが切り替わる。

    ONの場合はOFFに、OFFの場合はONになる。

1. トグルスイッチがONの場合、「保存」ボタンを押下する。
1. トグルスイッチを再度切り替えた後、2.のトグルスイッチの状態に戻す。
1. 「設定」画面を閉じる。

### 使い方
wrapper_sample.batをダブルクリックして実行してください。

## uiautomation_calculator_sample.ps1
### 処理内容
以下の順に処理が実行されます。

1. 電卓アプリを起動（関数電卓モード前提）
1. 電卓アプリを構成する要素一覧を出力
1. PowerShellから電卓アプリを操作し、「1+2+3+4+5+6+7+8+9」を計算する。
1. 電卓アプリを終了する。

### 電卓アプリを構成する要素一覧
関数電卓モードにおける構成要素は、以下のようになっていました。

| 名称 | クラス名 | AutomationId | 実行可能なパターン |
| :---- | :---- | :---- | :---- |
| 電卓 | ApplicationFrameWindow | - | TransformPattern, WindowPattern |
| 電卓 | ApplicationFrameTitleBarWindow | TitleBar | ValuePattern |
| システム | - | - | ExpandCollapsePattern |
| 電卓 の最小化 | - | Minimize | InvokePattern |
| 電卓 を最大化する | - | Maximize | InvokePattern |
| 電卓 を閉じる | - | Close | InvokePattern |
| 電卓 | TextBlock | AppName | ScrollItemPattern, TextPattern |
| - | LandmarkTarget | - | ScrollItemPattern |
| 式は  です | - | CalculatorExpression | ScrollItemPattern |
| 表示は 0 です | - | CalculatorResults | InvokePattern, ScrollItemPattern |
| 履歴のポップアップを開く | Button | HistoryButton | InvokePattern, ScrollItemPattern |
| 角度演算子 | NamedContainerAutomationPeer | ScientificAngleOperators | ScrollItemPattern |
| 角度切り替え | Button | degButton | InvokePattern, ScrollItemPattern |
| 指数表記 | ToggleButton | ftoeButton | ScrollItemPattern, TogglePattern |
| メモリ コントロール | NamedContainerAutomationPeer | MemoryPanel | ScrollItemPattern |
| すべてのメモリをクリア | Button | ClearMemoryButton | InvokePattern, ScrollItemPattern |
| メモリ呼び出し | Button | MemRecall | InvokePattern, ScrollItemPattern |
| メモリ加算 | Button | MemPlus | InvokePattern, ScrollItemPattern |
| メモリ減算 | Button | MemMinus | InvokePattern, ScrollItemPattern |
| メモリ保存 | Button | memButton | InvokePattern, ScrollItemPattern |
| メモリのポップアップを開く | Button | MemoryButton | InvokePattern, ScrollItemPattern |
| 指数演算子パネル | ListView | - | ScrollPattern, ScrollItemPattern |
| 三角関数 | ListViewItem | - | ScrollItemPattern |
| 三角関数 | ToggleButton | trigButton | ScrollItemPattern, TogglePattern |
| 三角関数 | TextBlock | - | ScrollItemPattern, TextPattern |
| 関数 | ListViewItem | - | ScrollItemPattern |
| 関数 | ToggleButton | funcButton | ScrollItemPattern, TogglePattern |
| 関数 | TextBlock | - | ScrollItemPattern, TextPattern |
| 逆関数 | ToggleButton | shiftButton | ScrollItemPattern, TogglePattern |
| パイ | Button | piButton | InvokePattern, ScrollItemPattern |
| オイラー数 | Button | eulerButton | InvokePattern, ScrollItemPattern |
| ディスプレイ コントロール | NamedContainerAutomationPeer | DisplayControls | ScrollItemPattern |
| クリア | Button | clearButton | InvokePattern, ScrollItemPattern |
| バックスペース | Button | backSpaceButton | InvokePattern, ScrollItemPattern |
| 科学関数 | NamedContainerAutomationPeer | - | ScrollItemPattern |
| 2 乗 | Button | xpower2Button | InvokePattern, ScrollItemPattern |
| 平方根算出 | Button | squareRootButton | InvokePattern, ScrollItemPattern |
| "X" を指数に | Button | powerButton | InvokePattern, ScrollItemPattern |
| 10 を指数に | Button | powerOf10Button | InvokePattern, ScrollItemPattern |
| ログ | Button | logBase10Button | InvokePattern, ScrollItemPattern |
| 自然対数 | Button | logBaseEButton | InvokePattern, ScrollItemPattern |
| 逆数 | Button | invertButton | InvokePattern, ScrollItemPattern |
| 絶対値 | Button | absButton | InvokePattern, ScrollItemPattern |
| 指数近似曲線 | Button | expButton | InvokePattern, ScrollItemPattern |
| 剰余 | Button | modButton | InvokePattern, ScrollItemPattern |
| 始め丸かっこ | Button | openParenthesisButton | InvokePattern, ScrollItemPattern |
| 終わり丸かっこ | Button | closeParenthesisButton | InvokePattern, ScrollItemPattern |
| 階乗 | Button | factorialButton | InvokePattern, ScrollItemPattern |
| 標準演算子 | NamedContainerAutomationPeer | StandardOperators | ScrollItemPattern |
| 除算 | Button | divideButton | InvokePattern, ScrollItemPattern |
| 乗算 | Button | multiplyButton | InvokePattern, ScrollItemPattern |
| マイナス | Button | minusButton | InvokePattern, ScrollItemPattern |
| プラス | Button | plusButton | InvokePattern, ScrollItemPattern |
| 等号 | Button | equalButton | InvokePattern, ScrollItemPattern |
| 正 負 | Button | negateButton | InvokePattern, ScrollItemPattern |
| 数字パッド | NamedContainerAutomationPeer | NumberPad | ScrollItemPattern |
| 0 | Button | num0Button | InvokePattern, ScrollItemPattern |
| 1 | Button | num1Button | InvokePattern, ScrollItemPattern |
| 2 | Button | num2Button | InvokePattern, ScrollItemPattern |
| 3 | Button | num3Button | InvokePattern, ScrollItemPattern |
| 4 | Button | num4Button | InvokePattern, ScrollItemPattern |
| 5 | Button | num5Button | InvokePattern, ScrollItemPattern |
| 6 | Button | num6Button | InvokePattern, ScrollItemPattern |
| 7 | Button | num7Button | InvokePattern, ScrollItemPattern |
| 8 | Button | num8Button | InvokePattern, ScrollItemPattern |
| 9 | Button | num9Button | InvokePattern, ScrollItemPattern |
| 小数点 | Button | decimalSeparatorButton | InvokePattern, ScrollItemPattern |
| 関数電卓 電卓モード | TextBlock | Header | ScrollItemPattern, TextPattern |
| - | - | NavView | ScrollItemPattern, SelectionPattern |
| ナビゲーションを開く | Button | TogglePaneButton | InvokePattern, ScrollItemPattern |
| - | TextBlock | PaneTitleTextBlock | ScrollItemPattern, TextPattern |

### 使い方
wrapper_calculator.batをダブルクリックして実行してください。

