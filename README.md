# Project2

### Group:
Meghana Madineni (91978425) & Amrutha Chowdary Alaparthy (66905246)

### Working:
  This project takes the arguments (numberOfNodes, topology, algorithm).
  
  We start the Genservers same as the numberOfNodes.
  
  According to the topology given as input we modify the neighbours list of the node. 
  
  If the algorithm is "gossip": Each Genserver maintains a state which the list of it's neighbouring nodes,count of number of messages it has and the message it should gossip.  
  We select a node and inititae gossiping by sending a message to it, once that server receives a message it starts sending that gossip to random neighbours. If the count of particular node exceeds 10, then we kill that node. Once all the neigbours of particular node dies then  we kill thet particular node as it has no neighbours to send the gossip.

  If the algorithm is "push-sum" : Each Genserver maintains a state which the list of it's neighbouring nodes, s(which is initialized to node number), w(which is initialized with 1.
  We initiate the gossip by sending message to one of the nodes. This node selects the random node from it's neighbours and casts the message by sending (s/2,w/2) to that node and retaining (s/2,w/2).
  Every time we send a message to actor we check s/w ration and if the ratio doesn't change more than given ration we terminate the node. 


### Largest network we manged to deal with for each type of topology and algorithm:
#### Gossip Protocol:
    Full:  5000 nodes -> 812531 milliseconds
    2D:    10000 nodes -> 1531 milliseconds
    imp2D: 10000 nodes -> 2078 milliseconds
    line:  10000 nodes -> 922 milliseconds
#### Push-Sum algorithm :
    Full:  5000  nodes -> 656547 milliseconds
    2D:    5000  nodes -> 694094 milliseconds
    imp2D: 10000 nodes -> 23032 milliseconds
    line:  5000 nodes  -> 231750 milliseconds
