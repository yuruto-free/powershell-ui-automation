# ===================================================
# UIAutomationmationを用いてPowerShellでGUIを操作する
# ===================================================
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

# GUI操作のための準備
$uiAutomation = [System.Windows.Automation.AutomationElement]
$tree = [System.Windows.Automation.TreeScope]
$propertyCondition = [System.Windows.Automation.PropertyCondition]
$andCondition = [System.Windows.Automation.AndCondition]
$selectionItemPattern = [System.Windows.Automation.SelectionItemPattern]::Pattern
$togglePattern = [System.Windows.Automation.TogglePattern]::Pattern
$invokePattern = [Windows.Automation.InvokePattern]::Pattern
$root = $uiAutomation::RootElement

# ===========================================================================================
# サンプル：「設定」のうち、ネットワークの状態を開いた後、プロキシを選択、プロキシをONに変更
# ===========================================================================================
# Step1: 「設定」からネットワークの状態を開く
Start-Process "ms-settings:network-status"

# Step2: 「設定」の操作権限を取得
$app = $null
$namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "設定")
$classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "ApplicationFrameWindow")
$condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
do {
    Start-Sleep -m 200
    $app = $root.FindFirst($tree::Children, $condition)
} while ($null -eq $app)
Start-Sleep -m 300

# Step3: 「設定」のListViewItemから「プロキシ」を探し出し、選択
$namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "プロキシ")
$classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "ListViewItem")
$condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
$proxyItem = $app.FindFirst($tree::Subtree, $condition)
$selectionItem = $proxyItem.GetCurrentPattern($selectionItemPattern)
$selectionItem.Select()
Start-Sleep -m 300

# Step4: 「プロキシ サーバーを使う」という部分にあるON/OFFトグルを探し出し、ON/OFFを切り替える
$namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "プロキシ サーバーを使う")
$classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "ToggleSwitch")
$condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
$proxyStatusItem = $app.FindFirst($tree::Subtree, $condition)
$toggleSwitch = $proxyStatusItem.GetCurrentPattern($togglePattern)
$initState = $toggleSwitch.Current.ToggleState
Write-Host $initState # statusの表示
$toggleSwitch.Toggle()
Start-Sleep -m 300

# Step5: ON/OFFトグルの設定変更を保存
if ($toggleSwitch.Current.ToggleState -eq "ON") {
    $namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "保存")
    $classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "Button")
    $condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
    $saveButton = ($app.FindAll($tree::Subtree, $condition) | Where-Object {$_.Current.IsEnabled})
    $invokeButton = $saveButton.GetCurrentPattern($invokePattern)
    $invokeButton.Invoke()
    Start-Sleep -m 300
}

Write-Host $toggleSwitch.Current.ToggleState # statusの表示
$toggleSwitch.Toggle()
Write-Host $toggleSwitch.Current.ToggleState # statusの表示
Start-Sleep -m 300

# Step6: トグルスイッチの状態を元に戻す
if ($toggleSwitch.Current.ToggleState -ne $initState) {
    $toggleSwitch.Toggle()
    Start-Sleep -m 300
}

# Step7: 「設定」を閉じる
Stop-Process -Name "SystemSettings" -ErrorAction Ignore

