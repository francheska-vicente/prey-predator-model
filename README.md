# The Cow-Coyote Relationship: A Prey-Predator Ecosystem
In the wilderness, wild animals thrive by preying on animals placed lower than them in the food chain. Coyotes are interesting mammals with their keen, clever, and smart tactics as predators. In the US, they are considered to be one of the largest threats to the survival of livestock such as sheep, lamb, and cows [(Derksen, 2021)](https://www.agproud.com/articles/52864-influencing-livestock-losses-from-coyote-predation). In this cellular automata-based model, a prey-predator relationship will be explored through a simulation of a prairie environment littered with herds of cows and coyotes to observe their behavior and relationshjip with one another.

## Behavior of the Agents
In this model, there are two main agents: (1) the cow, and (2) the coyote. The coyotes are the a predator that tries to eat the cows, while cows are the preys that eats grass. 

The grass are the patches of green that can be seen in the model. If they are eaten, then they turn into the color black, and they can only be regrown after some fixed time.

### Prey: Cow
Initially, cows are together in a herd of at least two cows around it. The cow wanders around the environment trying to find its food—the grass patches. As they move around, they lose energy, and they can only gain energy through eating. Once they run out of energy, then they will die. Additionally, there is a possibility that they can reproduce, which will increase the population of the cows. However, it is important to take note that they will also lose energy when they reproduce.

### Predator: Coyote
At setup, coyotes are together in a group of at least two to four coyotes. This represents the fact that coyotes hunt in a pack, and not by itself.

The coyote also moves around the environment. Although, they are moving around to search for the cows, which are their food. Just like their preys, they lose energy as they move around, which can be regained once they eat. They can also reproduce based on a fixed probability, and they lose half of their energy when they reproduce. 

## Adjustable Parameters
To fully understand how each of the components affect the system as a whole, the model has six (6) configurable parameters:
1. `num-preys` → the initial number of cows in the model
2. `num-predators` → the initial number of coyotes in the model
3. `food-growth-time` → dictates the time (in seconds) it takes for an eaten grass patch to grow 
4. `fixed-energy` → the initial energy all cows and coyotes have in the model
5. `fixed-coyote-reproducing` → the probability that a coyote will reproduce
6. `fixed-cow-reproducing` → the probability that a cow will reproduce

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

## Members
- **Sophia Louisse L. Eguaras** <br/>
sophia_eguaras@dlsu.edu.ph
- **Andrea Jean Marcelo**  <br/>
andrea_marcelo@dlsu.edu.ph
- **Francheska Josefa Vicente**  <br/>
francheska_vicente@dlsu.edu.ph
- **Sophia Danielle S. Vista** <br/>
sophia_danielle_vista@dlsu.edu.ph
