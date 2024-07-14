## HOW TO USE
Download the model AND the file trunk.png otherwise an error will be raised. I recommend to used the [NetLogo](https://ccl.northwestern.edu/netlogo/download.shtml) software because some of the packages are not usable with the web interface.

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
