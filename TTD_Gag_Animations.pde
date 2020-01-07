int[] towerAnimation = {0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0};
boolean[] inAnimation = new boolean[42];
float throwdx;
float throwdy;
boolean throwHit;
boolean[] soundHit = new boolean[42];
int[][] bananaLife = new int[42][10];
double[][] bananaPositionX = new double[42][10];
double[][] bananaPositionY = new double[42][10];
double angle;
double[] trapdx = new double[42];
double[] trapdy = new double[42];
int counter = 0;
int bananaHit;
float[] luredx = new float[42];
float[] luredy = new float[42];
boolean lureHit[] = new boolean[42];

void trapAnimation(int topX, int topY, int x)
{
  if (towerAnimation[x] == 0)
  {
    angle = TWO_PI*Math.random();
    trapdx[x] = cos((float) angle)*range/10;
    trapdy[x] = sin((float) angle)*range/10;
  }
  else
  {
    bananaPeel((float)(topX+towerAnimation[x]*trapdx[x]),
               (float)(topY+towerAnimation[x]*trapdy[x]));
  } 
  towerAnimation[x]++;
  if (towerAnimation[x] == 10)
  {
    bananaLife[x][counter] = 10;
    for (int i = 0; i < counter; i++)
    {
      bananaLife[x][i]--;
    }
    bananaPositionX[x][counter] = topX+9*trapdx[x];
    bananaPositionY[x][counter] = topY+9*trapdy[x];
    towerAnimation[x] = 0;
    counter++;
  }
  displayBananas();
  for (int i = 0; i < cogAlive.length; i++)
  {
    if (cogAlive[i] && isCogTouchingBanana(i))
    {
      bananaLife[x][bananaHit] = 0;
      bananaPositionX[x][bananaHit] = 0;
      bananaPositionY[x][bananaHit] = 0;
      cogCurrentHealth[i]--;
    }
  }
  if (counter == 9)
  {
    counter = 0;
  }
}

void lureAnimation(int centerX, int centerY, int x)      // BROKEN 
{
  int id = cogInRange(x);
  inAnimation[x] = true;
  if (id == -1)
  {
    inAnimation[x] = false;
  }
  if (id != -1 && inAnimation[x])
  {
    float directionX = towersX[x]+40-cogXPos[id];
    float directionY = towersY[x]+40-cogYPos[id];
    inAnimation[x] = true;
    towerAnimation[x]++;
    if (towerAnimation[x] <= 5)
    {
      dollarBill(centerX-20, centerY-10);
      if (towerAnimation[x] == 5)
      {
        lureHit[id] = false;
        luredx[x] = directionX;
        luredy[x] = directionY;
      }
    }
    else
    {
      dollarBill(centerX-20-((towerAnimation[x]-5)*luredx[x]/5),
                 centerY-10-((towerAnimation[x]-5)*luredy[x]/5));
      inAnimation[x] = true;
    }
    if (dist(centerX-((towerAnimation[x]-5)*luredx[x]/5),
             centerY-((towerAnimation[x]-5)*luredy[x]/5), cogXPos[id], cogYPos[id]) <= 40 &&
        !lureHit[id])
    {
        cogdx[id] = 0;
        cogdy[id] = 0;
        lureHit[id] = true;
        //luredx[id] = 0;
        //luredy[id] = 0;
    }
    if (towerAnimation[x] == 20)
    {
      towerAnimation[x] = 0;
      lureHit[id] = false;
      inAnimation[x] = false;
      if (cogDirection[id] == "up")
      {
        cogdx[id] = 0;
        cogdy[id] = -5;
      }
      else if (cogDirection[id] == "down")
      {
        cogdx[id] = 0;
        cogdy[id] = 5;
      }
      else
      {
        cogdx[id] = 5;
        cogdy[id] = 0;
      }
      changeDirection(id);
    }
  }
  else
  {
    towerAnimation[x] = 0;
  }
}





int cogInRange(int x)
{
  for (int i = 0; i < cogAlive.length; i++)
  {
    if (cogAlive[i] && dist(cogXPos[i], cogYPos[i], towersX[x]+40, towersY[x]+40) <= range)
    {
      return i;
    }
  }
  return -1;
}



void soundAnimation(int centerX, int centerY, int x)
{
  if (cogInRange(x) != -1 || inAnimation[x])
  {
    inAnimation[x] = true;
    noFill();
    stroke(255, 255, 255);
    strokeWeight(1);
    if (towerAnimation[x] <= 40)
      ellipse(centerX, centerY, 5*towerAnimation[x], 5*towerAnimation[x]);
    if (towerAnimation[x] >= 5 && towerAnimation[x] <= 45)
      ellipse(centerX, centerY, 5*towerAnimation[x]-25, 5*towerAnimation[x]-25);
    if (towerAnimation[x] >= 10)
      ellipse(centerX, centerY, 5*towerAnimation[x]-50, 5*towerAnimation[x]-50);
    for (int i = 0; i < cogAlive.length; i++)
    {
      if (dist(centerX, centerY, cogXPos[i], cogYPos[i]) <= 2.5*towerAnimation[x]+30 && !soundHit[i])
      {
        cogCurrentHealth[i]--;
        soundHit[i] = true;
      }
    }
    towerAnimation[x]++;
    if (towerAnimation[x] == 50)
    {
      towerAnimation[x] = 0;
      inAnimation[x] = false;
      for (int i = 0; i < cogAlive.length; i++)
      {
        soundHit[i] = false;
      }
    }
  }
  else
  {
    towerAnimation[x] = 0;
  }
}

