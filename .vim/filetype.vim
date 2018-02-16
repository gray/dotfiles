if exists('did_load_filetypes')
    finish
endif

augroup filetypedetect

autocmd BufNewFile,BufRead *.as setfiletype actionscript
autocmd BufNewFile,BufRead *.applescript setfiletype applescript
autocmd BufNewFile,BufRead *.pde setfiletype arduino
autocmd BufNewFile,BufRead Changes setfiletype changelog
autocmd BufNewFile,BufRead */.irssi/config setfiletype conf
autocmd BufNewFile,BufRead *.epub setfiletype epub
autocmd BufNewFile,BufRead *.nfo setfiletype nfo
autocmd BufNewFile,BufRead *.psgi,~/.dataprinter setfiletype perl
autocmd BufNewFile,BufRead .bash_*,bash-fc-\d\+
    \ if v:version >= 800 | call dist#ft#SetFileTypeSH('bash') |
    \ else                | call SetFileTypeSH('bash') | endif
autocmd BufNewFile,BufRead *.srt setfiletype srt
autocmd BufNewFile,BufRead *.{i,swg,swig} setfiletype swig
autocmd BufNewFile,BufRead *.tt setfiletype tt2html

autocmd BufNewFile,BufRead /**/apache*/**/*.conf setfiletype apache
autocmd BufNewFile,BufRead /**/templates/**/cron setfiletype crontab
autocmd BufNewFile,BufRead /**/nginx/conf/* setfiletype nginx
autocmd BufNewFile,BufRead /**/puppet/**/*.pp setfiletype puppet
autocmd BufNewFile,BufRead syslog-ng.conf setfiletype syslog-ng

augroup end
