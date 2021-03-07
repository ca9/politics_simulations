breed [peeps peep]
breed [govprops govprop]
peeps-own [internal_pref external_pref buddies rebelling]
globals [external_pref_init_mean external_pref_init_max]

to setup
  clear-all
  create-peeps (population_density / 100) * (max-pycor - min-pycor) * (max-pxcor - min-pxcor)
  create-govprops propagandists
  randomize-init-turtles
  ask patches [
    set pcolor 9
  ]
  reset-ticks
end

to randomize-init-turtles
  ask peeps [
    set shape "circle"
    set internal_pref min(list max (list 0 random-normal internal_pref_mean internal_pref_sd) 100)
    let deviated random-normal internal_pref external_pref_sd
    set external_pref min(list
      ifelse-value deviated < internal_pref [internal_pref + ( internal_pref - deviated )] [ deviated ]
      100
    )
    set xcor (random 41) - 20
    set ycor (random 41) - 20
    set color 99.9 - (external_pref - internal_pref) / 10
    rebel-check
  ]
  set external_pref_init_mean mean [external_pref] of peeps
  set external_pref_init_max max [external_pref] of peeps
end

to go
  ask peeps [
    fd 0.5            ;; forward 1 step
    rt random 10    ;; turn right
    lt random 10    ;; turn left
    set buddies (other peeps) in-radius buddy-radius
    check-social-influence
    ;; show patch-here
    rebel-check
  ]
  color-check
  propaganda-spread
  tick
end

to check-social-influence
  drop-in-pref-social
  ;; let vicinity_pref min(list
  ;;  (ifelse-value (any? buddies)
  ;;    [external_pref + (mean([external_pref] of buddies) - external_pref) * transmission / 100]
  ;;    [external_pref])
  ;;  external_pref
  ;;)
  ;;set external_pref max(list internal_pref vicinity_pref)
end

to drop-in-pref-social
  let casual_drop 0
  let rebel_drop 0
  let divisor 200
  if (rebelling = true) [
    set divisor divisor * rebel_hardiness
  ]

  if (any? buddies with [rebelling = false]) [
    set casual_drop (external_pref - mean([external_pref] of buddies with [rebelling = false])) * transmission / divisor
  ]
  let near-rebels (other peeps with [rebelling = true]) in-radius propaganda-radius
  if (any? near-rebels) [
    set rebel_drop (external_pref - mean([external_pref] of near-rebels)) * transmission / divisor
  ]
  ;; show casual_drop
  ;; show rebel_drop
  ;; let social_pref min(list external_pref (external_pref - casual_drop))
  let social_pref min(list external_pref (external_pref - rebel_drop - casual_drop))
  if (social_pref > internal_pref)[
    ;; show external_pref - social_pref
    ;; show (list ticks external_pref internal_pref social_pref (external_pref - social_pref))
  ]
  set external_pref max(list social_pref internal_pref)
end

to propaganda-spread
  ask patches [set pcolor 9]
  if propagandists != count govprops [
    ask govprops [die]
    create-govprops propagandists
  ]
  ask govprops [
    fd 1
    rt random 10
    lt random 10
    let around-me peeps in-radius propaganda-radius
    set around-me peeps with [rebelling = false]
    let around-me-patches patches in-radius propaganda-radius
    ask around-me-patches [set pcolor yellow + 3]
    ask around-me [
      set external_pref min(list
        (external_pref * (1.0 + (random-normal (prop-power / 1000) 0.001)))
        100
      )
    ]
  ]
end


to color-check
  ifelse color_scheme = "difference" [
    ask peeps [set color 99.9 - (external_pref - internal_pref) / 10]
  ] [
    let scale external_pref_init_max - rebel_threshold
    ask peeps [
      let mypath external_pref - rebel_threshold
      set color 15 + 5 * (mypath / scale)
    ]
  ]
end

