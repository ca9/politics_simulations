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