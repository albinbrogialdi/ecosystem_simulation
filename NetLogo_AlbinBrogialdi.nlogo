breed [ladybugs ladybug]
breed [aphids aphid]
breed [ants ant]
breed [honeydews honeydew]

aphids-own [health]
ants-own [health]
ladybugs-own [health]
honeydews-own [ticks-created]

globals [
  tree-health
  prune-probability
]

to go
  move-agents
  decrease-health ; Decrease health of agents and check if not dead
  produce-honeydew
  regen-tree
  check-ant-eat-honeydew
  check-ladybug-eat-aphid
  calculate-prune-probability
  tick
  check-tree-life ; Check if the tree health is not neg or equal to 0
  spawn-new-agents ; Chance to spawn an agent regarding the rate of each slider for each agent
  decay-honeydew ; remove honeydew after 15 ticks
end

to setup
  clear-all
  import-pcolors-rgb "trunk.png"
  setup-patches
  setup-agents
  set tree-health 100
  set prune-probability 0
  reset-ticks
end

to setup-patches
  ask patches [
    if pcolor = [0 0 0] [
      set pcolor black ; for unknow reason, some [0 0 0] patches are not considered as black so we set the color manually
    ]
  ]
end

to setup-agents

  create-ladybugs num-ladybugs[
    let random-patch one-of patches with [pcolor != black]
    move-to random-patch
    set color red
    set shape "ladybug" ; custom shape
    set size 1.5
    set health 40
  ]

  create-aphids num-aphids [
    let random-patch one-of patches with [pcolor != black]
    move-to random-patch
    set color green
    set shape "bug"
    set size 0.8
    set health 20 ; can be modified to be a slider too
  ]

  create-ants num-ants [
    let random-patch one-of patches with [pcolor != black]
    move-to random-patch
    set color black
    set shape "ant"
    set health 25
  ]
end

to move-agents
  ask ants [
    let possible-moves neighbors with [pcolor != black]
    if any? possible-moves [
      move-to one-of possible-moves
      face one-of possible-moves ; the agent shape point at the direction where he is mooving to
    ]
  ]

  ask ladybugs [
    let possible-moves neighbors with [pcolor != black]
    if any? possible-moves [
      move-to one-of possible-moves
      face one-of possible-moves

    ]
  ]

  ask aphids [
    let possible-moves neighbors with [pcolor != black]
    if any? possible-moves [
      move-to one-of possible-moves
      face one-of possible-moves
    ]
  ]
end

to produce-honeydew
  ask patches with [not any? honeydews-here and any? aphids-here and random-float 1 < honeydew-production-rate] [
    sprout-honeydews 1 [
      move-to patch-here
      set color yellow
      set shape "molecule oxygen"
      set size 0.8
      set ticks-created ticks
    ]
    set tree-health tree-health - 0.5

    ask aphids-here [
      set health health + 1 ; regen aphid when creating honeydew
    ]
  ]
end

to regen-tree
  if random-float 1 < tree-health-regeneration-treshold [
    let new-tree-health tree-health + tree-health-regeneration-value
    if new-tree-health > 100 [set new-tree-health 100] ; check to not overpass 100 hp
    set tree-health new-tree-health
  ]
end

to spawn-new-agents
  if random-float 1 < spawn-rate-chance-ants [
    create-ants 1 [
      move-to one-of patches with [pcolor != black]
      set color black
      set shape "ant"
      set health 25
    ]
  ]
  if random-float 1 < spawn-rate-chance-aphids [
    create-aphids 1 [
      move-to one-of patches with [pcolor != black]
      set color green
      set shape "bug"
      set size 0.8
      set health 20
    ]
  ]
  if random-float 1 < spawn-rate-chance-ladybugs [
    create-ladybugs 1 [
      move-to one-of patches with [pcolor != black]
      set color red
      set shape "ladybug" ; custom shape
      set size 1.5
      set health 40
    ]
  ]
end

to check-tree-life
    if tree-health <= 0 [
      user-message "The tree is dead ☠️, simulation is over.\n You can retry by modifying some values to see how it goes! 😊"
      stop
  ]
end

to decrease-health
  ask ants [
    set health health - 1
    if health <= 0 [
        die
    ]
  ]
  ask ladybugs [
    set health health - 1
    if health <= 0 [
        die
    ]
  ]
  ask aphids [
    set health health - 1
    if health <= 0 [
        die
    ]
  ]
end

to check-ant-eat-honeydew
  ask ants [
    if any? honeydews-here [
      let honeydew-to-eat one-of honeydews-here
      ask honeydew-to-eat [die]
      set health health + 2
    ]
  ]
end

to check-ladybug-eat-aphid
  ask ladybugs [
    if any? aphids-here [
      let nearby-ants ants in-radius radius-ant-prevent-aphid-being-eaten
      ifelse any? nearby-ants [
        ; if ants in the radius, nothing happend
      ] [
        ; if no ants in the radius, ladybug eat the aphid
        ask aphids-here [die]
        set health health + 3
      ]
    ]
  ]
