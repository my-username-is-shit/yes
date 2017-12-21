Function Generate-Form{
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "Simple shit file browser"
    $form.Size = New-Object System.Drawing.Size(1280,720) 
    $form.StartPosition = "CenterScreen"

    $TextBox = New-Object System.Windows.Forms.TextBox
    $TextBox.Location = New-Object System.Drawing.Size(10,5)
    $TextBox.Size = New-Object System.Drawing.Size(1180,20)
    $TextBox.Text = (Get-Item -Path ".\" -Verbose).FullName
    $form.Controls.Add($TextBox)

    $ListView = New-Object System.Windows.Forms.ListView
    $ListView.Location = New-Object System.Drawing.Size(10,30)
    $ListView.Size = New-Object System.Drawing.Size(1240,620)
    $form.Controls.Add($ListView)

    $buttonGo = New-Object System.Windows.Forms.Button
    $buttonGo.Location = New-Object System.Drawing.Size(1195,5)
    $buttonGo.Size = New-Object System.Drawing.Size(60,20)
    $buttonGo.Text = "Go"
    $form.Controls.Add($buttonGo)

    $buttonRename = New-Object System.Windows.Forms.Button
    $buttonRename.Location = New-Object System.Drawing.Size(10,655)
    $buttonRename.Size = New-Object System.Drawing.Size(60,20)
    $buttonRename.Text = "Rename"
    $form.Controls.Add($buttonRename)

    $buttonRemove = New-Object System.Windows.Forms.Button
    $buttonRemove.Location = New-Object System.Drawing.Size(75,655)
    $buttonRemove.Size = New-Object System.Drawing.Size(60,20)
    $buttonRemove.Text = "Remove"
    $form.Controls.Add($buttonRemove)

    $form.Topmost = $True

    $form.Add_Load({FillListView $TextBox.Text})

    function FillListView{
        param([string] $Path)
        $ListView.Clear()
        $Items = Get-ChildItem -Path $Path
        foreach($Item in $Items)
        {
            $ListView.Items.Add($Item.Name)
        }

    }

    $buttonGo.Add_Click(
    {
        Set-Location -Path $TextBox.Text
        $TextBox.Text = (Get-Item -Path ".\" -Verbose).FullName
        FillListView $TextBox.Text
    })

    $buttonRename.Add_Click(
    {
        $temp = (Get-Item -Path ".\" -Verbose).FullName.ToString()+"\"+$ListView.SelectedItems[0].Text.ToString()
        Rename-Item $temp $TextBox.Text
        Set-Location -Path (Get-Item -Path ".\" -Verbose).FullName
        $TextBox.Text = (Get-Item -Path ".\" -Verbose).FullName
        FillListView $TextBox.Text
    })

    $buttonRemove.Add_Click(
    {
        $temp = (Get-Item -Path ".\" -Verbose).FullName.ToString()+"\"+$ListView.SelectedItems[0].Text.ToString()
        Remove-Item -Path $temp -Recurse
        Set-Location -Path $TextBox.Text
        $TextBox.Text = (Get-Item -Path ".\" -Verbose).FullName
        FillListView $TextBox.Text
    })

    $result = $form.ShowDialog()
}
Generate-Form