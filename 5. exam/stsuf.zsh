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

declare -A suffix_count

# Рекурсивный поиск файлов в каталоге
find "$directory" -type f | while read -r file; do
    # Извлекаем суффикс из имени файла
    suffix=$(echo "$file" | grep -oE '\.\w+$' || echo "no suffix")

    # Увеличиваем счетчик для данного суффикса
    ((suffix_count["$suffix"]++))
done

# Вывод статистики по суффиксам в порядке убывания
for suffix in ${(k)suffix_count[@]}; do
    count=${suffix_count[$suffix]}
    echo "$suffix: $count"
done

