---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

*Read this before posting and then delete this.*

Before posting, make sure that the issue is not a problem with your terminal emulator or other Vim environment.
If Gruvbox has highlight groups that are not being rendered correctly in one specific environment, the issue is with the environment.
However, if Gruvbox has highlight groups with rules that look wrong in every environment, the problem is with Gruvbox.
If you are not sure, try to use a different environment and/or check the relevant highlight group rules using the `:hi` command.

Additionally, if colors look wrong only after running `gruvbox_256palette.sh`, Gruvbox is likely at fault.

If you decide to post your issue here, please include the relevant information:
  - Your Vim version
  - The name and version of any terminal emulator(s) or graphical environment(s) where you recreated the issue
  - Whether you are running `gruvbox_256palette.sh`
  - Information on any other relevant external color configuration, such as a terminal emulator theme
  - A minimal .vimrc

A minimal .vimrc is narrowed down to just the lines that recreate the issue.
Remove all plugins and settings from your .vimrc and then add them back until you can recreate the issue.
Doing this makes it much, much more likely that someone else can solve your issue.
You may even come upon a solution to your issue by following this procedure.
