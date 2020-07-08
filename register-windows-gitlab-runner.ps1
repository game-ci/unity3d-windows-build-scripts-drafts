cd 'C:\gitlab\'

$gitlab_user='your_username'
$gitlab_password='your_password'
$gitlab_registration_token='your_token'

.\gitlab-runner.exe stop
.\gitlab-runner.exe unregister --all-runners

.\gitlab-runner.exe uninstall
# Notice the freakin '.\' for local domain

.\gitlab-runner.exe register `
  --non-interactive `
  --url="https://gitlab.com/" `
  --registration-token=$gitlab_registration_token `
  --executor="shell" `
  --description="unity-build-machine-bash" `
  --tag-list="unity,unity2018.4.11f1,windows,bash" `
  --run-untagged="false" `
  --locked="false" `
  --access-level="not_protected" `
  --shell="bash" `
  --builds-dir="/c/gitlab/builds/bash"

.\gitlab-runner.exe register `
  --non-interactive `
  --url="https://gitlab.com/" `
  --registration-token=$gitlab_registration_token `
  --executor="shell" `
  --description="unity-build-machine-powershell" `
  --tag-list="unity,unity2018.4.11f1,windows,powershell" `
  --run-untagged="false" `
  --locked="false" `
  --access-level="not_protected" `
  --shell="powershell" `
  --builds-dir="/c/gitlab/builds/powershell"

.\gitlab-runner.exe install --user ".\$gitlab_user" --password $gitlab_password
.\gitlab-runner.exe start
