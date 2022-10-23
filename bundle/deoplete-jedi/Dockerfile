FROM zchee/neovim:python
MAINTAINER zchee <zchee.io@gmail.com>

RUN pip3 install jedi \
	&& git clone https://github.com/Shougo/deoplete.nvim /src/deoplete.nvim \
	\
	&& echo 'set rtp+=/src/deoplete.nvim' >> /root/.config/nvim/init.vim \
	&& echo 'set rtp+=/src/deoplete-jedi' >> /root/.config/nvim/init.vim \
	&& echo 'let g:deoplete#enable_at_startup = 1' >> /root/.config/nvim/init.vim \
	&& echo 'let g:deoplete#auto_completion_start_length = 1' >> /root/.config/nvim/init.vim

COPY . /src/deoplete-jedi

RUN /src/run.sh
