# A calendar application for Vim
### Vim meets a next generation application

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image.png)

Press E key to view the event list, and T key to view the task list.
Also, press ? key to view a quick help.

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/views.png)

## Basic Usage

    :Calendar

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image0.png)

    :Calendar 2000 1 1

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image1.png)

    :Calendar -view=year

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image2.png)

    :Calendar -view=year -split=vertical -width=27

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image3.png)

    :Calendar -view=year -split=horizontal -position=below -height=12

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image4.png)

    :Calendar -first_day=monday

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image5.png)

    :Calendar -view=clock

![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/image6.png)

You can switch between views with &lt; and &gt; keys.



![calendar.vim](https://raw.githubusercontent.com/wiki/itchyny/calendar.vim/image/frame.png)

If you have a trouble like the above screenshot, add the following configuration to your vimrc.
```vim
let g:calendar_frame = 'default'
```

## Concept
This is a calendar which is ...

### Comfortable
The key mappings are designed to match the default mappings of Vim.

### Powerful
The application can be connected to Google Calendar and used in your life.

### Elegant
The appearance is carefully designed, dropping any unnecessary information.

### Interesting
You can choose the calendar in Julian calendar or in Gregorian calendar.

### Useful
To conclude, very useful.

## Author
itchyny (https://github.com/itchyny)

## License
This software is released under the MIT License, see LICENSE.

## Installation
Install with your favorite plugin manager.

## Google Calendar and Google Task
In order to view and edit calendars on Google Calendar, or task on Google Task,
add the following configurations to your vimrc file.
```vim
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
```
It requires `wget` or `curl`.

### Important notice
The default client key is not provided anymore and you will get the **Authorization Error**.
You have to create your own Google API key and use for authentication with the following steps.

- Create a new project in [GCP](https://cloud.google.com/) and go to [Google APIs](https://console.developers.google.com/apis/).
- Click `ENABLE APIS AND SERVICES` add `Google Calendar API` and `Tasks API`.
- Go to [Google APIs](https://console.developers.google.com/apis/) and click `OAuth consent screen` from the sidebar.
  - Choose `External` (Available to any user with a Google Account.) and click `CREATE`.
  - Input your favorite name to `Application name`. In the `Scopes for Google APIs` section, click `Add scope` and add `Google Calendar API ../auth/calendar` and `Task API ../auth/tasks`.
  - Click `Save` (DO NOT `Submit for verification`).
- Go to the `Credentials` page from the sidebar.
  - Create a new API key and restrict key to the two APIs (`Google Calendar API`, `Tasks API`).
    - You have the api key.
  - Create a new `OAuth client ID`. Select `Desktop application` for the application type.
    - You have the client id and client secret.
- Open your terminal and save the credentials.
  - `mkdir -p ~/.cache/calendar.vim/ && touch ~/.cache/calendar.vim/credentials.vim`
  - `chmod 700 ~/.cache/calendar.vim && chmod 600 ~/.cache/calendar.vim/credentials.vim`
  - `vi ~/.cache/calendar.vim/credentials.vim`
  - Add the following three lines and save it. Please be sure to keep this file securely.
```vim
let g:calendar_google_api_key = '...'
let g:calendar_google_client_id = '....apps.googleusercontent.com'
let g:calendar_google_client_secret = '...'
```
  - Add `source ~/.cache/calendar.vim/credentials.vim` to your .vimrc.
- Restart Vim and open calendar.vim. You will get the unverified message but click `Advanced` and `Go to your-app (unsafe)`.
- Approve against some confirms (maybe three clicks) and you will get the login code. Copy and paste it into the prompt of calendar.vim. Now you'll be authenticated to your application..

## Terms of Use
Under no circumstances we are liable for any damages (including but not limited to damages for loss of business, loss of profits, interruption or the like) arising from use of this software.
This software deals with your events and tasks.
We are not liable for any circumstances; leakage of trade secrets due to the cache files of this software, loss of important events and tasks due to any kind of bugs and absence from important meetings due to any kind of failures of this software.
This software downloads your events from Google Calendar, and your tasks from Google Task.
DO NOT use this software with important events and tasks.
This software downloads your events or tasks to the cache directory.
Please be careful with the cache directory; DO NOT share the directory with any cloud storage softwares.
This software also uploads your events and tasks to Google APIs.
While it uses https, but DO NOT use this software for confidential matters.
This software NEVER uploads your events and tasks to any other server except Google's.
However, if `wget` or `curl` command are replaced with malicious softwares, your events or tasks can be uploaded to other sites.
Please use the official softwares for the commands.
