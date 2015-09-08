get_my_prompt()
{
    local WHITE='\[\e[0;37m\]'
    local PURPLE='\[\e[0;35m\]'
    local BLUE='\[\e[0;34m\]'
    local CYAN='\[\e[0;36m\]'
    local GREEN='\[\e[0;32m\]'
    local YELLOW='\[\e[0;33m\]'
    local RED='\[\e[0;31m\]'

    local BOLD_WHITE='\[\e[1;37m\]'
    local BOLD_PURPLE='\[\e[1;35m\]'
    local BOLD_BLUE='\[\e[1;34m\]'
    local BOLD_CYAN='\[\e[1;36m\]'
    local BOLD_GREEN='\[\e[1;32m\]'
    local BOLD_YELLOW='\[\e[1;33m\]'
    local BOLD_RED='\[\e[1;31m\]'

    local RESET='\[\e[0m\]'
    
    local MODIFIED=0
    local ADDED=0
    local DELETED=0
    local UNTRACKED=0
    local BRANCH=""

    local OUTPUT_STR=""
    
    if result=$(git status -b --porcelain 2>&1); then
	IFS=$'\n' read -rd '' -a lines <<<"$result"

	BRANCH="${lines[0]##* }"

	for line in "${lines[@]:1}"; do
	    first_char=${line:0:1}
	    case "$first_char" in
		A)
		    ((ADDED++)) ;;
		C)
		    ((ADDED++)) ;;
		M)
                    ((MODIFIED++)) ;;
		R)
		    ((DELETED++)); ((ADDED++)) ;;
		D)
		    ((DELETED++)) ;;
		?)
		    ((UNTRACKED++)) ;;
	    esac
	done
	
	OUTPUT_STR="${WHITE}${PWD##*/},{${BLUE}${BRANCH}${WHITE},${GREEN}${ADDED}${WHITE},${YELLOW}${MODIFIED}${WHITE},${RED}${DELETED}${WHITE},${PURPLE}${UNTRACKED}${WHITE}}"
    else
	OUTPUT_STR="${WHITE}${PWD##*/}"
    fi

    printf " ${CYAN}λ(${OUTPUT_STR}${CYAN}) ->${RESET} "
}

PROMPT_COMMAND='PS1=$(get_my_prompt); '$PROMPT_COMMAND
