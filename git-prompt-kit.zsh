#!/usr/bin/env zsh

# Git Prompt Kit
# v4.1.1
# Dec 11 2023
# https://github.com/olets/git-prompt-kit
# Copyright (©) 2019-present Henry Bley-Vroman

typeset -r GIT_PROMPT_KIT_VERSION="4.1.1"

# Behavior options
typeset -gi GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND=${GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND:-1}
typeset -gi GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS=${GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS:-1}
typeset -gi GIT_PROMPT_KIT_HIDE_TOOL_NAMES=${GIT_PROMPT_KIT_HIDE_TOOL_NAMES:-1}
typeset -gi GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS=${GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS:-1}

# Colors options
GIT_PROMPT_KIT_COLOR_ACTION=${GIT_PROMPT_KIT_COLOR_ACTION-199}
GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED=${GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED-81}
GIT_PROMPT_KIT_COLOR_CWD=${GIT_PROMPT_KIT_COLOR_CWD-39}
GIT_PROMPT_KIT_COLOR_FAILED=${GIT_PROMPT_KIT_COLOR_FAILED-88}
GIT_PROMPT_KIT_COLOR_HEAD=${GIT_PROMPT_KIT_COLOR_HEAD-140}
GIT_PROMPT_KIT_COLOR_HOST=${GIT_PROMPT_KIT_COLOR_HOST-109}
GIT_PROMPT_KIT_COLOR_INACTIVE=${GIT_PROMPT_KIT_COLOR_INACTIVE-247}
GIT_PROMPT_KIT_COLOR_PUSH_REMOTE=${GIT_PROMPT_KIT_COLOR_PUSH_REMOTE-111}
GIT_PROMPT_KIT_COLOR_REMOTE=${GIT_PROMPT_KIT_COLOR_REMOTE-216}
GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE=${GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE-81}
GIT_PROMPT_KIT_COLOR_STAGED=${GIT_PROMPT_KIT_COLOR_STAGED-120}
GIT_PROMPT_KIT_COLOR_STASH=${GIT_PROMPT_KIT_COLOR_STASH-81}
GIT_PROMPT_KIT_COLOR_SUCCEEDED=${GIT_PROMPT_KIT_COLOR_SUCCEEDED-76}
GIT_PROMPT_KIT_COLOR_TAG=${GIT_PROMPT_KIT_COLOR_TAG-86}
GIT_PROMPT_KIT_COLOR_UNSTAGED=${GIT_PROMPT_KIT_COLOR_UNSTAGED-162}
GIT_PROMPT_KIT_COLOR_USER=${GIT_PROMPT_KIT_COLOR_USER-109}

# Configuration options
typeset -g GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX=${GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX:-__git_prompt_kit}
typeset -g GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME=${GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME:-GIT_PROMPT_KIT}

# Content options
GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT=${GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT-1}
GIT_PROMPT_KIT_DEFAULT_PUSH_REMOTE_NAME=${GIT_PROMPT_KIT_DEFAULT_PUSH_REMOTE_NAME-upstream}
GIT_PROMPT_KIT_DEFAULT_REMOTE_NAME=${GIT_PROMPT_KIT_DEFAULT_REMOTE_NAME-origin}
GIT_PROMPT_KIT_REPO_SUBDIRECTORY_MAX_TRAILING_COUNT=${GIT_PROMPT_KIT_REPO_SUBDIRECTORY_MAX_TRAILING_COUNT-1}
#
if ! [[ -v GIT_PROMPT_KIT_HIDDEN_HOSTS ]]; then
  typeset -a GIT_PROMPT_KIT_HIDDEN_HOSTS=()
fi

if ! [[ -v GIT_PROMPT_KIT_HIDDEN_USERS ]]; then
  typeset -a GIT_PROMPT_KIT_HIDDEN_USERS=()
fi