to rebel-check
  ifelse external_pref < rebel_threshold [
    set shape "x"
    set rebelling true
  ] [
    set shape "circle"
    set rebelling false
  ]
  if internal_pref < rebel_threshold [
    if (
      ((external_pref - internal_pref) > 2 * internal_pref_sd) and
      (random 100 < freedom_fighter_chance)
      ) [
      set rebelling true
      set external_pref rebel_threshold
      show "freedom fighter created"
    ]
  ]
end
;;histogram [ ( external_pref - internal_pref ) ] of turtles


to draw-polygon [num-sides len]  ;; turtle procedure
  pen-down
  repeat num-sides [
    fd len
    rt 360 / num-sides
  ]
end
;; invoke as ask turtles [ draw-polygon 8 who ]


to-report absolute-value [number]
  ifelse number >= 0
    [ report number ]
    [ report (- number) ]
end

to swap-colors [turtle1 turtle2]
  let temp [color] of turtle1
  ask turtle1 [ set color [color] of turtle2 ]
  ask turtle2 [ set color temp ]
end


;to test
;  ;; all other turtles:
;  other turtles
;  ;; all other turtles on this patch:
;  other turtles-here
;  ;; all red turtles:
;  turtles with [color = red]
;  ;; all red turtles on my patch
;  turtles-here with [color = red]
;  ;; patches on right side of view
;  patches with [pxcor > 0]
;  ;; all turtles less than 3 patches away
;  turtles in-radius 3
;  ;; the four patches to the east, north, west, and south
;  patches at-points [[1 0] [0 1] [-1 0] [0 -1]]
;  ;; shorthand for those four patches
;  neighbors4
;  ;; turtles in the first quadrant that are on a green patch
;  turtles with [(xcor > 0) and (ycor > 0)
;    and (pcolor = green)]
;  ;; turtles standing on my neighboring four patches
;  turtles-on neighbors4
;  ;; all the links connected to turtle 0
;  [my-links] of turtle 0
;
;
;  ;Or tell a randomly chosen patch to sprout a new turtle:
;  ask one-of patches [ sprout 1 ]
;
;  ; Create set of turtles :g: from global, with input (here, turtles)
;  set g turtle-set turtles
;end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
751
552
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
-20
20
-20
20
1
1
1
ticks
30.0

BUTTON
14
17
76
50
Setup
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
13
58
76
91
Run
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
15
118
187
151
population_density
population_density
0
80
20.0
5
1
NIL
HORIZONTAL

SLIDER
14
157
187
190
internal_pref_mean
internal_pref_mean
0
100
28.0
1
1
NIL
HORIZONTAL

SLIDER
16
196
188
229
internal_pref_sd
internal_pref_sd
0
internal_pref_mean
18.0
1
1
NIL
HORIZONTAL

PLOT
36
566
753
740
Preferences Plot
NIL
NIL
0.0
100.0
0.0
1.0
true
true
"" ""
PENS
"Internal" 5.0 0 -16777216 true "" "histogram [internal_pref] of peeps"
"External" 5.0 0 -14439633 true "" "histogram [external_pref] of peeps"
"Initial External" 5.0 0 -8990512 true "histogram [external_pref] of peeps" ""
"Initial External Mean" 0.0 1 -8990512 false "" "plot-pen-reset\nplotxy external_pref_init_mean plot-y-max"
"External Mean" 0.0 1 -14439633 false "" "plot-pen-reset\nplotxy mean [external_pref] of peeps plot-y-max\n"
"Internal Pref Mean" 0.0 1 -16777216 false "plotxy mean [internal_pref] of peeps plot-y-max * 1.4" ""
"Rebel Threshold" 0.0 1 -2674135 true "" "plot-pen-reset\nplotxy rebel_threshold plot-y-max"

SLIDER
17
266
189
299
external_pref_sd
external_pref_sd
0
2 * internal_pref_mean
30.0
1
1
NIL
HORIZONTAL

