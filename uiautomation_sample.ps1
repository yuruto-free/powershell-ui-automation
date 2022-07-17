# ===================================================
# UIAutomationmation��p����PowerShell��GUI�𑀍삷��
# ===================================================
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

# GUI����̂��߂̏���
$uiAutomation = [System.Windows.Automation.AutomationElement]
$tree = [System.Windows.Automation.TreeScope]
$propertyCondition = [System.Windows.Automation.PropertyCondition]
$andCondition = [System.Windows.Automation.AndCondition]
$selectionItemPattern = [System.Windows.Automation.SelectionItemPattern]::Pattern
$togglePattern = [System.Windows.Automation.TogglePattern]::Pattern
$invokePattern = [Windows.Automation.InvokePattern]::Pattern
$root = $uiAutomation::RootElement

# ===========================================================================================
# �T���v���F�u�ݒ�v�̂����A�l�b�g���[�N�̏�Ԃ��J������A�v���L�V��I���A�v���L�V��ON�ɕύX
# ===========================================================================================
# Step1: �u�ݒ�v����l�b�g���[�N�̏�Ԃ��J��
Start-Process "ms-settings:network-status"

# Step2: �u�ݒ�v�̑��쌠�����擾
$app = $null
$namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "�ݒ�")
$classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "ApplicationFrameWindow")
$condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
do {
    Start-Sleep -m 200
    $app = $root.FindFirst($tree::Children, $condition)
} while ($null -eq $app)
Start-Sleep -m 300

# Step3: �u�ݒ�v��ListViewItem����u�v���L�V�v��T���o���A�I��
$namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "�v���L�V")
$classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "ListViewItem")
$condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
$proxyItem = $app.FindFirst($tree::Subtree, $condition)
$selectionItem = $proxyItem.GetCurrentPattern($selectionItemPattern)
$selectionItem.Select()
Start-Sleep -m 300

# Step4: �u�v���L�V �T�[�o�[���g���v�Ƃ��������ɂ���ON/OFF�g�O����T���o���AON/OFF��؂�ւ���
$namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "�v���L�V �T�[�o�[���g��")
$classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "ToggleSwitch")
$condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
$proxyStatusItem = $app.FindFirst($tree::Subtree, $condition)
$toggleSwitch = $proxyStatusItem.GetCurrentPattern($togglePattern)
$initState = $toggleSwitch.Current.ToggleState
Write-Host $initState # status�̕\��
$toggleSwitch.Toggle()
Start-Sleep -m 300

# Step5: ON/OFF�g�O���̐ݒ�ύX��ۑ�
if ($toggleSwitch.Current.ToggleState -eq "ON") {
    $namePropertyCondition = New-Object $propertyCondition($uiAutomation::NameProperty, "�ۑ�")
    $classNamePropertyCondition = New-Object $propertyCondition($uiAutomation::ClassNameProperty, "Button")
    $condition = New-Object $andCondition($namePropertyCondition, $classNamePropertyCondition)
    $saveButton = ($app.FindAll($tree::Subtree, $condition) | Where-Object {$_.Current.IsEnabled})
    $invokeButton = $saveButton.GetCurrentPattern($invokePattern)
    $invokeButton.Invoke()
    Start-Sleep -m 300
}

Write-Host $toggleSwitch.Current.ToggleState # status�̕\��
$toggleSwitch.Toggle()
Write-Host $toggleSwitch.Current.ToggleState # status�̕\��
Start-Sleep -m 300

# Step6: �g�O���X�C�b�`�̏�Ԃ����ɖ߂�
if ($toggleSwitch.Current.ToggleState -ne $initState) {
    $toggleSwitch.Toggle()
    Start-Sleep -m 300
}

# Step7: �u�ݒ�v�����
Stop-Process -Name "SystemSettings" -ErrorAction Ignore

