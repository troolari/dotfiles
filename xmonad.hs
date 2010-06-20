-- xmonad.hs
  -- Imports
    -- XMonad
import XMonad
    -- System
import System.IO
import System.Exit
    -- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
    -- Util
import XMonad.Util.Run
    -- Layout
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
    -- lolsorandumxd
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.List

  -- Settings
myTerminal              = "urxvtc"
myBorderWidth           = 1
myModMask               = mod4Mask
myNumlockMask           = mod2Mask
myNormalBorderColor     = "#191919" 
myFocusedBorderColor    = "#444444"
myFocusFollowsMouse     = False

    -- Dzen2
myStatusBar             = "dzen2 -x '0' -y '0' -h '14' -ta l -fn 'lime.se-9' -bg '#141414' -fg '#ffffff' -e 'onstart:lower'"

    -- Clickable Workspaces
myWorkspaces            = clickable . (map dzenEscape) $ ["eax", "ebx", "ecx", "edx"]
  where clickable l     = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" | (i,ws) <- zip [1..] l, let n = i ]

    -- ShellPrompt
myShellPrompt           = defaultXPConfig
  { font                = "-*-lime.se-*-*-normal-*-11-110-*-*-*-*-iso8859-1"
  , bgColor             = "#141414"
  , fgColor             = "#afafaf"
  , fgHLight            = "#ffffff"
  , bgHLight            = "#242424"
  , borderColor         = "#4f4f4f"
  , promptBorderWidth   = 0
  , position            = Top
  ,  height              = 15
  , defaultText         = [] }

  -- Keybindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm .|. shiftMask   , xK_Return      ), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask   , xK_c           ), kill)
    , ((modm                 , xK_space       ), sendMessage NextLayout)
    , ((modm .|. shiftMask   , xK_space       ), setLayout $ XMonad.layoutHook conf)
    , ((modm                 , xK_n           ), refresh)
    , ((modm                 , xK_Tab         ), windows W.focusDown)
    , ((modm .|. shiftMask   , xK_Tab         ), windows W.focusUp)
    , ((modm                 , xK_j           ), windows W.focusDown)
    , ((modm                 , xK_k           ), windows W.focusUp)
    , ((modm                 , xK_m           ), windows W.focusMaster)
    , ((modm                 , xK_Return      ), windows W.swapMaster)
    , ((modm .|. shiftMask   , xK_j           ), windows W.swapDown)
    , ((modm .|. shiftMask   , xK_k           ), windows W.swapUp)
    , ((modm                 , xK_h           ), sendMessage Shrink)
    , ((modm                 , xK_l           ), sendMessage Expand)
    , ((modm .|. shiftMask   , xK_h           ), sendMessage MirrorShrink)
    , ((modm .|. shiftMask   , xK_l           ), sendMessage MirrorExpand)
    , ((modm                 , xK_t           ), withFocused $ windows . W.sink)
    , ((modm                 , xK_comma       ), sendMessage (IncMasterN 1))
    , ((modm                 , xK_period      ), sendMessage (IncMasterN (-1)))
    , ((modm                 , xK_b           ), sendMessage ToggleStruts)
    , ((0                    , xK_Print       ), spawn "scrot")
    , ((modm                 , xK_p           ), shellPrompt myShellPrompt)
    , ((modm .|. shiftMask   , xK_q           ), io (exitWith ExitSuccess))
    , ((modm                 , xK_q           ), restart "xmonad" True)
    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_8]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

  -- Mousebindings
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

  -- Layouts
myLayout = avoidStruts (resizable ||| Mirror resizable ||| Grid ||| simplestFloat ||| Full) ||| noBorders  Full
  where
     tiled      = Tall nmaster delta ratio
     resizable  = ResizableTall nmaster delta ratio []
     nmaster    = 1
     ratio      = 1/2
     delta      = 3/100

  -- Floats and shifts
myManageHook = composeAll
  [ className =? "Gimp-2.6"                     --> doFloat
  , className =? "Gimp"                         --> doFloat
  , className =? "Wine"                         --> doFloat
  , className =? "Xarchiver"                    --> doCenterFloat
  , className =? "File-roller"                  --> doCenterFloat
  , title     =? "Shiretoko Preferences"        --> doCenterFloat
  , title     =? "Add-ons"                      --> doCenterFloat
  , title     =? "Install user style"           --> doCenterFloat
  , className =? "Gnome-appearance-properties"  --> doCenterFloat
  , className =? "Nitrogen"                     --> doCenterFloat
  , title     =? "Downloads"                    --> doFloat
  , resource  =? "desktop_window"               --> doIgnore
  , resource  =? "feh"                          --> doCenterFloat
  , resource  =? "kdesktop"                     --> doIgnore ]

  -- Startup
myStartupHook = return ()

  -- Execution
main = do
    dzproc <- spawnPipe myStatusBar
    xmonad $ defaultConfig {
          terminal           = myTerminal,
          focusFollowsMouse  = myFocusFollowsMouse,
          borderWidth        = myBorderWidth,
          modMask            = myModMask,
          numlockMask        = myNumlockMask,
          workspaces         = myWorkspaces,
          normalBorderColor  = myNormalBorderColor,
          focusedBorderColor = myFocusedBorderColor,
          keys               = myKeys,
          mouseBindings      = myMouseBindings,
          layoutHook         = myLayout,
          manageHook         = myManageHook,
          startupHook        = myStartupHook,
    -- Dzen2 PrettyPrinting
          logHook            = dynamicLogWithPP $ dzenPP {
                                ppOutput            = hPutStrLn dzproc
                                , ppCurrent         = wrap "^fg(#ffffff)^bg(#242424)^i(/home/jan-patrick/misc/dzen_bitmaps/has_win.xbm)" " ^fg()^bg()"
                                , ppVisible         = wrap "^fg(#ffffff)^bg(#141414)^i(/home/jan-patrick/misc/dzen_bitmaps/has_win_nv.xbm)" " ^fg()^bg()"
                                , ppHidden          = wrap "^fg(#afafaf)^bg(#141414)^i(/home/jan-patrick/misc/dzen_bitmaps/has_win_nv.xbm)" " ^fg()^bg()"
                                , ppHiddenNoWindows = wrap " ^fg(#afafaf)^bg(#141414)" " ^fg()^bg()" 
                                , ppUrgent          = dzenColor "#ff0000" "black"
                                , ppLayout          = dzenColor "#444444" "#141414" . pad .
                                    (\x -> case x of
                                            "ResizableTall" -> "^i(/home/jan-patrick/misc/dzen_bitmaps/tall.xbm)"
                                            "Mirror ResizableTall" -> "^i(/home/jan-patrick/misc/dzen_bitmaps/mtall.xbm)"
                                            "Full" -> "^i(/home/jan-patrick/misc/dzen_bitmaps/full.xbm)"
                                            "Grid" -> "^i(/home/jan-patrick/misc/dzen_bitmaps/grid.xbm)"
                                            "SimplestFloat" -> "^i(/home/jan-patrick/misc/dzen_bitmaps/float.xbm)"
                                    )
                              , ppTitle           = wrap "^fg(#afafaf)^bg(#141414) " " ^fg()^bg()" . shorten 125
                              , ppWsSep           = "^fg()^bg(#141414)"
                              , ppSep             = "^fg()^bg(#141414)"
                              }
}
