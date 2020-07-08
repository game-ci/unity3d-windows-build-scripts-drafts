# Stop PowerShell on first error
$ErrorActionPreference = "Stop"

Write-Host "$(date) Starting build script"-ForegroundColor green

Write-Host "Running as '$env:UserName' on domain '$env:UserDomain' on system '$env:ComputerName'"

Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "$(date) Getting unity instance"-ForegroundColor green

$username = $env:UNITY_USERNAME
$password = $env:UNITY_PASSWORD

Write-Host "$(date) Creating non-interactive credential object for password"-ForegroundColor green
$secure_password = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $secure_password)

$build_target = $env:BUILD_TARGET
$serial_env_key = $build_target.ToUpper() + "_UNITY_SERIAL"
$serial = (get-item env:$serial_env_key).Value
$secure_serial = ConvertTo-SecureString $serial -AsPlainText -Force

$build_name = $env:BUILD_NAME
$build_path = "./Builds/$build_target/"
$build_log = ".\build.log"

# Don't mind errors here (Get-YamlDocuments : Exception calling "Load" with "1" argument(s): "(Line: 1, Col: 1, Idx: 0) - (Line: 1, Col: 2, Idx:) is SAFE!!
$ErrorActionPreference = "Continue"

New-Item -Path $build_path -ItemType "directory"

Write-Host "$(date) Starting unity editor with method execution"-ForegroundColor green

$editor = $UNITY_EXECUTABLE

$process = New-Object System.Diagnostics.Process
            $process.StartInfo.Filename = $editor
            $process.StartInfo.Arguments = $unityArgs
            $process.StartInfo.RedirectStandardOutput = $true
            $process.StartInfo.RedirectStandardError = $true
            $process.StartInfo.UseShellExecute = $false
            $process.StartInfo.CreateNoWindow = $true
            $process.StartInfo.WorkingDirectory = $PWD
            $process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
            $process.Start() | Out-Null

## This uses https://github.com/Microsoft/unitysetup.powershell it worked out of gitlab-ci, but I was not able to get it to work when running from gitlab-runner
# Start-UnityEditor `
#   -Credential $credentials `
#   -Serial $secure_serial `
#   -BatchMode `
#   -Quit `
#   -LogFile $build_log `
#   -ExecuteMethod BuildCommand.PerformBuild `
#   -buildTarget $build_target `
#   -Wait `
#   -AdditionalArguments "-customBuildTarget $build_target -customBuildName $build_name -customBuildPath $build_path -customBuildOptions AcceptExternalModificationsToPlayer"

# Stop PowerShell on first error
$ErrorActionPreference = "Stop"

Write-Host "$(date) Reading build logs"-ForegroundColor green
Get-Content -Path $build_log

Write-Host "$(date) Done with unity build. Output log saved to $build_log"-ForegroundColor green
