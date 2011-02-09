if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect

autocmd BufNewFile,BufRead *.applescript setfiletype applescript
autocmd BufNewFile,BufRead *.csv setfiletype csv
autocmd BufNewFile,BufRead *.tsv setfiletype csv | setlocal nolist |
    \ let b:csv_delimiter = "\t"
autocmd BufNewFile,BufRead *.json setfiletype json
autocmd BufNewFile,BufRead *.nfo setfiletype nfo
autocmd BufNewFile,BufRead *.pde setfiletype arduino
autocmd BufNewFile,BufRead *.psgi,*.t setfiletype perl
autocmd BufNewFile,BufRead *.scala setfiletype scala
autocmd BufNewFile,BufRead *.i,*.swg,*.swig setfiletype swig
autocmd BufNewFile,BufRead *.tt setfiletype tt2html

autocmd BufNewFile,BufRead /**/apache*/**/*.conf setfiletype apache
autocmd BufNewFile,BufRead /**/templates/**/cron setfiletype crontab
autocmd BufNewFile,BufRead /**/nginx/conf/* setfiletype nginx
autocmd BufNewFile,BufRead /**/puppet/**/*.pp setfiletype puppet
autocmd BufNewFile,BufRead syslog-ng.conf setfiletype syslog-ng

augroup end
