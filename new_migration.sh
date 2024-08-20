#!/usr/bin/zsh

local last_index=$(find . -type f -name "*.sql*"|sed -e 's/^.*\/\([0-9]\+\).*$/\1/'|sort|tail -1)

function db_with_user() {
    local db_uppercase=$(echo ${2}|tr '[:lower:]' '[:upper:]')
    cat <<EOUP > templates/${1}_${2}.up.sql.tmpl
CREATE DATABASE IF NOT EXISTS ${2};
CREATE USER IF NOT EXISTS '{{ .${db_uppercase}_USER }}'@'%' IDENTIFIED BY '{{ .${db_uppercase}_PASSWORD }}';
GRANT ALL PRIVILEGES ON ${2}.* TO '{{ .${db_uppercase}_USER }}'@'%';
FLUSH PRIVILEGES;

-- vim:set syntax=sql:
EOUP

    cat <<EODOWN > templates/${1}_${2}.down.sql.tmpl
DROP USER IF EXISTS '{{ .${db_uppercase}_USER }}'@'%';
DROP DATABASE IF EXISTS ${2};

-- vim:set syntax=sql:
EODOWN
}

db_with_user ${last_index:-01} ${1}
