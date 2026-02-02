##

-- dynamically set SpellQueueWindow

```
/run local _,_,_,lag = GetNetStats() local tol = 100 SetCVar("SpellQueueWindow", lag + tol) print("SpellQueue set to ".. (lag + tol) .." (Ping: ".. lag ..")")


-- this should be latency + 120
/run SetCVar("SpellQueueWindow", 200)

-- set max Zoom, fix mouse in macos, set max distance to render nameplates
/run SetCVar("Sound_NumChannels", 128); SetCVar("cameraDistanceMaxZoomFactor", 2.6); SetCVar("rawMouseEnable", 1); SetCVar("nameplateMaxDistance", 60)

```

# hunter

Prioritize mouse over targets

reference: `https://huntsmanslodge.com/9392/hunter-macros-for-pvp/`

```
-- nearest target
/cleartarget
/targetenemy [noexists][dead]
/cast Concusive Shot

-- trinkets
/use 13 or /use 14

-- Feign Death
#showtooltip Feign Death
/stopcasting
/stopattack
/cast Feign Death

--- Misdirection
#showtooltip Misdirection
/cast [@focus,help,nodead] [@pet,nodead] [] Misdirection

-- Master's Call
#showtooltip Master's Call
/cast [@mouseover,help,nodead] [@player] Master's Call

-- trap launchers, at cursor, alt for alternate trap
#showtooltip
/cast [mod:alt,@cursor] Explosive Trap; [@cursor]Frost Trap

-- Kill Shot
#showtooltip Kill Shot
/cast [@mouseover,harm,nodead] [] Kill Shot

-- healthstone first, or potion if hs is missing
/use Healthstone
/use Runic Healing Potion
# /script UIErrorsFrame:Clear() ? is this useful any more?


-- single macros
/cast [@mouseover,harm,nodead][harm] Silencing Shot
/cast [@mouseover,harm,nodeada][harm] Scatter Shot

-- cast over friendly if mouse over, or self
/cast [@mouseover,help][@player] Intervene
/cast [@mouseover,help][@player] Roar of Sacrifice
/cast [@mouseover,help][@player] Master's Call

/cast [@mouseover,help,nodead] [@player] Word of Glory
/cast [@mouseover,help,nodead] [@player] Flash of Light

-- death grip
#showtooltip
/cast [@mouseover,harm,nodead] [] Death Grip

-- flare
/cast !Flare

-- manual spirit mend in pvp
/cast [@mouseover,help][@player] Spirit Mend
/script UIErrorsFrame:Clear()


-- ks
/cancelaura Deterrence
/cancelaura Hand of Protection
/cast Kill Shot

-- rapid fire
/use 14
/cast Rapid Fire
/cast Call of the Wild
/script UIErrorsFrame:Clear()

-- aspect
/cast [mod:alt] !Aspect of the Wild; Aspect of the Hawk
/cast Aspect of the Fox

-- pet
/petpassive
/petfollow
/cast [mod:alt] Dash
/cast [mod:shift] Dismiss Pet
/script UIErrorsFrame:Clear()

or

-- if pet is not in LoS, hold shift
/cast [mod:alt] Call Pet 2
/cast [@pet,dead][mod:shift] Revive Pet; [nopet] Call Pet 1; Mend Pet

```
