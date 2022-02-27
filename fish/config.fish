if status is-interactive
    # Commands to run in interactive sessions can go here
    set -xU PATH "$HOME/.local/bin:$HOME/bin:$PATH"
    set -xU GTK_IM_MODULE ibus
    set -xU XMODIFIERS @im ibus
    set -xU QT_IM_MODULE ibus  
end
