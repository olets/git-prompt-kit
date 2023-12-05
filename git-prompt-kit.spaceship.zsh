# git_prompt_kit
#
# Git Prompt Kit section for Spaceship
# Requires Git Prompt Kit
# https://github.com/olets/git-prompt-kit
# Add git_prompt_kit to SPACESHIP_PROMPT_ORDER

SPACESHIP_GIT_PROMPT_KIT_PREFIX=${SPACESHIP_GIT_PROMPT_KIT_PREFIX:-}
SPACESHIP_GIT_PROMPT_KIT_SUFFIX=${SPACESHIP_GIT_PROMPT_KIT_SUFFIX:- }
# colors are set with the GIT_PROMPT_KIT_ configuration variables

spaceship_git_prompt_kit() {
  [[ $SPACESHIP_GIT_PROMPT_KIT_SHOW == false ]] && return

  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0

  spaceship::section \
    --prefix "$SPACESHIP_GIT_PROMPT_KIT_PREFIX" \
    "$SPACESHIP_GIT_PROMPT_KIT_SYMBOL$(print -P ${GIT_PROMPT_KIT_REF:+$GIT_PROMPT_KIT_REF }${GIT_PROMPT_KIT_STATUS_EXTENDED:+$GIT_PROMPT_KIT_STATUS_EXTENDED }${GIT_PROMPT_KIT_STATUS:+$GIT_PROMPT_KIT_STATUS }${GIT_PROMPT_KIT_ACTION})" \
    --suffix "$SPACESHIP_GIT_PROMPT_KIT_SUFFIX"
}
