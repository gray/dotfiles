if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect

autocmd BufNewFile,BufRead *.applescript setfiletype applescript
autocmd BufNewFile,BufRead *.csv setfiletype csv
autocmd BufNewFile,BufRead *.json setfiletype json
autocmd BufNewFile,BufRead *.nfo setfiletype nfo
autocmd BufNewFile,BufRead *.scala setfiletype scala
autocmd BufNewFile,BufRead *.t setfiletype perl
autocmd BufNewFile,BufRead *.tsv setfiletype csv | setlocal nolist |
    \ let b:csv_delimiter = "\t"
autocmd BufNewFile,BufRead *.tt setfiletype tt2html

autocmd BufNewFile,BufRead syslog-ng.conf setfiletype syslog-ng
autocmd BufNewFile,BufRead /**/apache*/**/*.conf setfiletype apache
autocmd BufNewFile,BufRead /**/nginx/conf/* setfiletype nginx
autocmd BufNewFile,BufRead /**/puppet/**/*.pp setfiletype puppet
autocmd BufNewFile,BufRead /**/templates/**/cron setfiletype crontab

augroup end
