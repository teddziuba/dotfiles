import XMonad
import XMonad.Operations
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Actions.CycleWS
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Layout.WindowNavigation
import XMonad.Actions.WindowGo
import System.IO

myManageHook = composeAll
             [ className =? "Gimp" --> doFloat]
myWorkspaces = ["code", "shell", "browser", "chat", "beats", "vm", "etc"]

main = do
     xmproc <- spawnPipe "/usr/bin/xmobar /home/ted/.xmobarrc"
     xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
            { manageHook = manageDocks <+> myManageHook
                                       <+> manageHook defaultConfig
            , layoutHook = avoidStruts $ windowNavigation(layoutHook defaultConfig)
            , startupHook = setWMName "LG3D"
            , logHook = dynamicLogWithPP xmobarPP
                      { ppOutput = hPutStrLn xmproc
                      , ppTitle = xmobarColor "green" "" . shorten 50
                      , ppUrgent = xmobarColor "yellow" "red"
                      }
            , modMask = mod4Mask
            , terminal = "gnome-terminal --hide-menubar"
            , workspaces = myWorkspaces
            }
            `additionalKeysP`
            [ ("M-p", spawn "gmrun")
            , ("M-z", spawn "xscreensaver-command -lock")
            , ("M-r", spawn "refresh-chrome")
            , ("M-<R>", nextScreen)
            , ("M-<L>", prevScreen)
            , ("M-S-<L>", sendMessage $ Go L)
            , ("M-S-<R>", sendMessage $ Go R)
            , ("M-S-<U>", sendMessage $ Go U)
            , ("M-S-<D>", sendMessage $ Go D)
            , ("M-u", focusUrgent)
            ]