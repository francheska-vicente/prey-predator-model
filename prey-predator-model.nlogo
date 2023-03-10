breed [ coyotes coyote ] ; predator

breed [ cows cow ] ; prey

patches-own [ regrowth-time ] ; the time it takes for a plant patch to grow back

turtles-own [
  energy           ; the energy left of an agent
  happy?           ; for set-up; checks if the agent is happy (i.e., with its herd/group)
  similar-nearby   ; for set-up; checks the number of same type agent around it
  age              ; the number of ticks an agent has been active
]

; the globals are used for the monitors
globals [
  cows-eaten      ; counts the number of cows that died due to being eaten by the coyotes
  cows-no-energy  ; counts the number of cows that died due to the loss of energy
  green-patches   ; counts the number of grass patches
  dead-coyotes    ; counts the number of coyotes that died
  maturity-age    ; integer that determines if an agent is mature
]

to setup
  clear-all

  reset-ticks

  ; creates grass and randomizes the regrowth time of each patch
  ask n-of 1000 patches [
    set pcolor green
    set regrowth-time random food-regrowth-time
  ]

  ; creates the initial number of cows
  create-cows num-preys [
    set shape "cow"
    set size 1.5
    set color white
    setxy random-xcor random-ycor

    set energy random fixed-energy
    set age 0
  ]

  ; creates the initial number of cows
  create-coyotes num-predators [
    set shape "coyote"
    set size 1.5
    set color brown

    setxy random-xcor random-ycor

    set energy random fixed-energy
    set age 0
  ]

  set cows-eaten 0
  set cows-no-energy 0
  set dead-coyotes 0
  set green-patches count patches with [pcolor = green]
  set maturity-age 5

  ; the lines of code under this are used to group the agents together.
  ; coyotes hunt in groups of at least two, while cows are herded together in groups of at least five
  update-cows
  update-coyotes

  make-herd
  make-group

end

to make-herd ; this function loops until all cows are happy
  loop [
    if all? cows [ happy? ] [ stop ]
    move-unhappy-cows
    update-cows
  ]
end

to make-group ; this function loops until all coyotes are happy
  loop [
    if all? coyotes [ happy? ] [ stop ]
    move-unhappy-coyotes
    update-coyotes
  ]
end

to move-unhappy-cows ; this function moves the unhappy cows
  ask cows with [ not happy? ]
  [ find-new-spot ]
end

to find-new-spot ; this function is used by both cows and coyotes. it moves the agents into a new vacant spot
  right random-float 360
  forward random-float 10
  if any? other turtles-here [ find-new-spot ]
  move-to patch-here
end

to update-cows ; this function updates the information of the cows
  ; a happy cow is defined by the number of cow in its moore neighbors.
  ; there should be at least 2 cows around it
  ask cows [
    set similar-nearby count (cows-on neighbors)
    set happy? similar-nearby >= 2
  ]
end

to move-unhappy-coyotes ; this function moves the unhappy coyotes
  ask coyotes with [ not happy? ]
  [ find-new-spot ]
end

to update-coyotes ; this function updates the information of the coyotes
  ; a happy coyote is defined by the number of coyote in its moore neighbors.
  ; there should be 2 - 4 coyotes around it
  ask coyotes [
    set similar-nearby count (coyotes-on neighbors)
    set happy? similar-nearby >= 2 and similar-nearby <= 4
  ]
end

to go
  if ticks = 500 [stop]
  ; if there are no more coyotes and cows, then we should stop the model.
  ; if not any? coyotes or not any? cows or green-patches = 0 [ stop ]

  ask cows [
    move-cows

    eat-grass

    check-die-cows
    check-reproduce-cows

    set label precision energy 3
  ]

  ask coyotes [
    move-coyotes

    eat-cows

    check-die-coyotes
    check-reproduce-coyotes

    set label precision energy 3
  ]

  ask patches [
    regrowth
  ]

  tick
end

to move-cows
  ; this function moves cows one step forward in a random direction or moves it to a grass patch that is around it.
  ; it also subtracts the energy for the movement.

  let green_patch one-of patches in-radius 2

  ifelse green_patch != nobody
  [
    move-to green_patch
  ]
  [
    ifelse coin-flip? [right random 180] [left random 180]
    forward 1
  ]

  set energy energy - 1
end

to move-coyotes
  ; this function moves coyotes one step forward in a random direction or moves it towards a cow around it.
  ; it also subtracts the energy for the movement

  let near_cow one-of cows in-radius 2

  ifelse near_cow != nobody and distance near_cow != 0
  [
    move-to near_cow
  ]
  [
    ifelse coin-flip? [right random 180] [left random 180]
  ]

  forward 1
  set energy energy - 1
end

to eat-grass ; this function determines if there is grass in the patch where the cow is on.
             ; it also "eats" the grass and adds energy to the cow.
  if energy + add-energy-prey < fixed-energy
  [
    if pcolor = green
    [
      set pcolor black
      set energy energy + random add-energy-prey
      set green-patches green-patches - 1
    ]
  ]
end