end

to decay-honeydew
  ask honeydews [
    if ticks - ticks-created >= 10 [
      die ; Delete honeydew with more tank 10 ticks
    ]
  ]
end

to calculate-prune-probability
  let aphid-activity sum [health] of aphids
  let ant-activity sum [health] of ants
  let ladybug-activity sum [health] of ladybugs
  let tree-health-factor tree-health / 100
  let prune-probability-base 0.5
  let total-activity aphid-activity + ant-activity + ladybug-activity
  let activity-factor 1 / (1 + total-activity) ; Normalization

  set prune-probability prune-probability-base -
                        (aphid-activity * 0.7 * activity-factor) -
                        (ant-activity * 0.4 * activity-factor) +
                        (ladybug-activity * 0.4 * activity-factor) +
                        (tree-health-factor * 0.5)

  if prune-probability > 1 [set prune-probability 1] ; Limit probability to 1
  output-print (word "Probability of having prunes: " precision prune-probability 2)

end
@#$#@#$#@
GRAPHICS-WINDOW
256
60
1058
766
-1
-1
24.061
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
-14
14
1
1
1
ticks
30.0

BUTTON
131
33
246
83
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
11
32
122
82
NIL
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

SLIDER
17
98
245
131
num-ladybugs
num-ladybugs
0
20
9.0
1
1
NIL
HORIZONTAL

SLIDER
17
141
247
174
num-aphids
num-aphids
0
40
21.0
3
1
NIL
HORIZONTAL

SLIDER
16
182
246
215
num-ants
num-ants
0
40
10.0
5
1
NIL
HORIZONTAL

SLIDER
16
223
247
256
honeydew-production-rate
honeydew-production-rate
0
1
0.4
0.05
1
NIL
HORIZONTAL

MONITOR
1134
124
1254
169
Current tree health
tree-health
0
1
11

SLIDER
15
265
249
298
tree-health-regeneration-treshold
tree-health-regeneration-treshold
0
1
0.65
0.05
1
NIL
HORIZONTAL

SLIDER
15
305
249
338
tree-health-regeneration-value
tree-health-regeneration-value
0
20
4.0
2
1
NIL
HORIZONTAL

MONITOR
1133
17
1273
62
Current nb of aphids
count(aphids)
17
1
11

MONITOR
1133
68
1274
113
Current nb of ladybugs
count(ladybugs)
17
1
11

MONITOR
1287
69
1430
114
Current nb of ants
count(ants)
17
1
11

SLIDER
16
348
249
381
spawn-rate-chance-ants
spawn-rate-chance-ants
0
1
0.35
0.05
1
NIL
HORIZONTAL

SLIDER
15
392
250
425
spawn-rate-chance-aphids
spawn-rate-chance-aphids
0
1
0.7
0.05
1
NIL
HORIZONTAL

SLIDER
15
435
249
468
spawn-rate-chance-ladybugs
spawn-rate-chance-ladybugs
0
1
0.25
0.05
1
NIL
HORIZONTAL

SLIDER
13
480
250
513
radius-ant-prevent-aphid-being-eaten
radius-ant-prevent-aphid-being-eaten
0
3
0.0
1
1
NIL
HORIZONTAL

OUTPUT
1281
128
1563
168
11

PLOT
1066
472
1685
765
Number of agents
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Laybugs" 1.0 0 -2674135 true "" "plot count ladybugs"
"Aphids" 1.0 0 -10899396 true "" "plot count aphids"
"Ants" 1.0 0 -16777216 true "" "plot count ants"

MONITOR
1287
15
1428
60
Current nb of honeydews
count honeydews
17
1
11

PLOT
1068
194
1683
461
Health of the tree & probability of having prunes over time
NIL
NIL
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"tree health" 1.0 1 -16777216 true "" "plot tree-health"
"prune probability" 1.0 0 -2674135 true "" "plot (prune-probability * 100)"

@#$#@#$#@
## WHAT IS IT?
This model simulates an ecosystem in which ladybirds, aphids, ants and honeydew interact with each other and with a tree. The ladybirds attack the aphids, the ants consume the honeydew and protect the aphids, and the aphids produce honeydew as they feed on the tree. The health of each species of agent affects its behaviour and interactions within the ecosystem. The overall aim is to explore how these interactions influence the health of the tree, the survival of the different agent species and the potential prunes harvest.

## HOW IT WORKS
The model works in discrete time steps, or ticks. With each tick, the agents move, their health decreases and various interactions occur according to their rules. Ladybirds, ants and aphids move randomly through the environment, consuming resources and affecting the health of the tree. Aphids produce honeydew, which decomposes over time or is eaten by ants. This whole ecosystem and their interactions influence the health of the tree and its ability to produce fruit.


## HOW TO USE IT
- **setup**: Initializes the model with the specified number of agents and sets the initial tree health.

- **go**: Runs the simulation continuously, with agents moving, interacting, and the tree's health being affected.