# Symbols options
GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS=${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS-}
#
GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL=${GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL-%%}
GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT=${GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT-#}
GIT_PROMPT_KIT_SYMBOL_LOCAL=${GIT_PROMPT_KIT_SYMBOL_LOCAL-local}
# Symbols which have verbose default variants
GIT_PROMPT_KIT_SYMBOL_BRANCH=${GIT_PROMPT_KIT_SYMBOL_BRANCH-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+"branch: "}:-}}
GIT_PROMPT_KIT_SYMBOL_COMMIT=${GIT_PROMPT_KIT_SYMBOL_COMMIT-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+"commit: "}:-}}
GIT_PROMPT_KIT_SYMBOL_HOST=${GIT_PROMPT_KIT_SYMBOL_HOST-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" host: "}:-@}}
GIT_PROMPT_KIT_SYMBOL_PUSH_REMOTE=${GIT_PROMPT_KIT_SYMBOL_PUSH_REMOTE-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+"push-remote: "}:-@{push}}}
GIT_PROMPT_KIT_SYMBOL_REMOTE=${GIT_PROMPT_KIT_SYMBOL_REMOTE-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+"remote: "}:-@{u}}}
GIT_PROMPT_KIT_SYMBOL_TAG=${GIT_PROMPT_KIT_SYMBOL_TAG-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+"tag: "}:-@}}
# Symbols which have verbose default and inactive variants
GIT_PROMPT_KIT_SYMBOL_AHEAD=${GIT_PROMPT_KIT_SYMBOL_AHEAD-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+"ahead "}:-+}}
GIT_PROMPT_KIT_SYMBOL_AHEAD_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_AHEAD_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_AHEAD%% }## }}
GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED=${GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" assumed-unchanged"}:-⥱}}
GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED%% }## }}
GIT_PROMPT_KIT_SYMBOL_BEHIND=${GIT_PROMPT_KIT_SYMBOL_BEHIND-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+"behind "}:--}}
GIT_PROMPT_KIT_SYMBOL_BEHIND_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_BEHIND_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_BEHIND%% }## }}
GIT_PROMPT_KIT_SYMBOL_CONFLICTED=${GIT_PROMPT_KIT_SYMBOL_CONFLICTED-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" conflicted"}:-UU}}
GIT_PROMPT_KIT_SYMBOL_CONFLICTED_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_CONFLICTED_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_CONFLICTED%% }## }}
GIT_PROMPT_KIT_SYMBOL_DELETED=${GIT_PROMPT_KIT_SYMBOL_DELETED-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" deleted"}:-_D}}
GIT_PROMPT_KIT_SYMBOL_DELETED_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_DELETED_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_DELETED%% }## }}
GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED=${GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" staged-deleted"}:-D_}}
GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED%% }## }}
GIT_PROMPT_KIT_SYMBOL_MODIFIED=${GIT_PROMPT_KIT_SYMBOL_MODIFIED-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" modified"}:-_M}}
GIT_PROMPT_KIT_SYMBOL_MODIFIED_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_MODIFIED_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_MODIFIED%% }## }}
GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED=${GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" modified-staged"}:-M_}}
GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED%% }## }}
GIT_PROMPT_KIT_SYMBOL_NEW=${GIT_PROMPT_KIT_SYMBOL_NEW-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" new"}:-A_}}
GIT_PROMPT_KIT_SYMBOL_NEW_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_NEW_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_NEW%% }## }}
GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE=${GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" skip-worktree"}:-⤳}}
GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE%% }## }}
GIT_PROMPT_KIT_SYMBOL_STASH=${GIT_PROMPT_KIT_SYMBOL_STASH-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" stashes"}:-⇲}}
GIT_PROMPT_KIT_SYMBOL_STASH_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_STASH_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_STASH%% }## }}
GIT_PROMPT_KIT_SYMBOL_UNTRACKED=${GIT_PROMPT_KIT_SYMBOL_UNTRACKED-${${GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS:+" untracked"}:-??}}
GIT_PROMPT_KIT_SYMBOL_UNTRACKED_INACTIVE=${GIT_PROMPT_KIT_SYMBOL_UNTRACKED_INACTIVE-${${GIT_PROMPT_KIT_SYMBOL_UNTRACKED%% }## }}

# END OF CONFIG VARIABLES


typeset -ga _git_prompt_kit_colors
_git_prompt_kit_colors=(
  GIT_PROMPT_KIT_COLOR_ACTION
  GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED
  GIT_PROMPT_KIT_COLOR_FAILED
  GIT_PROMPT_KIT_COLOR_HEAD
  GIT_PROMPT_KIT_COLOR_HOST
  GIT_PROMPT_KIT_COLOR_INACTIVE
  GIT_PROMPT_KIT_COLOR_PUSH_REMOTE
  GIT_PROMPT_KIT_COLOR_REMOTE
  GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE
  GIT_PROMPT_KIT_COLOR_STAGED
  GIT_PROMPT_KIT_COLOR_STASH
  GIT_PROMPT_KIT_COLOR_SUCCEEDED
  GIT_PROMPT_KIT_COLOR_TAG
  GIT_PROMPT_KIT_COLOR_UNSTAGED
  GIT_PROMPT_KIT_COLOR_USER
  GIT_PROMPT_KIT_COLOR_CWD
)

typeset -ga _git_prompt_kit_configs
_git_prompt_kit_configs+=( $_git_prompt_kit_colors )
_git_prompt_kit_configs+=(
  GIT_PROMPT_KIT_DEFAULT_PUSH_REMOTE_NAME
  GIT_PROMPT_KIT_DEFAULT_REMOTE_NAME
  GIT_PROMPT_KIT_HIDDEN_HOSTS
  GIT_PROMPT_KIT_HIDDEN_USERS
  GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND
  GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS
  GIT_PROMPT_KIT_HIDE_TOOL_NAMES
  GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS
  GIT_PROMPT_KIT_SYMBOL_AHEAD
  GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED
  GIT_PROMPT_KIT_SYMBOL_BEHIND
  GIT_PROMPT_KIT_SYMBOL_BRANCH
  GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL
  GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT
  GIT_PROMPT_KIT_SYMBOL_COMMIT
  GIT_PROMPT_KIT_SYMBOL_CONFLICTED
  GIT_PROMPT_KIT_SYMBOL_DELETED
  GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED
  GIT_PROMPT_KIT_SYMBOL_HOST
  GIT_PROMPT_KIT_SYMBOL_LOCAL
  GIT_PROMPT_KIT_SYMBOL_MODIFIED
  GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED
  GIT_PROMPT_KIT_SYMBOL_NEW
  GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE
  GIT_PROMPT_KIT_SYMBOL_STASH
  GIT_PROMPT_KIT_SYMBOL_TAG
  GIT_PROMPT_KIT_SYMBOL_UNTRACKED
  GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS
)

git-prompt-kit-colors() {
  for color in ${(o)_git_prompt_kit_colors}; do
    'builtin' 'print' -P "%F{${(P)color}}● $color%f"
  done

  if _git_prompt_kit_no_color; then
    'builtin' 'print' "NO_COLOR is set so colors are not used"
  fi
}

git-prompt-kit-config() {
  local val

  for config in ${(o)_git_prompt_kit_configs}; do
    if [[ ${(tP)config} == "array" ]]; then
      val="$config=( "

      for k in ${(P)config}; do
        val+="${(qqq)k} "
      done

      val+=")"

      'builtin' 'print' "$val"
    else
      'builtin' 'print' "$config=${(qqqP)config}"
    fi
  done
}

_git_prompt_kit_update_git() {
  emulate -L zsh

  typeset -g GIT_PROMPT_KIT_ACTION=
  typeset -g GIT_PROMPT_KIT_AHEAD=
  typeset -g GIT_PROMPT_KIT_ASSUMED_UNCHANGED=
  typeset -g GIT_PROMPT_KIT_BEHIND=
  typeset -g GIT_PROMPT_KIT_CONFLICTED=
  typeset -g GIT_PROMPT_KIT_DELETED=
  typeset -g GIT_PROMPT_KIT_DELETED_STAGED=
  typeset -g GIT_PROMPT_KIT_DIRTY=
  typeset -g GIT_PROMPT_KIT_HEAD=
  typeset -g GIT_PROMPT_KIT_MODIFIED=
  typeset -g GIT_PROMPT_KIT_MODIFIED_STAGED=
  typeset -g GIT_PROMPT_KIT_NEW=
  typeset -g GIT_PROMPT_KIT_PUSH=
  typeset -g GIT_PROMPT_KIT_PUSH_AHEAD=
  typeset -g GIT_PROMPT_KIT_PUSH_BEHIND=
  typeset -g GIT_PROMPT_KIT_REF=
  typeset -g GIT_PROMPT_KIT_REMOTE=
  typeset -g GIT_PROMPT_KIT_REPO_ROOT=
  typeset -g GIT_PROMPT_KIT_REPO_SUBDIRECTORY=
  typeset -g GIT_PROMPT_KIT_SKIP_WORKTREE=
  typeset -g GIT_PROMPT_KIT_STASHES=
  typeset -g GIT_PROMPT_KIT_STATUS=
  typeset -g GIT_PROMPT_KIT_STATUS_EXTENDED=
  typeset -g GIT_PROMPT_KIT_TAG=
  typeset -g GIT_PROMPT_KIT_UNTRACKED=

  gitstatus_query$GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX $GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  # Set variables for later use

  local action_status=
  local color_action
  local color_assume_unchanged
  local color_head
  local color_inactive
  local color_push_remote
  local color_remote
  local color_skip_worktree
  local color_staged
  local color_stash
  local color_tag
  local color_unstaged
  local color_repo
  local ref_status=
  local tree_status=
  local -a repo_root_path_components
  local -a repo_subdirectory_path_components
  local -i added_staged_count
  local -i show_ahead
  local -i show_behind
  local -i show_push_ahead
  local -i show_push_behind
  local -i show_remote
  local -i show_remote_branch
  local -i triangular_workflow
  local -i unstaged_count

  if ! _git_prompt_kit_no_color; then
    color_action=$GIT_PROMPT_KIT_COLOR_ACTION
    color_assume_unchanged=$GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED
    color_head=$GIT_PROMPT_KIT_COLOR_HEAD
    color_inactive=$GIT_PROMPT_KIT_COLOR_INACTIVE
    color_push_remote=$GIT_PROMPT_KIT_COLOR_PUSH_REMOTE
    color_remote=$GIT_PROMPT_KIT_COLOR_REMOTE
    color_skip_worktree=$GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE
    color_staged=$GIT_PROMPT_KIT_COLOR_STAGED
    color_stash=$GIT_PROMPT_KIT_COLOR_STASH
    color_tag=$GIT_PROMPT_KIT_COLOR_TAG
    color_unstaged=$GIT_PROMPT_KIT_COLOR_UNSTAGED
    color_repo=$GIT_PROMPT_KIT_COLOR_CWD
  fi

  (( added_staged_count = VCS_STATUS_NUM_STAGED - VCS_STATUS_NUM_STAGED_NEW - VCS_STATUS_NUM_STAGED_DELETED ))
  (( unstaged_count = VCS_STATUS_NUM_UNSTAGED - VCS_STATUS_NUM_UNSTAGED_DELETED ))

  if [[ -n $VCS_STATUS_REMOTE_NAME ]] && [[ $VCS_STATUS_REMOTE_NAME != $GIT_PROMPT_KIT_DEFAULT_REMOTE_NAME ]]; then
    show_remote=1
  fi

  if [[ $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
    show_remote_branch=1
  fi

  if [[ -n $VCS_STATUS_PUSH_REMOTE_NAME ]] && [[ $VCS_STATUS_PUSH_REMOTE_NAME != $VCS_STATUS_REMOTE_NAME ]]; then
    triangular_workflow=1
  fi
  
  (( show_ahead = ! GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND || VCS_STATUS_COMMITS_AHEAD ))
  (( show_behind = ! GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND || VCS_STATUS_COMMITS_BEHIND ))
  # show_push_remote_branch would go here
  (( show_push_ahead = ! GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND || VCS_STATUS_PUSH_COMMITS_AHEAD ))
  (( show_push_behind = ! GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND || VCS_STATUS_PUSH_COMMITS_BEHIND ))

  # Git repo directory
  if [[ ${VCS_STATUS_WORKDIR#$HOME} != $VCS_STATUS_WORKDIR ]]; then
    repo_root_path_components=( "~" ${(s./.)${VCS_STATUS_WORKDIR#$HOME}} )
  else
    repo_root_path_components=( ${(s./.)VCS_STATUS_WORKDIR} )
  fi

  # path segments above the repo root dir
  if (( GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT + 1 >= ${#repo_root_path_components} )) || (( GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT < 0 )); then
    GIT_PROMPT_KIT_REPO_ROOT+=${(j./.)repo_root_path_components[0,-2]}
  else
    GIT_PROMPT_KIT_REPO_ROOT+=${(j./.)repo_root_path_components[$(( -1 - GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT )),-2]}
  fi

  # if there are path segments above the repo root dir, prefix the repo root dir with `/`
  if [[ -n $GIT_PROMPT_KIT_REPO_ROOT ]]; then
    GIT_PROMPT_KIT_REPO_ROOT+="/"
  fi
  
  # color the repo root path
  GIT_PROMPT_KIT_REPO_ROOT="%F{$color_repo}$GIT_PROMPT_KIT_REPO_ROOT"
  # underline the repo root dir
  GIT_PROMPT_KIT_REPO_ROOT+="%U${repo_root_path_components[-1]}%u"
  GIT_PROMPT_KIT_REPO_ROOT+="%F{$color_inactive}"

  # Git repo subdirectory
  if [[ $VCS_STATUS_WORKDIR != $PWD ]]; then
    repo_subdirectory_path_components=( ${(s./.)PWD##$VCS_STATUS_WORKDIR} )

    GIT_PROMPT_KIT_REPO_SUBDIRECTORY+="%F{$color_repo}"

    if (( GIT_PROMPT_KIT_REPO_SUBDIRECTORY_MAX_TRAILING_COUNT + 1 >= ${#repo_subdirectory_path_components} )) || (( GIT_PROMPT_KIT_REPO_SUBDIRECTORY_MAX_TRAILING_COUNT < 0 )); then
      GIT_PROMPT_KIT_REPO_SUBDIRECTORY+=${(j./.)repo_subdirectory_path_components[0,-1]}
    else
      GIT_PROMPT_KIT_REPO_SUBDIRECTORY+=.../${(j./.)repo_subdirectory_path_components[$(( -1 - GIT_PROMPT_KIT_REPO_SUBDIRECTORY_MAX_TRAILING_COUNT )),-1]}
    fi

    GIT_PROMPT_KIT_REPO_SUBDIRECTORY+="%F{$color_inactive}"
  fi

  # Git tree status: stashes

  if (( ! GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS || VCS_STATUS_STASHES )); then
    GIT_PROMPT_KIT_STASHES+="%F{$color_inactive}"
    
    if (( VCS_STATUS_STASHES )); then
      GIT_PROMPT_KIT_STASHES+="%F{$color_stash}$VCS_STATUS_STASHES"
      GIT_PROMPT_KIT_STASHES+="$GIT_PROMPT_KIT_SYMBOL_STASH"
    else
      GIT_PROMPT_KIT_STASHES+="${GIT_PROMPT_KIT_SYMBOL_STASH_INACTIVE}"
    fi

    GIT_PROMPT_KIT_STASHES+="%F{$color_inactive}"
  fi

  # Git tree status: files with the assume-unchanged bit set

  if (( ! GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS || VCS_STATUS_NUM_ASSUME_UNCHANGED )); then
    GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="%F{$color_inactive}"
    
    if (( VCS_STATUS_NUM_ASSUME_UNCHANGED )); then
      GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="%F{$color_assume_unchanged}$VCS_STATUS_NUM_ASSUME_UNCHANGED"
      GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="$GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED"
    else
      GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="${GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED_INACTIVE}"
    fi

    GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="%F{$color_inactive}"
  fi

  # Git tree status: files with the skip-worktree bit set

  if (( ! GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS || VCS_STATUS_NUM_SKIP_WORKTREE )); then
    GIT_PROMPT_KIT_SKIP_WORKTREE+="%F{$color_inactive}"
    
    if (( VCS_STATUS_NUM_SKIP_WORKTREE )); then
      GIT_PROMPT_KIT_SKIP_WORKTREE+="%F{$color_skip_worktree}$VCS_STATUS_NUM_SKIP_WORKTREE"
      GIT_PROMPT_KIT_SKIP_WORKTREE+="$GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE"
    else
      GIT_PROMPT_KIT_SKIP_WORKTREE+="${GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE_INACTIVE}"
    fi

    GIT_PROMPT_KIT_SKIP_WORKTREE+="%F{$color_inactive}"
  fi

  # Git tree status: untracked (new) files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_UNTRACKED )); then
    GIT_PROMPT_KIT_UNTRACKED+="%F{$color_inactive}"

    if (( VCS_STATUS_NUM_UNTRACKED )); then
      GIT_PROMPT_KIT_UNTRACKED+="%F{$color_unstaged}$VCS_STATUS_NUM_UNTRACKED"
      GIT_PROMPT_KIT_UNTRACKED+="$GIT_PROMPT_KIT_SYMBOL_UNTRACKED"
      GIT_PROMPT_KIT_DIRTY=1
    else
      GIT_PROMPT_KIT_UNTRACKED+="${GIT_PROMPT_KIT_SYMBOL_UNTRACKED_INACTIVE}"
    fi

    GIT_PROMPT_KIT_UNTRACKED+="%F{$color_inactive}"
  fi

  # Git tree status: conflicted files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_CONFLICTED )); then
    GIT_PROMPT_KIT_CONFLICTED+="%F{$color_inactive}"
    
    if (( VCS_STATUS_NUM_CONFLICTED )); then
      GIT_PROMPT_KIT_CONFLICTED+="%F{$color_unstaged}$VCS_STATUS_NUM_CONFLICTED"
      GIT_PROMPT_KIT_CONFLICTED+="$GIT_PROMPT_KIT_SYMBOL_CONFLICTED"
      GIT_PROMPT_KIT_DIRTY=1
    else
      GIT_PROMPT_KIT_CONFLICTED+="${GIT_PROMPT_KIT_SYMBOL_CONFLICTED_INACTIVE}"
    fi

    GIT_PROMPT_KIT_CONFLICTED+="%F{$color_inactive}"
  fi

  # Git tree status: unstaged deleted files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_UNSTAGED_DELETED )); then
    GIT_PROMPT_KIT_DELETED+="%F{$color_inactive}"

    if (( VCS_STATUS_NUM_UNSTAGED_DELETED )); then
      GIT_PROMPT_KIT_DELETED+="%F{$color_unstaged}$VCS_STATUS_NUM_UNSTAGED_DELETED"
      GIT_PROMPT_KIT_DELETED+="$GIT_PROMPT_KIT_SYMBOL_DELETED"
      GIT_PROMPT_KIT_DIRTY=1
    else
      GIT_PROMPT_KIT_DELETED+="${GIT_PROMPT_KIT_SYMBOL_DELETED_INACTIVE}"
    fi

    GIT_PROMPT_KIT_DELETED+="%F{$color_inactive}"
  fi

  # Git tree status: unstaged modified files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || unstaged_count )); then
    GIT_PROMPT_KIT_MODIFIED+="%F{$color_inactive}"

    if (( unstaged_count )); then
      GIT_PROMPT_KIT_MODIFIED+="%F{$color_unstaged}$unstaged_count"
      GIT_PROMPT_KIT_MODIFIED+="$GIT_PROMPT_KIT_SYMBOL_MODIFIED"
      GIT_PROMPT_KIT_DIRTY=1
    else
      GIT_PROMPT_KIT_MODIFIED+="${GIT_PROMPT_KIT_SYMBOL_MODIFIED_INACTIVE}"
    fi

    GIT_PROMPT_KIT_MODIFIED+="%F{$color_inactive}"
  fi

  # Git tree status: staged new files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_STAGED_NEW )); then
    GIT_PROMPT_KIT_NEW+="%F{$color_inactive}"

    if (( VCS_STATUS_NUM_STAGED_NEW )); then
      GIT_PROMPT_KIT_NEW+="%F{$color_staged}$VCS_STATUS_NUM_STAGED_NEW"
      GIT_PROMPT_KIT_NEW+="$GIT_PROMPT_KIT_SYMBOL_NEW"
      GIT_PROMPT_KIT_DIRTY=1
    else
      GIT_PROMPT_KIT_NEW+="${GIT_PROMPT_KIT_SYMBOL_NEW_INACTIVE}"
    fi

    GIT_PROMPT_KIT_NEW+="%F{$color_inactive}"
  fi

  # Git tree status: staged deleted files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_STAGED_DELETED )); then
    GIT_PROMPT_KIT_DELETED_STAGED+="%F{$color_inactive}"
    
    if (( VCS_STATUS_NUM_STAGED_DELETED )); then
      GIT_PROMPT_KIT_DELETED_STAGED+="%F{$color_staged}$VCS_STATUS_NUM_STAGED_DELETED"
      GIT_PROMPT_KIT_DELETED_STAGED+="$GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED"
      GIT_PROMPT_KIT_DIRTY=1
    else
      GIT_PROMPT_KIT_DELETED_STAGED+="${GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED_INACTIVE}"
    fi

    GIT_PROMPT_KIT_DELETED_STAGED+="%F{$color_inactive}"
  fi

  # Git tree status: staged modified files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || added_staged_count )); then
    GIT_PROMPT_KIT_MODIFIED_STAGED+="%F{$color_inactive}"

    if (( added_staged_count )); then
      GIT_PROMPT_KIT_MODIFIED_STAGED+="%F{$color_staged}$added_staged_count"
      GIT_PROMPT_KIT_MODIFIED_STAGED+="$GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED"
      GIT_PROMPT_KIT_DIRTY=1
    else
      GIT_PROMPT_KIT_MODIFIED_STAGED+="${GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED_INACTIVE}"
    fi

    GIT_PROMPT_KIT_MODIFIED_STAGED+="%F{$color_inactive}"
  fi

  # Git ref status: colorize if Git status is dirty

  if [ $GIT_PROMPT_KIT_DIRTY ]; then
    GIT_PROMPT_KIT_HEAD+="%F{$color_head}"
  else
    GIT_PROMPT_KIT_HEAD+="%F{$color_inactive}"
  fi

  # Git ref status:
  #   If HEAD is detached (i.e. on a branch), show the branch.
  #     If the branch has an upstream, show how many commit behind and ahead the local is.
  #     If the upstream's remote is not the default, show it.
  #     If the upsteam has a different name from the local, show it.
  #     If both the upstream's branch and remote are shown, separate them with a slash (/)
  #   If HEAD is detached, show the commit.

  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    GIT_PROMPT_KIT_HEAD+="$GIT_PROMPT_KIT_SYMBOL_BRANCH$VCS_STATUS_LOCAL_BRANCH%F{$color_inactive}"

    if [[ -z $VCS_STATUS_REMOTE_BRANCH ]] && (( ! triangular_workflow )); then 
      GIT_PROMPT_KIT_REMOTE+="%F{$color_remote}$GIT_PROMPT_KIT_SYMBOL_LOCAL%F{$color_inactive}"
    fi

    if [[ -n $VCS_STATUS_REMOTE_BRANCH ]]; then
      if (( show_remote || show_remote_branch )); then
        if (( VCS_STATUS_COMMITS_AHEAD && ! triangular_workflow )) || (( VCS_STATUS_COMMITS_BEHIND )); then
          GIT_PROMPT_KIT_REMOTE+="%F{$color_remote}"
        fi

        if (( triangular_workflow )); then
          GIT_PROMPT_KIT_REMOTE+="$GIT_PROMPT_KIT_SYMBOL_REMOTE"
        fi
      fi

      if (( show_remote )); then
        GIT_PROMPT_KIT_REMOTE+="$VCS_STATUS_REMOTE_NAME"
      fi

      if (( show_remote && show_remote_branch )); then
        GIT_PROMPT_KIT_REMOTE+="/"
      fi

      if (( show_remote_branch )); then
        GIT_PROMPT_KIT_REMOTE+="$VCS_STATUS_REMOTE_BRANCH"
      fi

      if (( show_remote || show_remote_branch )) && (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
        GIT_PROMPT_KIT_REMOTE+="%F{$color_inactive}"
      fi

      if (( show_ahead )); then
        if (( VCS_STATUS_COMMITS_AHEAD && ! triangular_workflow )); then
          GIT_PROMPT_KIT_AHEAD+="%F{$color_remote}"
        fi

        GIT_PROMPT_KIT_AHEAD+="$GIT_PROMPT_KIT_SYMBOL_AHEAD"

        if (( VCS_STATUS_COMMITS_AHEAD )); then
          GIT_PROMPT_KIT_AHEAD+="$VCS_STATUS_COMMITS_AHEAD"
        fi

        GIT_PROMPT_KIT_AHEAD+="%F{$color_inactive}"
      fi

      if (( show_behind )); then
        if (( VCS_STATUS_COMMITS_BEHIND )); then
          GIT_PROMPT_KIT_BEHIND+="%F{$color_remote}"
        fi

        GIT_PROMPT_KIT_BEHIND+="$GIT_PROMPT_KIT_SYMBOL_BEHIND"

        if (( VCS_STATUS_COMMITS_BEHIND )); then
          GIT_PROMPT_KIT_BEHIND+="$VCS_STATUS_COMMITS_BEHIND"
        fi

        GIT_PROMPT_KIT_BEHIND+="%F{$color_inactive}"
      fi
    fi

    if (( triangular_workflow )); then
      if (( VCS_STATUS_PUSH_COMMITS_AHEAD || VCS_STATUS_PUSH_COMMITS_BEHIND )); then
        GIT_PROMPT_KIT_PUSH+="%F{$color_push_remote}"
      fi

      if [[ $VCS_STATUS_PUSH_REMOTE_NAME != $GIT_PROMPT_KIT_DEFAULT_PUSH_REMOTE_NAME ]]; then
        GIT_PROMPT_KIT_PUSH+="$GIT_PROMPT_KIT_SYMBOL_PUSH_REMOTE$VCS_STATUS_PUSH_REMOTE_NAME"
      fi

      GIT_PROMPT_KIT_PUSH+="%F{$color_inactive}"

      # push remote branch would go here

      if (( show_push_ahead )); then
        if (( VCS_STATUS_PUSH_COMMITS_AHEAD )); then
          GIT_PROMPT_KIT_PUSH_AHEAD+="%F{$color_push_remote}"
        fi

        GIT_PROMPT_KIT_PUSH_AHEAD+="$GIT_PROMPT_KIT_SYMBOL_AHEAD"

        if (( VCS_STATUS_PUSH_COMMITS_AHEAD )); then
          GIT_PROMPT_KIT_PUSH_AHEAD+="$VCS_STATUS_PUSH_COMMITS_AHEAD"
        fi

        GIT_PROMPT_KIT_PUSH_AHEAD+="%F{$color_inactive}"
      fi

      if (( show_push_behind )); then
        if (( VCS_STATUS_PUSH_COMMITS_BEHIND )); then
          GIT_PROMPT_KIT_PUSH_BEHIND+="%F{$color_push_remote}"
        fi

        GIT_PROMPT_KIT_PUSH_BEHIND+="$GIT_PROMPT_KIT_SYMBOL_BEHIND"

        if (( VCS_STATUS_PUSH_COMMITS_BEHIND )); then
          GIT_PROMPT_KIT_PUSH_BEHIND+="$VCS_STATUS_PUSH_COMMITS_BEHIND"
        fi

        GIT_PROMPT_KIT_PUSH_BEHIND+="%F{$color_inactive}"
      fi
    fi
  else
    GIT_PROMPT_KIT_HEAD+="$GIT_PROMPT_KIT_SYMBOL_COMMIT${VCS_STATUS_COMMIT[1,8]}%F{$color_inactive}"
  fi

  # Git ref status: tag
  if [[ -n $VCS_STATUS_TAG ]]; then
    GIT_PROMPT_KIT_TAG+="%F{$color_tag}$GIT_PROMPT_KIT_SYMBOL_TAG$VCS_STATUS_TAG%F{$color_inactive}"
  fi

  # Git action (e.g. rebasing)
  if [[ -n $VCS_STATUS_ACTION ]]; then
    GIT_PROMPT_KIT_ACTION+="%F{$color_action}$VCS_STATUS_ACTION%F{$color_inactive}"
  fi

  # Git "extended" status: stashes, assume-unchanged, skip-worktree

  GIT_PROMPT_KIT_STATUS_EXTENDED="${GIT_PROMPT_KIT_STASHES:+$GIT_PROMPT_KIT_STASHES}"

  if [[ -n $GIT_PROMPT_KIT_ASSUMED_UNCHANGED ]]; then
    if [[ -n $GIT_PROMPT_KIT_STATUS_EXTENDED ]]; then
      GIT_PROMPT_KIT_STATUS_EXTENDED+=${GIT_PROMPT_KIT_STATUS_EXTENDED:+ }
    fi

    GIT_PROMPT_KIT_STATUS_EXTENDED+=$GIT_PROMPT_KIT_ASSUMED_UNCHANGED
  fi

  if [[ -n $GIT_PROMPT_KIT_SKIP_WORKTREE ]]; then
    if [[ -n $GIT_PROMPT_KIT_STATUS_EXTENDED ]]; then
      GIT_PROMPT_KIT_STATUS_EXTENDED+=${GIT_PROMPT_KIT_STATUS_EXTENDED:+ }
    fi

    GIT_PROMPT_KIT_STATUS_EXTENDED+=$GIT_PROMPT_KIT_SKIP_WORKTREE
  fi

  # Git status

  GIT_PROMPT_KIT_STATUS+="${GIT_PROMPT_KIT_UNTRACKED:+$GIT_PROMPT_KIT_UNTRACKED}"

  if [[ -n $GIT_PROMPT_KIT_CONFLICTED ]]; then
    GIT_PROMPT_KIT_STATUS+=${GIT_PROMPT_KIT_STATUS:+ }
    GIT_PROMPT_KIT_STATUS+=$GIT_PROMPT_KIT_CONFLICTED
  fi

  if [[ -n $GIT_PROMPT_KIT_DELETED ]]; then
    GIT_PROMPT_KIT_STATUS+=${GIT_PROMPT_KIT_STATUS:+ }
    GIT_PROMPT_KIT_STATUS+=$GIT_PROMPT_KIT_DELETED
  fi

  if [[ -n $GIT_PROMPT_KIT_MODIFIED ]]; then
    GIT_PROMPT_KIT_STATUS+=${GIT_PROMPT_KIT_STATUS:+ }
    GIT_PROMPT_KIT_STATUS+=$GIT_PROMPT_KIT_MODIFIED
  fi

  if [[ -n $GIT_PROMPT_KIT_NEW ]]; then
    GIT_PROMPT_KIT_STATUS+=${GIT_PROMPT_KIT_STATUS:+ }
    GIT_PROMPT_KIT_STATUS+=$GIT_PROMPT_KIT_NEW
  fi

  if [[ -n $GIT_PROMPT_KIT_DELETED_STAGED ]]; then
    GIT_PROMPT_KIT_STATUS+=${GIT_PROMPT_KIT_STATUS:+ }
    GIT_PROMPT_KIT_STATUS+=$GIT_PROMPT_KIT_DELETED_STAGED
  fi

  if [[ -n $GIT_PROMPT_KIT_MODIFIED_STAGED ]]; then
    GIT_PROMPT_KIT_STATUS+=${GIT_PROMPT_KIT_STATUS:+ }
    GIT_PROMPT_KIT_STATUS+=$GIT_PROMPT_KIT_MODIFIED_STAGED
  fi

  # Git ref

  GIT_PROMPT_KIT_REF+="${GIT_PROMPT_KIT_HEAD:+$GIT_PROMPT_KIT_HEAD}"

  if [[ -n $GIT_PROMPT_KIT_REMOTE ]]; then
    GIT_PROMPT_KIT_REF+=${GIT_PROMPT_KIT_REF:+ }
    GIT_PROMPT_KIT_REF+=$GIT_PROMPT_KIT_REMOTE
  fi

  if [[ -n $GIT_PROMPT_KIT_AHEAD ]]; then
    GIT_PROMPT_KIT_REF+=${GIT_PROMPT_KIT_REF:+ }
    GIT_PROMPT_KIT_REF+=$GIT_PROMPT_KIT_AHEAD
  fi

  if [[ -n $GIT_PROMPT_KIT_BEHIND ]]; then
    GIT_PROMPT_KIT_REF+=${GIT_PROMPT_KIT_REF:+ }
    GIT_PROMPT_KIT_REF+=$GIT_PROMPT_KIT_BEHIND
  fi

  if [[ -n $GIT_PROMPT_KIT_PUSH ]]; then
    GIT_PROMPT_KIT_REF+=${GIT_PROMPT_KIT_REF:+ }
    GIT_PROMPT_KIT_REF+=$GIT_PROMPT_KIT_PUSH
  fi

  if [[ -n $GIT_PROMPT_KIT_PUSH_AHEAD ]]; then
    GIT_PROMPT_KIT_REF+=${GIT_PROMPT_KIT_REF:+ }
    GIT_PROMPT_KIT_REF+=$GIT_PROMPT_KIT_PUSH_AHEAD
  fi

  if [[ -n $GIT_PROMPT_KIT_PUSH_BEHIND ]]; then
    GIT_PROMPT_KIT_REF+=${GIT_PROMPT_KIT_REF:+ }
    GIT_PROMPT_KIT_REF+=$GIT_PROMPT_KIT_PUSH_BEHIND
  fi

  if [[ -n $GIT_PROMPT_KIT_TAG ]]; then
    GIT_PROMPT_KIT_REF+=${GIT_PROMPT_KIT_REF:+ }
    GIT_PROMPT_KIT_REF+=$GIT_PROMPT_KIT_TAG
  fi

  # Git ref: optionally prefix prompt

  (( GIT_PROMPT_KIT_HIDE_TOOL_NAMES )) || GIT_PROMPT_KIT_REF="Git $GIT_PROMPT_KIT_REF"
}

_git_prompt_kit_update_nongit() {
  emulate -L zsh

  typeset -g GIT_PROMPT_KIT_CHAR=
  typeset -g GIT_PROMPT_KIT_CWD=
  typeset -g GIT_PROMPT_KIT_USERHOST=

  local color_failed
  local color_host
  local color_inactive
  local color_succeeded
  local color_user
  local color_cwd
  local host=${(%):-%m}
  local user=${(%):-%n}
  local -a cwd_path_components
  local -i show_host
  local -i show_user

  if ! _git_prompt_kit_no_color; then
    color_failed=$GIT_PROMPT_KIT_COLOR_FAILED
    color_host=$GIT_PROMPT_KIT_COLOR_HOST
    color_cwd=$GIT_PROMPT_KIT_COLOR_CWD
    color_inactive=$GIT_PROMPT_KIT_COLOR_INACTIVE
    color_succeeded=$GIT_PROMPT_KIT_COLOR_SUCCEEDED
    color_user=$GIT_PROMPT_KIT_COLOR_USER
  fi

  # Prompt character: % if normal, # if root (has configurable colors for status code of the previous command)
  GIT_PROMPT_KIT_CHAR="%F{%(?.$color_succeeded.$color_failed)}%(!.$GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT.$GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL)%f"

  # User info
  # Show user if not a default (has configurable color)
  if ! (( $GIT_PROMPT_KIT_HIDDEN_USERS[(I)$user] )); then
    show_user=1
  fi

  # Show host if not a default (has configurable color and prefix)
  if ! (( $GIT_PROMPT_KIT_HIDDEN_HOSTS[(I)$host] )); then
    show_host=1
  fi

  if (( show_user || show_host )); then
    if (( show_user )); then
      GIT_PROMPT_KIT_USERHOST+="%F{$color_user}%n%f"
    fi

    if (( show_host )); then
      GIT_PROMPT_KIT_USERHOST+="%F{$color_host}${GIT_PROMPT_KIT_SYMBOL_HOST}%m%f"
    fi
  fi

  if [[ -n $GIT_PROMPT_KIT_REPO_ROOT ]]; then
    GIT_PROMPT_KIT_CWD="${GIT_PROMPT_KIT_REPO_ROOT}${GIT_PROMPT_KIT_REPO_SUBDIRECTORY:+/$GIT_PROMPT_KIT_REPO_SUBDIRECTORY}"
  else
    GIT_PROMPT_KIT_CWD="%F{$color_cwd}%$(( GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT + 1 ))~%f%F{$color_inactive}"
  fi
}

_git_prompt_kit_no_color() {
  local -a shell_vars
  local -i found

  shell_vars=( ${(k)parameters} )

  found=$(( ! $shell_vars[(Ie)NO_COLOR] ))

  return $found
}

_git_prompt_kit_init() {
  # if installed with Homebrew, will not have .gitmodules
  if [[ -f ${GIT_PROMPT_KIT_SOURCE_PATH}/.gitmodules && ! -f ${GIT_PROMPT_KIT_SOURCE_PATH}/gitstatus/gitstatus.plugin.zsh ]]; then
    'builtin' 'print' Finishing installing Git Prompt Kit.
    'command' 'git' submodule update --init --recursive &>/dev/null
  fi

  if ! [[ -f ${GIT_PROMPT_KIT_SOURCE_PATH}/gitstatus/gitstatus.plugin.zsh ]]; then
    'builtin' 'print' There was problem finishing installing Git Prompt Kit.
    return
  fi

  # Source local gitstatus
  # Second param is added to gitstatus function names as a suffix
  'builtin' 'source' ${GIT_PROMPT_KIT_SOURCE_PATH}/gitstatus/gitstatus.plugin.zsh $GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX

  # Start gitstatusd instance with name $GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME. The same name is passed to
  # gitstatus_query in _git_prompt_kit_update_git. The flags with -1 as values
  # enable staged, unstaged, conflicted and untracked counters.
  gitstatus_stop$GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX $GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME && gitstatus_start$GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX -s -1 -u -1 -c -1 -d -1 $GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME

  # Support colors unless user has opted out
  if ! _git_prompt_kit_no_color; then
    'builtin' 'autoload' -U colors && colors
  fi

  # On every prompt, refresh prompt content
  'builtin' 'autoload' -Uz add-zsh-hook

  add-zsh-hook precmd _git_prompt_kit_update_git
  add-zsh-hook precmd _git_prompt_kit_update_nongit

  # Perform parameter expansion, command substitution and arithmetic expansion in the prompt,
  # and treat `%` specially
  'builtin' 'setopt' prompt_subst prompt_percent
}

typeset -g GIT_PROMPT_KIT_SOURCE_PATH=${0:A:h}
_git_prompt_kit_init
