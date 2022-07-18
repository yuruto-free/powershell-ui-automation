# ===================================================
# UIAutomationmationを用いてPowerShellでGUIを操作する
# ===================================================
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

# GUI操作のための準備
$uiAutomation = [System.Windows.Automation.AutomationElement]
$tree = [System.Windows.Automation.TreeScope]
$root = $uiAutomation::RootElement
# Pattern一覧
$automationPatterns = [ordered]@{
    DockPattern = [System.Windows.Automation.DockPattern]::Pattern
    ExpandCollapsePattern = [System.Windows.Automation.ExpandCollapsePattern]::Pattern
    GridPattern = [System.Windows.Automation.GridPattern]::Pattern
    GridItemPattern = [System.Windows.Automation.GridItemPattern]::Pattern
    InvokePattern = [System.Windows.Automation.InvokePattern]::Pattern
    MultipleViewPattern = [System.Windows.Automation.MultipleViewPattern]::Pattern
    RangeValuePattern = [System.Windows.Automation.RangeValuePattern]::Pattern
    ScrollPattern = [System.Windows.Automation.ScrollPattern]::Pattern
    ScrollItemPattern = [System.Windows.Automation.ScrollItemPattern]::Pattern
    SelectionPattern = [System.Windows.Automation.SelectionPattern]::Pattern
    SelectionItemPattern = [System.Windows.Automation.SelectionItemPattern]::Pattern
    TablePattern = [System.Windows.Automation.TablePattern]::Pattern
    TableItemPattern = [System.Windows.Automation.TableItemPattern]::Pattern
    TextPattern = [System.Windows.Automation.TextPattern]::Pattern
    TogglePattern = [System.Windows.Automation.TogglePattern]::Pattern
    TransformPattern = [System.Windows.Automation.TransformPattern]::Pattern
    ValuePattern = [System.Windows.Automation.ValuePattern]::Pattern
    WindowPattern = [System.Windows.Automation.WindowPattern]::Pattern
}

# 検索条件生成
function createCondition([hashtable]$params) {
    [System.Collections.ArrayList]$conditions = @()
    $propertyCondition = [System.Windows.Automation.PropertyCondition]
    $andCondition = [System.Windows.Automation.AndCondition]
    $trueCondition = [System.Windows.Automation.Condition]::TrueCondition

    $params.GetEnumerator() | ForEach-Object {
        $key = $_.Key
        $value = $_.Value

        if ($value) {
            switch -Exact ($key) {
                "AcceleratorKey" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::AcceleratorKeyProperty, $value)
                }
                "AccessKey" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::AccessKeyProperty, $value)
                }
                "AutomationId" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::AutomationIdProperty, $value)
                }
                "BoundingRectangle" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::BoundingRectangleProperty, $value)
                }
                "ClassName" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, $value)
                }
                "ClickablePoint" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::ClickablePointProperty, $value)
                }
                "ControlType" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::ControlTypeProperty, $value)
                }
                "Culture" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::CultureProperty, $value)
                }
                "FrameworkId" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::FrameworkIdProperty, $value)
                }
                "HasKeyboardFocus" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::HasKeyboardFocusProperty, $value)
                }
                "HelpText" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::HelpTextProperty, $value)
                }
                "IsContentElement" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::IsContentElementProperty, $value)
                }
                "IsControlElement" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::IsControlElementProperty, $value)
                }
                "IsEnabled" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::IsEnabledProperty, $value)
                }
                "IsKeyboardFocusable" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::IsKeyboardFocusableProperty, $value)
                }
                "IsOffscreen" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::IsOffscreenProperty, $value)
                }
                "IsPassword" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::IsPasswordProperty, $value)
                }
                "IsRequiredForForm" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::IsRequiredForFormProperty, $value)
                }
                "ItemStatus" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::ItemStatusProperty, $value)
                }
                "ItemType" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::ItemTypeProperty, $value)
                }
                "LabeledBy" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::LabeledByProperty, $value)
                }
                "LocalizedControlType" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::LocalizedControlTypeProperty, $value)
                }
                "Name" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::NameProperty, $value)
                }
                "NativeWindowHandle" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::NativeWindowHandleProperty, $value)
                }
                "Orientation" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::OrientationProperty, $value)
                }
                "PositionInSet" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::PositionInSetProperty, $value)
                }
                "ProcessId" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::ProcessIdProperty, $value)
                }
                "RuntimeId" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::RuntimeIdProperty, $value)
                }
                "SizeOfSet" {
                    $currentCondition = New-Object $propertyCondition($uiAutomation::SizeOfSetProperty, $value)
                }
                default {
                    $currentCondition = $null
                }
            }

            if ($currentCondition) {
                [Void]$conditions.Add($currentCondition)
            }
        }
    }

    if ($conditions.Count -ge 2) {
        $condition = New-Object $andCondition($conditions)
    }
    elseif ($conditions.Count -eq 1) {
        $condition = $conditions[0]
    }
    else {
        $condition = $trueCondition
    }

    return $condition
}
# 操作対象アプリケーションの探索
function searchApps([hashtable]$params) {
    Start-Sleep -m 500
    $condition = createCondition $params
    $apps = $root.FindAll($tree::Children, $condition)

    return $apps
}
# 操作対象アプリケーションの取得
function getApp([hashtable]$params) {
    $condition = createCondition $params
    $app = $null

    do {
        Start-Sleep -m 200
        $app = $root.FindFirst($tree::Children, $condition)
    } while ($null -eq $app)

    return $app
}
# アプリケーション内要素の検索
function searchAllElements([System.Windows.Automation.AutomationElement]$app, [hashtable]$params) {
    $condition = createCondition $params
    $elements = $app.FindAll($tree::Subtree, $condition)

    return $elements
}
# アプリケーション内要素の取得
function getElement([System.Windows.Automation.AutomationElement]$app, [hashtable]$params) {
    $condition = createCondition $params
    $element = $app.FindFirst($tree::Subtree, $condition)

    return $element
}
# 実行可能な処理パターンの確認
function checkActionPattern([System.Windows.Automation.AutomationElement]$element) {
    [System.Collections.ArrayList]$patterns = @()

    $automationPatterns.GetEnumerator() | ForEach-Object {
        $key = $_.Key
        $value = $_.Value

        try {
            [Void]$element.GetCurrentPattern($value)
            [Void]$patterns.Add($key)
        }
        catch {}
    }

    return $patterns
}

# ============
# main routine
# ============
Start-Process "calc"
$params = @{
    Name = "電卓"
}
$app = getApp $params

# check action pattern
searchAllElements $app @{} | ForEach-Object {
    $array = checkActionPattern $_

    if ($array.Count -gt 0) {
        $current = $_.Current
        Write-Host ("Name: {0}, ClassName: {1}, AutomationId: {2}" -f $current.Name, $current.ClassName, $current.AutomationId)
        Write-Host ("    {0}" -f ($array -join ", "))
    }
}

# execute action
$params = @{
    Name = "電卓 を閉じる"
    AutomationId = "Close"
}
$element = getElement $app $params
$button = $element.GetCurrentPattern($automationPatterns.InvokePattern)
$button.Invoke()

