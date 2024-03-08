# Fuzzy C-Means Clustering (Processing 4)
Fuzzy C-Means Clustering algorithm implementation (and visualization) in Processing 4 

<table>
  <tr>
    <td> <img src=https://github.com/Haruno19/fuzzy-c-means-processing/assets/61376940/2e581334-6be3-4858-8c51-ed8981fe1bbb> </td>
    <td> <img src=https://github.com/Haruno19/fuzzy-c-means-processing/assets/61376940/cd211881-e8d2-4733-82b8-e75bf1af8bbc> </td>
    <td> <img src=https://github.com/Haruno19/fuzzy-c-means-processing/assets/61376940/16d3efa7-6c09-4d4c-999c-9ff14b652c9a> </td>
  </tr>
  <tr>
    <td>
      n_dp = 500<br>
      n_cr =  3
    </td>
    <td>
      n_dp = 1000<br>
      n_cr =   6
    </td>
    <td>
      n_dp = 3000<br>
      n_cr =    7
    </td>
  </tr>
</table>

## Specifications
This sketch is an implementation of the FCM clustering algorithm in Processing 4. 

Given a number of **Data Points**, their **features**, and the number of **Centroids**, it computes the features of the Centroids and the **degrees of membership** for each Data Point to each Centroid.

The number of **Data Points** and **Centroids** is variable, and can be set through the `int n_dp` and `int n_cr` variables respectively.  
The number of **feature** each Data Point and Centroid has, however, is fixed to `2`, in order to provide a graphical visualization of the sets (each feature representing one of the two axis in a two-dimential plane) throughout the execution of the algorithm. 

The **parameter of fuzziness** is also variable, and can be set through the `float m` variable (default value is `2`).  
The **degree of tolerance** (relative to the difference between the previous and current iterations' Centroids' features values) can too be set to any desired value through the `float tolerance` variable (default value is `0.005f`).

## Demo
https://github.com/Haruno19/fuzzy-c-means-processing/assets/61376940/2484e372-080e-4a87-9f2a-8185ea713507


## Setup
At first, each Data Point is instantiated with two randomly generated features (stored in `ArrayList<PVector> data_points`), and a randomly generated degree of memebership for each Centroid (stored in a `float[][] distr` of dimensions `n_dp * n_cr`).  
The Centroids' feature are initally set to `0` (and are stored in `ArrayList<PVector> centroids`).

A random color is also assigned to each Centroid (stored in `int[] c_colors`) in order to provide a clearer visual representation. 

## Iterations
Each iteration of the algorithm consists of two (plus one) steps:

### Calculating the Centroids' features
For each **Centroid** $V_k$ with $k \in [0, ncr)$, the **features** (noted as $x$ and $y$ respectively, both for Centroids and Data Points) are calculated as such:  
### $V_{kz} = \frac{\sum_{i=0}^{ndp-1} \gamma_{ik}^m * P_{iz}}{\sum_{i=0}^{ndp-1} \gamma_{ik}^m}$  
with $z \in \lbrace x, y\rbrace$ and where $\gamma_{ik}$ is the **degree of membership** of the Data Point $P_i$ to the Centroid $V_k$.

### Calculating the new degrees of membership
For each **Data Point** $P_i$ with $i \in [0, ndp)$ the **degree of memebership** $\gamma_{ik}$ with $k \in [0, ncr)$ (or, the degree of memebership of the Data Point $P_i$ to the Centroid $V_k$) is calculated as such:  
### $\gamma_{ik} = (\sum_{j=0}^{ncr-1} (\frac{d_{ik}^2}{d_{ij}})^\frac{1}{m-1})^{-1}$  
with $j \in [0, ncr)$ and where $d_{ik}$ is the euclidean distance between the features of the Data Point $i$ and the features of the Centroid $V_k$.

### Halt condition
These two operations are iterated until the following condition is met:  
Let $\gamma_{ik}^t$ with $i \in [0, ndp)$ and $k \in [0, ncr)$ be the **degree of memebership** of the Data Point $P_i$ to the Centroid $V_k$ at the iteration $t \in \mathbb{N}$   
### $|\gamma_{ik}^{t-1}-\gamma_{ik}^t| < \epsilon$  
where $\epsilon \in \mathbb{R}$ is the **degree of tolerance**.

### Visualization
Lasty, the "third step" alluded to before concerns the visualization of the sets.  

Each **Centroid** is visualized as a circle with a radius of 15 pixels, centered at its features, colored in its respective color.  

Each **Data Point** is visualized as a circle with a radius of 10 pixels, centered at its features, which color is calculated by blending all the Centroids' colors according to the Data Point's **degrees of membership**. 