CHOOSER
32
363
170
408
color_scheme
color_scheme
"difference" "likely_rebel"
1

SLIDER
19
415
199
448
rebel_threshold
rebel_threshold
ifelse-value (any? peeps) [min([internal_pref] of peeps)] [0]
ifelse-value (any? peeps) [max( [external_pref] of peeps )] [50]
14.0
1
1
NIL
HORIZONTAL

MONITOR
37
516
178
561
Percentage Rebelling
100 * count peeps with [rebelling = true] / count peeps
2
1
11

SLIDER
16
312
188
345
transmission
transmission
0
50
10.0
1
1
NIL
HORIZONTAL

MONITOR
37
468
160
513
External Pref Avg.
mean [external_pref] of peeps
2
1
11

PLOT
38
746
754
947
Rebellion Over Time
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
"% Rebel" 1.0 0 -2674135 true "" "plot 100 * count peeps with [rebelling = true] / count peeps"
"Mean External Pref" 1.0 0 -13840069 true "" "plot mean [external_pref] of peeps"
"Mean Internal Pref" 1.0 0 -16777216 true "" "plot mean [internal_pref] of peeps"
"Rebellion Threshold" 1.0 0 -1604481 true "" "plot rebel_threshold"

SLIDER
761
11
933
44
buddy-radius
buddy-radius
0
5
1.0
1
1
NIL
HORIZONTAL

SLIDER
762
53
934
86
propaganda-radius
propaganda-radius
1
20
9.0
1
1
NIL
HORIZONTAL

SLIDER
761
93
933
126
propagandists
propagandists
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
761
132
933
165
prop-power
prop-power
0
100
11.0
1
1
NIL
HORIZONTAL

SLIDER
761
176
929
209
freedom_fighter_chance
freedom_fighter_chance
0
50
10.0
1
1
NIL
HORIZONTAL

TEXTBOX
82
29
232
47
Click me first!
11
0.0
1

SLIDER
761
214
933
247
rebel_hardiness
rebel_hardiness
0
10
4.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This is a model showcasing Kuran's Cascade Theory (1991), developed by Aditya Gupta (School of Public Policy, London School of Economics - 2021).

