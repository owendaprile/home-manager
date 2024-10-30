{ ... }:

{
  # Enable tmux.
  programs.tmux.enable = true;

  # Old tmux configuration file.
  xdg.configFile."tmux/tmux.conf".text = ''
    ########################
    ### USABILITY TWEAKS ###
    ########################

    # Make sure tmux uses 24 bit color
    set -g default-terminal "xterm-256color"
    set -ga terminal-overrides ",*256col*:Tc"

    # Change the prefix key to ctrl+a
    unbind C-b
    set-option -g prefix C-a
    bind-key C-a send-prefix

    # Change the split commands to | and -
    unbind '"'
    unbind %
    bind | split-window -h
    bind - split-window -v

    # Reload config file
    bind r source-file ~/.tmux.conf

    # Switch panes with meta+arrow keys
    bind -n M-Left select-pane -L
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Down select-pane -D

    ## Enable mouse mode
    set -g mouse on

    # Start windows and panes at 1
    set -g base-index 1
    setw -g pane-base-index 1

    ######################
    ### DESIGN CHANGES ###
    ######################

    #set -g visual-activity off
    #set -g visual-bell off
    #set -g visual-silence off
    #setw -g monitor-activity off
    #set - bell-action none

    #setw -g clock-mode-colour colour5
    #setw -g mode-style 'fg=colour1 bg=colour18 bold'

    #set -g pane-border-style 'fg=colour19 bg=colour0'
    #set -g pane-active-border-style 'bg=colour0 fg=colour9'

    #set -g status-position top
    #set -g status-justify left
    #set -g status-style 'bg=colour235 fg=colour223 dim'
    #set -g status-left \'\'
    #set -g status-right '#[fg=colour233, bg=colour8] %H:%M:%S '
    #set -g status-right-length 50
    #set -g status-left-length 20

    #setw -g window-status-current-style 'bg=colour239 fg=colour214 bold'
    #setw -g window-status-current-format ' #I #[fg=colour255]#W#[fg=colour249]#F '

    #setw -g window-status-style 'bg=colour237'
    #setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

    #setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

    #set -g message-style 'fg=colour232 bg=colour16 bold'


    ### ME!
    set -g status-position top
    set -g status-justify left

    ### GRUVBOX?
    ## COLORSCHEME: gruvbox dark
    set-option -g status "on"

    # default statusbar color
    set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

    # default window title colors
    set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

    # default window with an activity alert
    set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

    # active window title colors
    set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

    # pane border
    set-option -g pane-active-border-style fg=colour250 #fg2
    set-option -g pane-border-style fg=colour237 #bg1

    # message infos
    set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

    # writing commands inactive
    set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

    # pane number display
    set-option -g display-panes-active-colour colour250 #fg2
    set-option -g display-panes-colour colour237 #bg1

    # clock
    set-window-option -g clock-mode-colour colour109 #blue

    # bell
    set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

    ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
    set-option -g status-justify "left"
    set-option -g status-left-style none
    set-option -g status-left-length "80"
    set-option -g status-right-style none
    set-option -g status-right-length "80"
    set-window-option -g window-status-separator ""

    set-option -g status-left "#[fg=colour248, bg=colour241] #S #[fg=colour241, bg=colour237, nobold, noitalics, nounderscore]"
    set-option -g status-right "#[fg=colour239, bg=colour237, nobold, nounderscore, noitalics]#[fg=colour246,bg=colour239] %H:%M #[fg=colour248, bg=colour239, nobold, noitalics, nounderscore]#[fg=colour237, bg=colour248] #h "

    set-window-option -g window-status-current-format "#[fg=colour237, bg=colour214, nobold, noitalics, nounderscore]#[fg=colour239, bg=colour214] #I#[fg=colour239, bg=colour214, bold] #W #[fg=colour214, bg=colour237, nobold, noitalics, nounderscore]"
    set-window-option -g window-status-format "#[fg=colour237,bg=colour239,noitalics]#[fg=colour223,bg=colour239] #I#[fg=colour223, bg=colour239] #W #[fg=colour239, bg=colour237, noitalics]"
  '';
}
