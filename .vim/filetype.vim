if exists('did_load_filetypes')
    finish
endif

augroup filetypedetect

autocmd BufNewFile,BufRead *.as setfiletype actionscript
autocmd BufNewFile,BufRead *.applescript setfiletype applescript
autocmd BufNewFile,BufRead *.pde setfiletype arduino
autocmd BufNewFile,BufRead Changes setfiletype changelog
autocmd BufNewFile,BufRead *.csv setfiletype csv
autocmd BufNewFile,BufRead *.tsv setfiletype csv | setlocal nolist |
    \ let b:csv_delimiter = "\t"
autocmd BufNewFile,BufRead *.epub setfiletype epub
autocmd BufNewFile,BufRead *.go setfiletype go
autocmd BufNewFile,BufRead hg-editor-*.txt setf hgcommit
autocmd BufNewFile,BufRead *.json setfiletype javascript
autocmd BufNewFile,BufRead *.nfo setfiletype nfo
autocmd BufNewFile,BufRead *.psgi setfiletype perl
autocmd BufNewFile,BufRead *.scala setfiletype scala
autocmd BufNewFile,BufRead .bash_* call SetFileTypeSH('bash')
autocmd BufNewFile,BufRead *.srt setfiletype srt
autocmd BufNewFile,BufRead *.{i,swg,swig} setfiletype swig
autocmd BufNewFile,BufRead .tmux.conf,tmux.conf setfiletype tmux
autocmd BufNewFile,BufRead *.tt setfiletype tt2html

autocmd BufNewFile,BufRead /**/apache*/**/*.conf setfiletype apache
autocmd BufNewFile,BufRead /**/templates/**/cron setfiletype crontab
autocmd BufNewFile,BufRead /**/nginx/conf/* setfiletype nginx
autocmd BufNewFile,BufRead /**/puppet/**/*.pp setfiletype puppet
autocmd BufNewFile,BufRead syslog-ng.conf setfiletype syslog-ng

augroup end
