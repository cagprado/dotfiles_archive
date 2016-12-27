-------------------------------
--  "caio" awesome theme     --
--  based on "Zenburn"       --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.wallpaper = {}
theme.wallpaper[1] = "/home/cagprado/usr/img/wallpaper/bird.jpg"
theme.wallpaper[2] = "/home/cagprado/usr/img/wallpaper/bird.jpg"
-- }}}

-- {{{ Styles
theme.font      = "Nova Oval 8"
theme.monofont  = "terminalfont 8"

-- {{{ Colors
theme.fg_normal  = "#888899"
theme.fg_focus   = "#00b11b"
theme.fg_urgent  = "#ff3333"
theme.bg_normal  = "#000000"
theme.bg_focus   = "#000000"
theme.bg_urgent  = "#000000"

theme.bg_systray = theme.bg_normal
theme.bg_widget  = "#222222"
theme.fg_widget  = "#2672ff"
theme.fg_widget_alt  = "#00c0ff"
-- }}}

-- {{{ Borders
theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#2672ff"
theme.border_marked = "#00b11b"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 16
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/home/cagprado/.config/awesome/themes/caio/taglist/squarefz.png"
theme.taglist_squares_unsel = "/home/cagprado/.config/awesome/themes/caio/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/home/cagprado/.config/awesome/themes/caio/awesome-icon.png"
theme.menu_submenu_icon      = "/home/cagprado/.config/awesome/themes/caio/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/home/cagprado/.config/awesome/themes/caio/layouts/tile.png"
theme.layout_tileleft   = "/home/cagprado/.config/awesome/themes/caio/layouts/tileleft.png"
theme.layout_tilebottom = "/home/cagprado/.config/awesome/themes/caio/layouts/tilebottom.png"
theme.layout_tiletop    = "/home/cagprado/.config/awesome/themes/caio/layouts/tiletop.png"
theme.layout_fairv      = "/home/cagprado/.config/awesome/themes/caio/layouts/fairv.png"
theme.layout_fairh      = "/home/cagprado/.config/awesome/themes/caio/layouts/fairh.png"
theme.layout_spiral     = "/home/cagprado/.config/awesome/themes/caio/layouts/spiral.png"
theme.layout_dwindle    = "/home/cagprado/.config/awesome/themes/caio/layouts/dwindle.png"
theme.layout_max        = "/home/cagprado/.config/awesome/themes/caio/layouts/max.png"
theme.layout_fullscreen = "/home/cagprado/.config/awesome/themes/caio/layouts/fullscreen.png"
theme.layout_magnifier  = "/home/cagprado/.config/awesome/themes/caio/layouts/magnifier.png"
theme.layout_floating   = "/home/cagprado/.config/awesome/themes/caio/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/home/cagprado/.config/awesome/themes/caio/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/home/cagprado/.config/awesome/themes/caio/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = "/home/cagprado/.config/awesome/themes/caio/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = "/home/cagprado/.config/awesome/themes/caio/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = "/home/cagprado/.config/awesome/themes/caio/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = "/home/cagprado/.config/awesome/themes/caio/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = "/home/cagprado/.config/awesome/themes/caio/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = "/home/cagprado/.config/awesome/themes/caio/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = "/home/cagprado/.config/awesome/themes/caio/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = "/home/cagprado/.config/awesome/themes/caio/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = "/home/cagprado/.config/awesome/themes/caio/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = "/home/cagprado/.config/awesome/themes/caio/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = "/home/cagprado/.config/awesome/themes/caio/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/home/cagprado/.config/awesome/themes/caio/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = "/home/cagprado/.config/awesome/themes/caio/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/home/cagprado/.config/awesome/themes/caio/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/home/cagprado/.config/awesome/themes/caio/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/home/cagprado/.config/awesome/themes/caio/titlebar/maximized_normal_inactive.png"
-- }}}

-- {{{ Widgets
theme.widget_cpu = "/home/cagprado/.config/awesome/themes/caio/widgets/cpu.png"
theme.widget_mem = "/home/cagprado/.config/awesome/themes/caio/widgets/mem.png"
theme.widget_net = "/home/cagprado/.config/awesome/themes/caio/widgets/down.png"
theme.widget_netup = "/home/cagprado/.config/awesome/themes/caio/widgets/up.png"
theme.widget_boot = "/home/cagprado/.config/awesome/themes/caio/widgets/boot.png"
theme.widget_root = "/home/cagprado/.config/awesome/themes/caio/widgets/root.png"
theme.widget_home = "/home/cagprado/.config/awesome/themes/caio/widgets/home.png"
theme.widget_hd = "/home/cagprado/.config/awesome/themes/caio/widgets/hd.png"
theme.widget_win = "/home/cagprado/.config/awesome/themes/caio/widgets/win.png"
theme.widget_cdrom = "/home/cagprado/.config/awesome/themes/caio/widgets/cdrom.png"
theme.widget_pen = "/home/cagprado/.config/awesome/themes/caio/widgets/pen.png"
theme.widget_mpd = "/home/cagprado/.config/awesome/themes/caio/widgets/mpd.png"
theme.widget_mail = "/home/cagprado/.config/awesome/themes/caio/widgets/mail.png"
theme.widget_mailerror = "/home/cagprado/.config/awesome/themes/caio/widgets/mailerror.png"
-- }}}
-- }}}

return theme