to eat-cows ; this function determines if there is a cow near the coyote.
            ; it also lets a random cow near the coyote die and adds energy to the coyote based on the cow's energy.
            ; it also updates the global counter of the cows that die due to being eaten by a coyote.
  let mortal-peril one-of cows in-radius 0.2

  if mortal-peril != nobody
  [
    let energy2 [energy / 2] of mortal-peril

    if energy + energy2 < fixed-energy
    [
      set energy energy + energy2
      ask mortal-peril [ die ]
      set cows-eaten cows-eaten + 1
    ]
  ]

end

to regrowth ; this function determines if it is already time for a grass patch that was eaten to be regrown.
  if pcolor = black
  [
    ifelse regrowth-time <= 0
    [
      ifelse ticks >= food-regrowth-time
      [
        set pcolor green
        set regrowth-time food-regrowth-time
        set green-patches green-patches + 1
      ]
      [
        set regrowth-time 1
      ]
    ]
    [
      set regrowth-time regrowth-time - 1
    ]
  ]
end


to check-die-coyotes ; this function determines if the coyote will die at that time step due to no energy.
  ifelse energy < 0 [
    set dead-coyotes dead-coyotes + 1
    die
  ]
  [
    set age age + 1
  ]
end

to check-die-cows ; this function determines if the cow will die at that time step due to no energy.
                  ; it also updates the global counter for the cows that die due to no energy.
  ifelse energy < 0 [
    set cows-no-energy cows-no-energy + 1
    die
  ]
  [
    set age age + 1
  ]
end

to check-reproduce-cows ; this function determines if the cow will reproduce.
                        ; a cow will only reproduce if it has enough energy.
                        ; if the cow will reproduce, its energy will be divided into half.
  if random 100 <= fixed-cow-reproducing and energy >= energy-when-to-reproduce
  [
    set energy energy / 2
    hatch-cows 1 [ move-cows ]
  ]
end

to check-reproduce-coyotes ; this function determines if the coyote will reproduce.
                           ; a coyote will only reproduce if it has enough energy.
                           ; if the coyote will reproduce, its energy will be divided into half.
  if random 100 <= fixed-coyote-reproducing and energy >= energy-when-to-reproduce
  [
    set energy energy / 2
    hatch-coyotes (2 + random 4)[ move-coyotes ]
  ]
end

to-report coin-flip? ; this function returns true or false randomly
  report random 2 = 0
end
@#$#@#$#@
GRAPHICS-WINDOW
256
53
693
491
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
84
25
147
58
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
84
65
147
98
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
34
165
206
198
num-preys
num-preys
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
34
208
206
241
num-predators
num-predators
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
33
258
206
291
food-regrowth-time
food-regrowth-time
0
100
9.0
1
1
NIL
HORIZONTAL

SLIDER
33
295
207
328
fixed-energy
fixed-energy
0
1000
120.0
1
1
NIL
HORIZONTAL

SLIDER
32
345
212
378
fixed-coyote-reproducing
fixed-coyote-reproducing
0
100
5.0
1
1
NIL
HORIZONTAL

MONITOR
1301
93
1469
138
Number of Cows
count cows
17
1
11

MONITOR
1301
144
1470
189
Number of Coyotes
count coyotes
17
1
11

MONITOR
1302
193
1470
238
Number of Food (Grass)
green-patches
17
1
11

SLIDER
31
383
213
416
fixed-cow-reproducing
fixed-cow-reproducing
0
100
62.0
1
1
NIL
HORIZONTAL

SLIDER
31
437
211
470
add-energy-prey
add-energy-prey
0
20
9.0
1
1
NIL
HORIZONTAL

MONITOR
1298
308
1463
353
Cows eaten by Coyote
cows-eaten
17
1
11

MONITOR
1298
359
1465
404
Cows dead due to no Energy
cows-no-energy
17
1
11

PLOT
716
54
1266
489
total populations
count
time
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"cows" 1.0 0 -16777216 true "" "plot count cows"
"coyotes" 1.0 0 -10402772 true "" "plot count coyotes"
"grass" 1.0 0 -15040220 true "" "plot count patches with [pcolor = green]"

MONITOR
1298
414
1468
459
Coyotes that died
dead-coyotes
17
1
11

SLIDER
33
479
214
512
energy-when-to-reproduce
energy-when-to-reproduce
0
500
100.0
1
1
NIL
HORIZONTAL

SLIDER
35
123
207
156
num-grass
num-grass
0
1089
300.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

coyote
false
3
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -6459832 true true 3 188 6 233 46 159 39 187 39 199 21 220 21 242 28 254 40 254 42 247 32 236 32 224 61 200 69 192 76 203 67 222 66 237 77 248 89 256 101 256 99 246 78 233 80 225 101 201 90 178 123 184 150 186 162 182 167 194 173 207 174 221 169 231 159 236 161 246 172 245 181 232 185 223 196 239 201 254 217 255 215 244 205 236 193 209 189 183 209 172 229 153 243 138 260 139 285 145 278 135 294 134 300 128 301 129 270 114 266 100
Polygon -6459832 true true 3 189 12 175 25 164 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 242 91 255 75 256 103 270 75 269 103 277 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
