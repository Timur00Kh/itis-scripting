#!/bin/zsh

if [ "$#" -ne 1 ]; then
    echo "Использование: $0 <путь_к_каталогу>"
    exit 1
fi

directory=$1

if [ ! -d "$directory" ]; then
    echo "Ошибка: $directory не является каталогом."
    exit 1
fi

for file in "$directory"/*.txt; do
    if [ -f "$file" ]; then
        user_name=$(whoami)
        date_iso=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        line="Approved $user_name $date_iso"

        # Добавление строки в начало файла
        sed -i '' "1i\\
$line
" "$file"

        echo "Добавлена строка в файл: $file"
    fi
done