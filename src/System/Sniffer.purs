module System.Sniffer
  (isMobile, isDesktop, sniffMobile) where

import Data.String.Regex

foreign import navigator :: { userAgent :: String }

ua = navigator.userAgent

i  :: RegexFlags
i  = { global     : false
     , ignoreCase : true
     , multiline  : false
     , sticky     : false
     , unicode    : false }

sniffMobile ua = let go s = flip test ua $ regex s i
  in (go "iPhone" || go "iPod") || (go "Android" && go "mobile")

isMobile  = sniffMobile ua 
isDesktop = not isMobile