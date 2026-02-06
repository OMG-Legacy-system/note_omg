#!/usr/bin/env bash

find . -type d | while read -r dir; do
    keyword_file="$dir/KEYWORDS.md"
    articoli_file="$dir/ARTICOLI.md"

    if [[ -f "$keyword_file" && -f "$articoli_file" ]]; then

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
            echo "$dir"
            echo "   |"
            for m in "${missing[@]}"; do
                name=$(echo "$m" | sed -E 's/^### \[(.*)\]\(.*\)$/\1/')
                echo "   |"
                echo "   |-> $name"
            done
            echo ""
            echo ""
        else
            echo "$dir: OK"
        fi
    fi
done
