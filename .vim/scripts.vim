if did_filetype()
    finish
endif

let b:my_filetype = system('file -b ' . shellescape(expand('%'))) |

if b:my_filetype =~# '^SQLite 3\.x database' |
    setfiletype sqlite |
elseif b:my_filetype =~# '^Berkeley DB 1\.[^ ]\+ (Hash' |
    setfiletype bdb1_hash |
endif
