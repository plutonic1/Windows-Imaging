# Windows-Imaging
my customized Windows 10

Instructions:

1. Install the Windows ADK and use `copype` to create a WinPE environment:
https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive

2. Copy all .bat files into the WinPE directory.

3. Look at all scripts and change the paths to match your environment.

4. Start cmd.bat as admin. In the cmd, start .\mount.bat to mount the WinPE boot image. Now you can e.g. edit .\mount\Windows\System32\startnet.cmd to launch your custom scripts. In this example, add the line `start powershell Powershell.exe -noexit -executionpolicy remotesigned -File X:\start.ps1` to startnet.cmd and place start.ps1 in .\mount.

5. Edit german.bat to match your keyboard layout and execute it from the elevated cmd.

6. Run .\unmount.bat to unmount the image from the elevated cmd and use .\makeiso.bat to create a bootable .iso.

7. Boot that iso on a machine that has an already installed Windows 10 on it. Use `Dism /Capture-Image` or `imagex /capture` to copy the Windows to a .wim file.

8. Boot the machine on which you want to install your custom Windows 10 and use diskpart to create a partition layout. I have included the layout that I use in uefi.txt which you can apply with `diskpart /s D:\uefi.txt` (your path may be different). Then use `dism /Apply-Image` or `imagex /apply` to copy the .wim file to the machine.


Hints:

You can use the start.ps1 to automate the steps 7 and 8. Additionally you could e.g. ask for the new pc name and a user name in start.ps1 and automatically rename the new pc accordingly and create a new user. 
