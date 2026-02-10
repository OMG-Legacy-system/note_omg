#!/usr/bin/env bash

find . -type d | while read -r dir; do
    keyword_file="$dir/KEYWORDS.md"
    articoli_file="$dir/ARTICOLI.md"

    PARENT_DIR="\033[36m"
    OTHERS="\033[32m"
    GREEN="\033[32m"
    RESET="\033[0m"


    if [[ -f "$keyword_file" ]]; then

        num_papers=$(grep "###" "$keyword_file" | grep -v "\[\]()" | wc -l)

        echo -e "\033[35mTrovati $num_papers articoli per $keyword_file\033[0m"
        echo -e "\033[35mPaper non esaminati:\033[0m"

        echo
        
        if [[ -f "$articoli_file" ]]; then
        
            # Estrae le intestazioni complete (nome + link)
            mapfile -t keyword_entries < <(grep -E '^### \[.*\]\(.*\)' "$keyword_file")
            mapfile -t articoli_entries < <(grep -E '^### \[.*\]\(.*\)' "$articoli_file")

            missing=()

            for entry in "${keyword_entries[@]}"; do
                if ! printf '%s\n' "${articoli_entries[@]}" | grep -Fxq "$entry"; then
                    missing+=("$entry")
                fi
            done

            if [[ ${#missing[@]} -gt 0 ]]; then
                echo -e "${PARENT_DIR}$dir${RESET}"
                echo -e "${OTHERS}   |${RESET}"
                for m in "${missing[@]}"; do
                    name=$(echo "$m" | sed -E 's/^### \[(.*)\]\(.*\)$/\1/')
                    echo -e "${OTHERS}   |${RESET}"
                    echo -e "${OTHERS}   |-> $name${RESET}"
                done
                echo ""
                echo ""
            else
                echo -e "${PARENT_DIR}$dir${RESET}: ${GREEN}OK${RESET}"
            fi

        fi
    fi
done
