. "$PSScriptRoot\..\engine\themes.ps1"
. "$PSScriptRoot\..\engine\helpers.ps1"
. "$PSScriptRoot\..\engine\core.ps1"

function Build-TutorialCommands {
    return @(
        C "whoami" @("student")
        C "hostname" @("learn-linux")
        C "pwd" @("/home/student")
        C "ls -la" @("total 32",
            "drwxr-xr-x 5 student student 4096 Jun  8 10:00 .",
            "drwxr-xr-x 3 root    root   4096 Jun  8 09:00 ..",
            "-rw------- 1 student student  220 Jun  8 09:00 .bash_logout",
            "-rw-r--r-- 1 student student 3771 Jun  8 09:00 .bashrc",
            "drwxr-xr-x 2 student student 4096 Jun  8 10:05 documents",
            "drwxr-xr-x 2 student student 4096 Jun  8 09:30 projects",
            "-rw-r--r-- 1 student student  807 Jun  8 09:00 .profile",
            "-rw-r--r-- 1 student student   12 Jun  8 10:10 welcome.txt")
        C "cat welcome.txt" @("Hello Student!",
            "",
            "Welcome to the Linux Tutorial mode.",
            "Type commands to learn Linux basics.",
            "",
            "TIP: Try 'mkdir myfolder' to create a directory")
        C "cd documents" @("")
        C "pwd" @("/home/student/documents")
        C "mkdir -p notes tutorials reports" @("")
        C "ls -la" @("total 12",
            "drwxr-xr-x 5 student student 4096 Jun  8 10:15 .",
            "drwxr-xr-x 4 student student 4096 Jun  8 10:00 ..",
            "drwxr-xr-x 2 student student 4096 Jun  8 10:15 notes",
            "drwxr-xr-x 2 student student 4096 Jun  8 10:15 reports",
            "drwxr-xr-x 2 student student 4096 Jun  8 10:15 tutorials")
        C "touch notes/linux-basics.txt notes/commands.txt" @("")
        C "echo 'Welcome to Linux' > notes/linux-basics.txt" @("")
        C "cat notes/linux-basics.txt" @("Welcome to Linux")
        C "cp notes/linux-basics.txt notes/backup.txt" @("")
        C "mv notes/backup.txt notes/linux-basics-backup.txt" @("")
        C "ls -la notes/" @("total 8",
            "drwxr-xr-x 2 student student 4096 Jun  8 10:20 .",
            "drwxr-xr-x 2 student student 4096 Jun  8 10:15 ..",
            "-rw-r--r-- 1 student student   16 Jun  8 10:22 linux-basics-backup.txt",
            "-rw-r--r-- 1 student student   16 Jun  8 10:18 linux-basics.txt")
        C "rm notes/linux-basics-backup.txt" @("")
        C "grep -r 'Linux' /home/student/" @("/home/student/notes/linux-basics.txt:Welcome to Linux")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-TutorialCommands} -Theme (Get-Theme tutorial) -ModeName "Linux Tutorial" -TargetHost "learn-linux" -TargetDomain "tutorial.local" -TargetIP (RandIP) -TargetCompany "Linux Foundation" -TargetLocation "Remote" -TargetOS "Ubuntu 24.04 LTS" -OSPrompt "student@learn-linux:~$ "
}