- **num-ladybugs**: This variable determines the initial number of ladybug agents created in the simulation. Ladybugs are predatory insects that feed on aphids.

- **num-aphids**: This variable specifies the initial number of aphid agents generated in the model. Aphids are small insects that feed on plant sap and produce honeydew.

- **num-ants**: Indicates the initial quantity of ant agents in the ecosystem. Ants consume honeydew produced by aphids.

- **honeydew-production-rate**: Determines the probability of aphids producing honeydew while feeding on the tree. A higher value increases the likelihood of honeydew production.

- **tree-health-regeneration-treshold**: Represents the threshold probability for tree health regeneration. If a randomly generated value is less than this threshold, the tree's health will regenerate.

- **tree-health-regeneration-value**: Specifies the amount by which the tree's health regenerates when triggered. This value is added to the current tree health if regeneration occurs. If this would go over 100 health, health is setted to 100.

- **spawn-rate-chance-ants**: Sets the probability of spawning new ant agents during each simulation step. A higher value increases the likelihood of new ants being added to the ecosystem.

- **spawn-rate-chance-aphids**: Controls the likelihood of spawning additional aphid agents in the model. A higher value increases the chances of new aphids appearing.

- **spawn-rate-chance-ladybugs**: Determines the probability of creating new ladybug agents during each simulation iteration. Higher values result in more frequent appearances of ladybugs in the ecosystem.

- **radius-ant-prevent-aphid-being-eaten**: Defines the distance within which the presence of ants prevents ladybugs from eating aphids. Ladybugs will not consume aphids if ants are within this radius, simulating interference by ants with ladybug predation.


## THINGS TO NOTICE
Observe how the health of the tree changes over time based on the interactions between agents.
Notice the balance between predator-prey interactions and the overall ecosystem dynamics.
If the tree's life falls below 0, the modelling stops. Too many aphids or an excessively high honeydew-production-rate can cause the experiment to stop prematurely.

The way in which the probability of having prunes is calculated is totally arbitrary and does not reflect real probabilities. It is calculated as a function of the number of agents of each type, an associated weight and the number of life points of the tree. 


## THINGS TO TRY
Experiment with different initial settings to observe their effects on the ecosystem and the prune probability.
Manipulate the spawn rates of ants, aphids, and ladybugs to see how it impacts the ecosystem's stability.
Change the radius of effect for ants on aphid behing taht could be eaten by ladybugs to study their influence on the ecosystem.

## EXTENDING THE MODEL
Introduce additional environmental factors such as weather conditions or habitat changes that affect agent behavior and tree health.
Implement more complex predator-prey interactions or introduce new species to the ecosystem.
Incorporate spatial dynamics by allowing agents to interact differently based on their proximity to each other or to specific patches.
Changes the number of hit points recovered by eating prey for each predator, or the number of life points lost per tick when moving.

## NETLOGO FEATURES
This model utilizes NetLogo's breed feature to define different types of agents (ladybugs, aphids, ants, honeydews).
It also utilizes patches to represent the environment, where agents interact and affect the tree's health.
A picture is used as background to set up the model environment.

## RELATED MODELS
Wolf Sheep Predation: Explores predator-prey dynamics in a simple ecosystem.
Virus Spread: Simulates the spread of a virus within a population.

## CREDITS AND REFERENCES
Model created by Albin Brogialdi.
Thanks to [@deanreese3252](https://www.youtube.com/@deanreese3252/videos) for all the Youtube quality material and other various internet ressources.
Many thanks to my father for the explanation between all the agents (scenario based on a real situation in his permaculture garden).
I agree with sharing this project with future students.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

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

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

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

ladybug
true
0
Rectangle -2674135 true false 75 120 240 210
Rectangle -2674135 true false 90 105 225 120
Rectangle -2674135 true false 90 210 225 225
Rectangle -2674135 true false 105 225 210 240
Rectangle -16777216 true false 105 120 135 150
Rectangle -16777216 true false 180 120 210 150
Rectangle -16777216 true false 195 165 225 195
Rectangle -16777216 true false 90 165 120 195
Rectangle -16777216 true false 120 210 135 225
Rectangle -16777216 true false 180 210 195 225
Rectangle -2674135 true false 120 240 195 255
Rectangle -16777216 true false 150 105 165 255
Rectangle -16777216 true false 105 90 210 105
Rectangle -16777216 true false 120 75 195 90
Rectangle -16777216 true false 135 60 180 75
Rectangle -16777216 true false 180 45 195 60
Rectangle -16777216 true false 120 45 135 60
Rectangle -16777216 true false 240 105 255 120
Rectangle -16777216 true false 60 105 75 120
Rectangle -16777216 true false 60 165 75 180
Rectangle -16777216 true false 240 165 255 180
Rectangle -16777216 true false 75 225 90 240
Rectangle -16777216 true false 225 225 240 240

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

molecule oxygen
true
0
Circle -7500403 true true 120 75 150
Circle -16777216 false false 120 75 150
Circle -7500403 true true 30 75 150
Circle -16777216 false false 30 75 150

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
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