void throwAnimation(int centerX, int centerY, float directionY, float directionX,
                    int x)
{
  if (alive && dist(cogX, cogY, centerX, centerY) <= range || inAnimation[x])
  {
    noStroke();
    fill(200, 100, 100);
    if (towerAnimation[x] <= 5)
    {
      ellipse(centerX, centerY, 20, 20);
      if (towerAnimation[x] == 5)
      {
        throwHit = false;
        throwdx = directionX;
        throwdy = directionY;
      }
    }
    else
    {
      ellipse(centerX-((towerAnimation[x]-5)*throwdx/10),
              centerY-((towerAnimation[x]-5)*throwdy/10), 20, 20);
      inAnimation[x] = true;
    }
    if (dist(centerX-((towerAnimation[x]-5)*throwdx/10),
             centerY-((towerAnimation[x]-5)*throwdy/10), cogX, cogY) <= 40 &&
        !throwHit)
    {
      cogCurrHealth--;
      throwHit = true;
    }
    towerAnimation[x]++;
    if (towerAnimation[x] == 20)
    {
      towerAnimation[x] = 0;
      throwHit = false;
      inAnimation[x] = false;
    }
  }
  else
  {
    towerAnimation[x] = 0;
  }
}

void squirtAnimation(int centerX, int centerY, int x)
{
  if (alive && dist(cogX, cogY, centerX, centerY) <= range || inAnimation[x])
  {
    strokeWeight(5);
    stroke(0, 200, 255);
    line(centerX, centerY, cogX, cogY);
    if (towerAnimation[x] == 0)
      cogCurrHealth--;
    towerAnimation[x]++;
    if (towerAnimation[x] == 15)
      towerAnimation[x] = 0;
  }
  else
  {
    towerAnimation[x] = 0;
  }
}

void dropAnimation(int centerX, int centerY, int x)
{
  if (alive && dist(cogX, cogY, centerX, centerY) <= range || inAnimation[x])
  {
    inAnimation[x] = true;
    if (towerAnimation[x] <= 5)
    {
      fill(255, 0, 0);
      ellipse(centerX, centerY, 20, 20);
    }
    else
    {
      flowerPot(cogX-15, cogY+40*towerAnimation[x]-600);
    }
    towerAnimation[x]++;
    if (towerAnimation[x] == 15)
    {
      towerAnimation[x] = 0;
      inAnimation[x] = false;
      cogCurrHealth--;
    }
  }
  else
  {
    towerAnimation[x] = 0;
  }
}

void flowerPot(int rectX, int rectY)
{
  noStroke();
  fill(200, 100, 100);
  rect(rectX, rectY, 30, 40);
  stroke(0, 255, 0);
  strokeWeight(5);
  fill(0, 255, 0);
  line(rectX+15, rectY, rectX+15, rectY-30);
  strokeWeight(2);
  line(rectX+15, rectY-10, rectX, rectY-15);
  line(rectX+15, rectY-10, rectX+30, rectY-15);
  noStroke();
  fill(255, 255, 0);
  ellipse(rectX+10, rectY-35, 20, 5);
  ellipse(rectX+20, rectY-35, 20, 5);
  ellipse(rectX+15, rectY-40, 5, 20);
  ellipse(rectX+15, rectY-30, 5, 20);
  fill(255, 128, 0);
  ellipse(rectX+15, rectY-35, 10, 10);
}

void bananaPeel(float x, float y)
{
  fill(255, 255, 0);
  stroke(255, 255, 0);
  curve(x-70, y-30, x, y, x-20, y+20, x, y-30);
  curve(x+70, y+30, x, y, x+20, y+20, x+40, y-30);
  stroke(128, 64, 0);
  strokeWeight(5);
  line(x, y, x, y-10);
}

void displayBananas()
{
  for (int x = 0; x < 42; x++)
  {
    for (int i = 0; i < bananaPositionX[0].length; i++)
    {
      if (bananaPositionX[x][i] != 0)
        bananaPeel((float)bananaPositionX[x][i], (float)bananaPositionY[x][i]);
    }
  }
}

boolean isCogTouchingBanana(int cog)
{
  for (int x = 0; x < 42; x++)
  {
    for (int i = 0; i < bananaPositionX[0].length; i++)
    {
      // touching top?
      if (dist(cogXPos[cog], cogYPos[cog], (float)bananaPositionX[x][i],
                                           (float)bananaPositionY[x][i]) < 30)
      {
        bananaHit = i;
        return true;
      }
      // touching left end?
      if (dist(cogXPos[cog], cogYPos[cog], (float)(bananaPositionX[x][i]-20),
                           (float)(bananaPositionY[x][i]+20)) < 30)
      {
        bananaHit = i;
        return true;
      }
      // touching right end?
      if (dist(cogXPos[cog], cogYPos[cog], (float)(bananaPositionX[x][i]+20),
                           (float)(bananaPositionY[x][i]+20)) < 30)
      {
        bananaHit = i;
        return true;
      }
    }
  }
  return false;
}

void dollarBill(float cornerX, float cornerY)
{
  fill(0, 255, 0);
  strokeWeight(2);
  rect(cornerX, cornerY, 40, 20);
  textSize(15);
  fill(0);
  text("$1", cornerX+10, cornerY+15);
}