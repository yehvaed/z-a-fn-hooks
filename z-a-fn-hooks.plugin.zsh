# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
#
# Standardized $0 handling
# https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

hooks=(atinit atload atpull atclone)

.za-fn-hooks---hook---handler() {
  builtin emulate -L zsh ${=${options[xtrace]:#off}:+-o xtrace}
  builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

  [[ "$1" = plugin ]] && \
  local type="$1" user="$2" plugin="$3" id_as="$4" dir="$5" || \
  local type="$1" url="$2" id_as="$3" dir="$4"

  if typeset -f "--hook--" > /dev/null;  then
    pushd -q $dir
    
    "--hook--"
    unset -f "--hook--"
    
    popd -q
  fi
}

# An empty stub to fill the help handler fields
.za-fn-hooks-null-handler() { :; }

for hook in ${hooks[*]};do
  eval "$(typeset -f .za-fn-hooks---hook---handler | sed "s/--hook--/$hook/g")"

  @zi-register-annex "z-a-fn-hooks" hook:$hook-1 \
    ".za-fn-hooks-$hook-handler" \
    ".za-fn-hooks-null-handler"
done

unset -f .za-fn-hooks---hook---handler
