#!/bin/zsh

if [[ "$#" -ne 3 ]]; then
    echo "Использование: $0 <путь_к_каталогу> <старый_суффикс> <новый_суффикс>"
    exit 1
fi

directory=$1
old_suffix=$2
new_suffix=$3

# Проверка на корректность суффиксов
if [[ ! $old_suffix == .* || $old_suffix == *\. || ! $new_suffix == .* || $new_suffix == *\. ]]; then
    echo "Ошибка: Некорректный старый или новый суффикс."
    exit 1
fi

# Рекурсивный поиск и замена суффикса файлов
for file in $directory/**/*$old_suffix(N); do
    if [ -f "$file" ]; then
        base_name=${file%$old_suffix}
        new_name="$base_name$new_suffix"

        # Замена суффикса
        mv "$file" "$new_name"
        echo "Переименован файл: $file -> $new_name"
    fi
done
