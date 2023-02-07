# The Cow-Coyote Relationship: A Prey-Predator Ecosystem
In the wilderness, wild animals thrive by preying on animals placed lower than them in the food chain. Coyotes are interesting mammals with their keen, clever, and smart tactics as predators. In the US, they are considered to be one of the largest threats to the survival of livestock such as sheep, lamb, and cows [(Derksen, 2021)](https://www.agproud.com/articles/52864-influencing-livestock-losses-from-coyote-predation). In this cellular automata-based model, a prey-predator relationship will be explored through a simulation of a prairie environment littered with herds of cows and coyotes to observe their behavior and relationship with one another.

## Behavior of the Agents
In this model, there are two main agents: (1) the cow, and (2) the coyote. The coyotes are the a predator that tries to eat the cows, while cows are the preys that eats grass. 

The grass are the patches of green that can be seen in the model. If they are eaten, then they turn into the color black, and they can only be regrown after some fixed time.

### Prey: Cow
Initially, cows are together in a herd of at least two cows around it. The cow wanders around the environment trying to find its food—the grass patches. As they move around, they lose energy, and they can only gain energy through eating. As cows want to eat, they try to move towards a patch that has grass on it. Although, the cow only tries to eat a patch of grass if it is no longer full.

Once they run out of energy, then they will die. Additionally, there is a possibility that they can reproduce, which will increase the population of the cows. However, it is important to take note that they will also lose energy when they reproduce.

### Predator: Coyote
At setup, coyotes are together in a group of at least two to four coyotes. This represents the fact that coyotes hunt in a pack, and not by itself.

The coyote also moves around the environment. Although, they are moving around to search for the cows, which are their food. They also move towards cows are near their vicinity. However, they only eat when they are no longer full.

Just like their preys, they lose energy as they move around, which can be regained once they eat. They can also reproduce based on a fixed probability, and they lose half of their energy when they reproduce. Coyotes only breed once a year and their litter is usually only composed of 2-6 pups ([Carr, 2017](https://fernandinaobserver.com/general/coyote-facts-you-should-know-1-1-more-pups/)). A random number from this range is used in the reproduction rate of the coyotes in the simulations.

## Adjustable Parameters
To fully understand how each of the components affect the system as a whole, the model has six (6) configurable parameters:
1. `num-preys` → the initial number of cows in the model
2. `num-predators` → the initial number of coyotes in the model
3. `food-growth-time` → dictates the time (in seconds) it takes for an eaten grass patch to grow 
4. `fixed-energy` → the initial energy all cows and coyotes have in the model; also the basis if the cow or coyote is no longer full 
5. `fixed-coyote-reproducing` → the probability that a coyote will reproduce
6. `fixed-cow-reproducing` → the probability that a cow will reproduce

The reproduction rate of cows are higher compared to coyotes with cattle having a 60-70% rate while coyotes only breed once every year ([Diskin, 2016](https://doi.org/10.1016/j.theriogenology.2016.04.052); [Tokar, 2001](https://animaldiversity.org/accounts/Canis_latrans/)). The values represented in the repdoction probability are based off of these studies made on coyotes and cattle.

## Things to Observe
In the model, there are some things that we can observe:
1. the **population of the cows**, which can be seen in the `Number of Cows` monitor;
2. the **population of the coyotes**, through the `Number of Coyotes` monitor;
3. the **number of available grass patches**, using the `Number of Food (Grass)` monitor;
4. the **number of cows that died by being eaten by coyotes**, via the `Cows eaten by Coyote` monitor; and
5. the **number of cows that died by lost of energy**, through the `Cows died due to no Energy` monitor.

## How to run the model locally
1. Extract the folder from the zipped file that you can download through this DownGit [link](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/francheska-vicente/prey-predator-model).
2. Once you open the folder, you can double-click the `prey-predator-model.nlogo` file to launch the model on NetLogo.

## References
Diskin, Michael & Kenny, David. (2016). *Managing the reproductive performance of beef cows*. Theriogenology. 86. 10.1016/j.theriogenology.2016.04.052.

Tokar, E. 2001. *"Canis latrans" (On-line)*, Animal Diversity Web. Accessed February 07, 2023 at https://animaldiversity.org/accounts/Canis_latrans/

Carr, J. (2017, December 10). *Coyote facts you should know: 1 – 1 = “More pups!* Fernandina Observer. https://fernandinaobserver.com/general/coyote-facts-you-should-know-1-1-more-pups/

## Members
- **Sophia Louisse L. Eguaras** <br/>
sophia_eguaras@dlsu.edu.ph
- **Andrea Jean Marcelo**  <br/>
andrea_marcelo@dlsu.edu.ph
- **Francheska Josefa Vicente**  <br/>
francheska_vicente@dlsu.edu.ph
- **Sophia Danielle S. Vista** <br/>
sophia_danielle_vista@dlsu.edu.ph
