## strat

16 wood blocks
25 cobble stone
40 coal
4 iron
5 food
35 diamons

Iron can be found at y16 oa y232 (mountains)
Diamons y58 or y57

Get enough iron for a pickaxe, shield and bucket if possible

## give bow

```
give @s bow{Enchantments:[{id:"minecraft:power",lvl:5},{id:"minecraft:infinity",lvl:1},{id:"minecraft:unbreaking",lvl:3},{id:"minecraft:flame",lvl:1},{id:"minecraft:punch",lvl:2}]}


or hold bow while running this

/enchant @s power 5
/enchant @s infinity 1
/enchant @s unbreaking 3
/enchant @s flame 1
/enchant @s punch 2
```

## sword

`give @s netherite_sword{Enchantments:[{id:"sharpness",lvl:5},{id:"fire_aspect",lvl:2},{id:"knockback",lvl:2},{id:"unbreaking",lvl:3},{id:"mending",lvl:1}]}`

- lighting sword

`give @s netherite_sword{display:{Name:'{"text":"⚡ Mjolnir ⚡","color":"yellow","bold":true}'},Enchantments:[{id:"sharpness",lvl:5},{id:"fire_aspect",lvl:2},{id:"knockback",lvl:2},{id:"unbreaking",lvl:3}]} 1`

## trident

`give @s trident{Enchantments:[{id:"loyalty",lvl:3},{id:"impaling",lvl:5},{id:"unbreaking",lvl:3},{id:"mending",lvl:1},{id:"channeling",lvl:1}]} 1`

Channeling lighting during storms
`give @s trident{Enchantments:[{id:"loyalty",lvl:3},{id:"channeling",lvl:1},{id:"unbreaking",lvl:3},{id:"mending",lvl:1}]} 1`

## super pickaxe

`give @s netherite_pickaxe{Enchantments:[{id:"efficiency",lvl:5},{id:"fortune",lvl:3},{id:"unbreaking",lvl:3},{id:"mending",lvl:1}]} 1`

## fun items

flying elytra

`give @s elytra{Enchantments:[{id:"unbreaking",lvl:3},{id:"mending",lvl:1}]} 1`
`give @s firework_rocket 64`

dragon head
`/give @s dragon_head 1`

portable storage
`/give @s shulker_box 27`

```
all potions at once

/give @s potion{Potion:"minecraft:strength"} 1
/give @s potion{Potion:"minecraft:speed"} 1
/give @s potion{Potion:"minecraft:invisibility"} 1
/give @s potion{Potion:"minecraft:fire_resistance"} 1
```

enchanted golden apple

```
/give @s golden_apple 64
/give @s enchanted_golden_apple 64
```

## minecraft (java)

to op players after server is started

```sh
docker exec -it <docker-running-image> /bin/bash
docker exec -it <docker-running-image> rcon-cli
rcon-cli
> /list <list players>
> /op <player name>
```

## commands

F3 (fn+F3) macos shows coordinates

## guide

`iron ore y= -14`
`diamonds y= -53`
`obsidian 100, -21, 29`
