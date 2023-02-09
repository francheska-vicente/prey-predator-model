<img src="https://user-images.githubusercontent.com/75743382/217928107-e64e637d-a365-4edc-b4db-1c6a6b941711.png" height="300px"> <img src="https://user-images.githubusercontent.com/75743382/217935054-85f7d82c-85a3-41b4-90fa-a25c247a9a50.png" height="300px">


# The Cow-Coyote Relationship: A Prey-Predator Ecosystem
In the wilderness, many wild animals thrive by preying on animals who are weaker than them. An example of this is coyotes, which are fascinating omnivorous mammals with keen, clever, and intelligent tactics as predators. In the US, they are considered to be one of the most significant threats to the survival of livestock such as sheep, lamb, and cows [(Derksen, 2021)](https://www.agproud.com/articles/52864-influencing-livestock-losses-from-coyote-predation). 

In this cellular automata-based model, a prey-predator relationship will be explored through a simulation of a prairie environment littered with herds of cows and packs of coyotes to observe their natural behaviors and relationship with one another.

## Behavior of the Agents
This model has two main agents: (1) the cow and (2) the coyote. The coyotes are predators that try to eat the cows, while cows are prey that consumes grass. The grass are the green patches that can be seen in the model; unique to these patches is the inability to move, as they have only two states: eaten or not. If they are eaten, they turn black and can only be regrown after a fixed amount of time.

The behavior of both predator and prey is governed by various rules and variables which affect how they interact with their surroundings. 

The most important of these is the predetermined energy level that they must maintain to survive. All actions of an agent would reduce their energy levels by some predetermined or fixed value, though consuming their food source will replenish this energy. These two agents move around, can reproduce, and eat food, though the specifics of each are different between the two species. 

### Prey: Cow
Upon initialization of the model, cows are gathered together in a herd of at least two cows around it to represent how cows typically move in herds. 

<p align="center">
<img src="https://user-images.githubusercontent.com/75743382/217928809-dd0a737e-e9ab-4d67-a742-c3d8fe37a15d.png">
</p>

A cow wanders around the environment in search of its food source—the grass patches. As cows eat to replenish their energy, they will move toward a patch of grass if one is nearby, although moving would also cost energy. When fully satiated, the cow will stop looking for food and wander aimlessly through the field until they are hungry again.

Cows have a chance of reproducing per time step if they have enough energy to reproduce, creating one calf when they do so. However, it is essential to note that they will also lose a substantial amount of energy upon successful reproduction.

### Predator: Coyote
At setup, coyotes are in packs of two to four coyotes to represent how coyotes usually hunt large prey in packs.

<p align="center">
  <img src="https://user-images.githubusercontent.com/75743382/217929049-e5d56cff-f932-438e-bab7-7fe6f9f3dc86.png">
</p>

Coyotes consume energy moving around the environment to hunt for cows, their food source. When a cow is nearby, they move towards it in preparation to pounce, eating it in the next time step. Like the cows, they will only eat when they are hungry and wander around randomly otherwise.

They can also reproduce based on a fixed probability, and they lose half of their energy when they reproduce. Coyotes only breed once a year, and their litter is usually only composed of 2-6 pups ([Carr, 2017](https://fernandinaobserver.com/general/coyote-facts-you-should-know-1-1-more-pups/)). A random number from this range is used in the reproduction rate of the coyotes in the simulations.

## Adjustable Parameters
To fully understand how each of the components affects the system as a whole, the model has six (6) configurable parameters:
1. `num-grass` → the initial number of grass patches in the model
2. `num-preys` → the initial number of cows in the model
2. `num-predators` → the initial number of coyotes in the model
3. `food-regrowth-time` → dictates the time (in seconds) it takes for an eaten grass patch to grow 
4. `fixed-energy` → the initial energy all cows and coyotes have in the model; also the basis for a cow or coyote's satiety 
5. `fixed-coyote-reproducing` → the probability that a coyote will reproduce
6. `fixed-cow-reproducing` → the probability that a cow will reproduce
7. `add-energy-prey` → the amount of energy the cow gets from eating
8. `energy-when-to-reproduce` → the required amount of energy a cow or coyote must have to reproduce

The reproduction rate of cows is higher compared to coyotes, with cattle having a 60-70% rate while coyotes only breed once every year ([Diskin, 2016](https://doi.org/10.1016/j.theriogenology.2016.04.052); [Tokar, 2001](https://animaldiversity.org/accounts/Canis_latrans/)). The values represented in the reproduction probability are based on these studies made on coyotes and cattle.

## Things to Observe
In the model, there are some things that we can observe:
1. the **population of the cows**, which can be seen in the `Number of Cows` monitor;
2. the **population of the coyotes**, through the `Number of Coyotes` monitor;
3. the **number of available grass patches**, using the `Number of Food (Grass)` monitor;
4. the **number of cows that died by being eaten by coyotes**, via the `Cows eaten by Coyote` monitor; and
5. the **number of cows that died by lost of energy**, through the `Cows died due to no Energy` monitor.
6. the **number of coyotes that died by lost of energy**, through the `Coyotes that died` monitor.
7. the **trend of total population for cows, coyotes, and grass per tick**, through the `total populations` plot.

## How to run the model locally
1. Extract the folder from the zipped file you can download through this DownGit [link](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/francheska-vicente/prey-predator-model).
2. Once you open the folder, you can double-click the `prey-predator-model.nlogo` file to launch the model on NetLogo.

## References
Diskin, Michael & Kenny, David. (2016). *Managing the reproductive performance of beef cows*. Theriogenology. 86. 10.1016/j.theriogenology.2016.04.052.

Tokar, E. 2001. *"Canis latrans" (On-line)*, Animal Diversity Web. Accessed February 07, 2023 at https://animaldiversity.org/accounts/Canis_latrans/

Carr, J. (2017, December 10). *Coyote facts you should know: 1 – 1 = "More pups!* Fernandina Observer. https://fernandinaobserver.com/general/coyote-facts-you-should-know-1-1-more-pups/

## Members
- **Sophia Louisse L. Eguaras** <br/>
sophia_eguaras@dlsu.edu.ph
- **Andrea Jean Marcelo**  <br/>
andrea_marcelo@dlsu.edu.ph
- **Francheska Josefa Vicente**  <br/>
francheska_vicente@dlsu.edu.ph
- **Sophia Danielle S. Vista** <br/>
sophia_danielle_vista@dlsu.edu.ph
