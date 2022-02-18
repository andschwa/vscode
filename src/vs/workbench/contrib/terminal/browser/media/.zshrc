# ---------------------------------------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See License.txt in the project root for license information.
# ---------------------------------------------------------------------------------------------

autoload -Uz add-zsh-hook

IN_COMMAND_EXECUTION="1"
prompt_start() {
	printf "\033]633;A\007"
}

prompt_end() {
	printf "\033]633;B\007"
}

update_cwd() {
	printf "\033]633;P;Cwd=%s\007" "$PWD"
}

command_output_start() {
	printf "\033]633;C\007"
}

command_complete() {
	printf "\033]633;D;%s\007" "$STATUS"
	update_cwd
}

update_prompt() {
	PRIOR_PROMPT="$PS1"
	IN_COMMAND_EXECUTION=""
	PS1="$(prompt_start)$PREFIX$PS1$(prompt_end)"
}

precmd() {
	STATUS="$?"
	command_complete "$STATUS"

	# in command execution
	if [ -n "$IN_COMMAND_EXECUTION" ]; then
		# non null
		update_prompt
	fi
}

preexec() {
	PS1="$PRIOR_PROMPT"
	if [ -z "${IN_COMMAND_EXECUTION-}" ]; then
		IN_COMMAND_EXECUTION="1"
		command_output_start
	fi
}

# Show the welcome message
if [ -z "${VSCODE_SHELL_HIDE_WELCOME-}" ]; then
	echo "\033[1;32mShell integration activated!\033[0m"
else
	VSCODE_SHELL_HIDE_WELCOME=""
fi

add-zsh-hook precmd precmd
add-zsh-hook preexec preexec