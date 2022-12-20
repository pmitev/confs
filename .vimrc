" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set sw=2
" set foldmarker=#-#,#.#
" set foldmethod=marker
" vim:set foldmarker=#-#,#.# foldmethod=marker:
set foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\|\|(getline(v:lnum+1)=~@/)?1:2
map \z :set foldmethod=expr foldlevel=0 foldcolumn=1<CR>
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

set expandtab
set expandtab shiftwidth=2 softtabstop=2 smarttab
map <F12> :w<CR>:!./%<CR>
map <f11> :set fdc=2<CR>:set fdm=indent<CR>
"set number
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
set cursorline
set cursorcolumn

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

  hi Normal     ctermfg=white   ctermbg=black
  hi Constant   ctermfg=white   ctermbg=black
  hi Comment    ctermfg=cyan    ctermbg=black
  hi Special    ctermfg=red     ctermbg=black
  hi Statement  ctermfg=green   ctermbg=black
  hi identifier ctermfg=green   ctermbg=black
  hi Search     ctermfg=yellow  ctermbg=red
  hi ToDo       ctermfg=yellow  ctermbg=black
  hi DiffChange   term=bold ctermbg=2

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

  au FileType cp2k setlocal shiftwidth=2 tabstop=2
  au FileType python setlocal shiftwidth=2 tabstop=2 softtabstop=2

  autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd BufRead *.py set nocindent
  autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
  filetype plugin indent on

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
