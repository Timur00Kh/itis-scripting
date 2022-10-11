
RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

declare -i counter=1
declare -a numbers

hit=0
miss=0

while :
do
  random_number=$(( RANDOM % 10)) # случайное число в диапазоне от 0 до 9
  echo "Step: ${counter}"
  read -r -p "Please enter number from 0 to 9 (q - quit): " input

  case "${input}" in
      [0-9])
            if [[ "${input}" == "${random_number}" ]]
                then
                    hit=$((hit+1))
                    number_string="${GREEN}${random_number}${RESET}"
                    echo "Hit! My number: ${random_number}"
                else
                    miss=$((miss+1))
                    number_string="${RED}${random_number}${RESET}"
                    echo "Miss! My number: ${random_number}"
            fi
            numbers+=("${number_string}")

            total=$(( hit + miss ))
            # shellcheck disable=SC2219
            let hit_percent=hit*100/total
            # shellcheck disable=SC2219
            let miss_percent=100-hit_percent

            echo "Hit: ${hit_percent}%" "Miss: ${miss_percent}%"
            echo "Array length: ${#numbers[@]}"


            if [[ ${#numbers[@]} -gt 10 ]]
                then
                  echo -e "Numbers: ${numbers[*]: -10}"
                else
                  echo -e "Numbers: ${numbers[*]}"
            fi
            counter=$((counter+1))
      ;;
      q)
          echo "Bye"
          echo "Exit..."
          break
      ;;
      *)
          echo "Not valid input"
          echo "Please repeat"
          continue
      ;;
  esac

  echo ""
done