Please enjoy the model under [this link](https://www.netlogoweb.org/launch#https://raw.githubusercontent.com/ca9/politics_simulations/master/prop.nlogo).

## HOW IT WORKS

We observe a map full of people or "peeps" (after hitting "Setup"), each with their own private and public preference for their current government. Upon hitting "Run" a simulation begins where the agents move, interact, and thus influence each other's public preferences on the bases of chosen parameters.

The logic is this: If the "external preference" of peeps falls below the rebellion threshold, they are actively "rebelling" - and marked as "X" check marks. 

The charts show distributions of these attributes and key statistics of the population.

There are two color schemes: 
1. "difference" showcases the quantified difference of their preferences with increasingly darker shades of blue. 

2. The "likely_rebel" scheme shows the difference between their rebellion threshold, and their actual external preference. 


## HOW TO USE IT

* Please start by pressing "Setup" to set (or reset) the map. 
You observe people (called "peeps" in the code) spread out over a region - the map.

* The "Run" button begins and pauses the simulation.

* The first 3 sliders help choose a population density, an approximate a normal distribution by choosing a mean and standard distribution for an internal preferences.
**Internal Preferences are constant over each run**.


* The **external preference for every agent is higher than their own internal preference** in this simulation. The distance from internal preference is also normally distributed, with standard deviation **external_pref_sd**. Increase this slider to create a wider gap between internal and external preferences at setup time.

* The distance at which peeps remain influenced by external opinions of their neighbours is controlled by **"buddy-radius"**. The external preferences of "buddies" can have a bidirectional effect on peeps.

* **transmission** determines the level to which peeps and rebels are influenced by their neighbours (buddies) and rebels around them.

* The **propaganda-radius** on the right shows the radius of influence of **rebels as well as propagandists**. They typically are "noisier" elements in the and send their message "farther" than "buddies", or people near a peep. 

* The **rebel_threshold** determines the point of external preference which an agent starts to "rebel". External preference must exceed internal preference here, so agents with internal preference over the rebel_threshold will not rebel. You can move this in simulation-time.

* **propagandists** introduces agents spreading propaganda and forcing an increase in "external preference" of people around. Rebels are oblivious to this effect, and only respond to public around them. Even so, they remain hardy. Their resistence to influence is a multiplicative factor of **"rebel_hardiness"**.

* **prop-power** determines the power of the propaganda and can be moved in realtime.

* Finally, we have the *freedom-fighter-chance*. If an agent's external_preference is forced to exceed her internal preference by twice its standard deviation (a level that their internal preference had only <5% chance of reaching), and their internal preference is below the rebellion threshold, then they experience a **freedom-fighter-chance** % probability of immediately rebelling (and external preference reaching rebellion threshold). 


## THINGS TO NOTICE

* The first observation should be that under most conditions, without propaganda (or penalty), the external preference approaches the internal preference over time. The rate of transmission directly influences this.

* Introduction of propagandists (or proxy for government/policing agents) directly starts increasing external preference. A key finding is that with enough propagandists and power (and low freedom-fighter chance), the external preference may **irrepairably** reach very high values, such that it may never be restored. This is a shout to **Pluralistic Ignorance**, or _“The lie”_ (Alexander Solzhenitsyn, 1970).

* The starting conditions and the history of the simulation matter a lot in terms of determining the outcomes and responses. Mean and standard deviation of preferences do not completely represent underlying distributions which could be deeply fractured. The same "rebellion percentage" could be representative of vastly different scenarios.


## EXTENDING THE MODEL / KNOWN CAVEATS

The model obviously makes a lot of oversimplifying assumptions, not the least of which is the idea that there is a consistent rebellion threshold across the population (this in fact is in direct conflict with Kuran's theories).

Furthermore, the values and their effects are synthetic at best.

Viewers are welcome to copy, modify, and extend and refine the code to suit their needs. The code is open-sourced as per MIT license attached below.

## NETLOGO FEATURES

A key caveat of netlogo is that the world-state is evaluated synchronously per tick. This means that the agents/peeps are updated in some given sequence, rather than "asynchronously" or concurrently, in a true "continuous" sense as would happen in reality. Nevertheless, this does not deter from the insights available from this.

## CREDITS AND REFERENCES

Please enjoy the model under [this link](https://www.netlogoweb.org/launch#https://raw.githubusercontent.com/ca9/politics_simulations/master/prop.nlogo).

This work has been inspired by:

### Now Out of Never: The Element of Surprise in the East European Revolution of 1989

#### Metadata

* Item Type: Article
* Authors: Timur Kuran
* Date: 1991
* URL: [https://www.jstor.org/stable/2010422](https://www.jstor.org/stable/2010422)
* DOI: [10.2307/2010422](https://doi.org/10.2307/2010422)

#### Abstract

Like many major revolutions in history, the East European Revolution of 1989 caught its leaders, participants, victims, and observers by surprise. This paper offers and explanation whose crucial feature is a distinction between private and public preferences. By suppressing their antipathies to the political status quo, the East Europeans misled everyone, including themselves, as to the possibility of a successful uprising. In effect, they conferred on their privately despised governments an aura of invincibility. Under the circumstances, public opposition was poised to grow explosively if ever enough people lost their fear of exposing their private preferences. The currently popular theories of revolution do not make clear why uprisings easily explained in retrospect may not have been anticipated. The theory developed here fills this void. Among its predictions is that political revolutions will inevitably continue to catch the world by surprise.

## MIT License

Copyright (c) [2021] [Aditya Gupta, agupta42@lse.ac.uk]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
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
NetLogo 6.2.0
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
