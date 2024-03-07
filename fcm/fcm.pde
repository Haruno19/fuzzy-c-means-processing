int n_dp = 4300;        //numbers of datapoints
int n_cr = 12;          //numbers of centroids
float m = 2;            //fuzziness parameter
float tolerance = 0.005f;    

ArrayList<PVector> data_points;
ArrayList<PVector> centroids;

int[] c_colors;
float[][] distr;        //a n_dp x n_cr matrix that containes the memebrship for each data point

boolean stop = false;   //whether or not degrees of membership for each datapoint have changed over the last iteration (or the difference is below the tolerance level)

void setup()
{
  size(700,700);
  stroke(255);
  
  data_points = new ArrayList<PVector>();
  centroids = new ArrayList<PVector>();
  c_colors = new int[n_cr];
 
  gen();  //generates random data points and colors
  //printd();    //prints the membership values for each datapoint
}

void printd()
{
  for(int i=0;i<n_dp;i++)
  {
    println(i);
    for(int k=0;k<n_cr;k++)
    {
      print(distr[i][k]);
      print(" ");
    }
    println();
  }
}

void gen()
{
  PVector p;
  for(int i=0;i<n_dp;i++)
  {
    p = new PVector(int(random(width)), int(random(height)));  //datapoints' two features are randomly generated coordinates
    data_points.add(p);
  }
  for(int i=0;i<n_cr;i++)
  {
    p = new PVector();
    centroids.add(p);
    c_colors[i] = color(random(0,255),random(0,255),random(0,255));
  }
  
  //at first, set the membership values to a random value
  float d, tot_d;
  distr = new float[n_dp][n_cr];
  for(int i=0;i<n_dp;i++)
  {
    tot_d=0;
    for(int k=0;k<n_cr;k++)
    {
      if(k+1==n_cr)
        d = 1-tot_d;
      else{
        d = random(1-tot_d);
        tot_d+=d;
      }
      distr[i][k] = d;
    }
  }
}

void draw()
{ 
  if(!stop)  //while the centroids keep changing position (features)
  {
    background(0);
    
    calculate_centroids();    //recalcutale the centroids features
    calculate_distances();    //reassign each data point to the new centroid
    drawpoints();
  }
}

void calculate_centroids()
{
  //calculate the centroids' features
  // V_k = ( SUM[i=0->n_dp](distr_ik ^ m) * x_i) ) / SUM[i=0->n_dp](distr_ik ^ m)
  float numx, numy, denum;
  for (int k=0;k<n_cr;k++)
  {
    numx=0; numy=0;
    denum=0;
    for(int i=0;i<n_dp;i++)
    {
      numx+=pow(distr[i][k],m)*data_points.get(i).x;
      numy+=pow(distr[i][k],m)*data_points.get(i).y;
      denum+=pow(distr[i][k],m);
    }
    centroids.get(k).set(numx/denum,numy/denum);
  }
}

void calculate_distances()
{
  //calculate the new membership values for each datapoint
  // distr_ik = { SUM[j=0->n_cr](dist(i,k)^2 / dist(i,j)^2 )^1/*m-1) }^-1
  boolean same=true;
  float sum, new_distr;
  PVector p;
  for (int i=0;i<n_dp;i++)
  {
    p=data_points.get(i);
    for (int k=0;k<n_cr;k++) //Yik
    {
      sum=0;
      for (PVector j : centroids)
      {
        sum+= pow(p.dist(centroids.get(k)),2)/pow(p.dist(j),2);
      }
      new_distr = pow(pow(sum,1/(m-1)),-1);
      same = same & (abs(distr[i][k]-new_distr) < tolerance);  //checks whether the degree of membership for each datapoint has changed (or the difference is within the tolerance level)
      distr[i][k] = new_distr;
    }
  }
  stop = same;  
}

void drawpoints()
{ 
  //function that draws all the points and their color
  float max_prob;
  int assigned_c, col;
  PVector p, c;
  
  for(int i=0;i<n_dp;i++)
  {
    p=data_points.get(i);
    max_prob = 0;
    assigned_c = 0;
    for (int k=0;k<n_cr;k++)
    {
      if(distr[i][k] > max_prob)
      {
        assigned_c = k;
        max_prob = distr[i][k];
      }
    }
    col = c_colors[assigned_c];  //initially, each data point is colored in the same color as its assigned centroid
    for (int k=0;k<n_cr;k++)
      col = lerpColor(col,c_colors[k],distr[i][k]);    //that color then is set to a mix of the colors of all the centroids lerped by the respective membership value
    fill(col);
    if(stop)  //stroke changes to the fill color during the last iteration
      stroke(col);
    else
      stroke(0);
    circle(p.x, p.y, 10);
  }
  
  for (int k=0;k<n_cr;k++)
  {
    c=centroids.get(k);
    fill(c_colors[k]);
    stroke(255);
    circle(c.x,c.y,15);
  }
}
