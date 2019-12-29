boolean[] cogAlive = new boolean[10];
boolean[] cogAppear = new boolean[10];
int[] cogCurrentHealth = new int[10];
int[] cogHealth = {0, 6, 12, 20, 30, 42, 56, 72, 90, 110, 132, 156, 200};
int[] cogXPos = {110, 110, 110, 110, 110, 110, 110, 110, 110, 110};
int[] cogdx = new int[10];
int[] cogYPos = {760, 760, 760, 760, 760, 760, 760, 760, 760, 760};
int[] cogdy = {-5, -5, -5, -5, -5, -5, -5, -5, -5, -5};
String[] cogDirection = {"up", "up", "up", "up", "up", "up", "up", "up", "up", "up"};
int[] level1 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
int[] level2 = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2};
int[] level3 = {3, 3, 3, 3, 3, 3, 3, 3, 3, 3};
int[] level4 = {4, 4, 4, 4, 4, 4, 4, 4, 4, 4};
int[] level5 = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5};
int delayAppearance = 20;
int cogAppearIndex = 1;
int[] ignoreDirection = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30};

void displayCogs(int level)
{
  delayAppearance--;
  if (delayAppearance == 0)
  {
    delayAppearance = 20;
    if (cogAppearIndex <= 9)
    {
      cogAppear[cogAppearIndex] = true;
      cogAppearIndex++;
    }
  }
  for (int i = 0; i < cogAppear.length; i++)
  {
    if (cogAppear[i] && cogAlive[i])
    {
      if (cogCurrentHealth[i] > .8*cogHealth[level])
        fill(0, 255, 0);
      else if (cogCurrentHealth[i] > .5*cogHealth[level])
        fill(255, 255, 0);
      else if (cogCurrentHealth[i] > .3*cogHealth[level])
        fill(255, 128, 0);
      else if (cogCurrentHealth[i] > 0*cogHealth[level])
        fill(255, 0, 0);
      cogXPos[i] += cogdx[i];
      cogYPos[i] += cogdy[i];
      ellipse(cogXPos[i], cogYPos[i], 60, 60);
      if (cogCurrentHealth[i] <= 0)
        cogAlive[i] = false;
      
      changeDirection(i);
    }
  }
}

void changeDirection(int i)
{
  if (ignoreDirection[i] <= 0 && touchingEdgeOfRect(i))
  {
    // Change COG position based on direction
    if (cogDirection[i] == "up" || cogDirection[i] == "down")
    {
      cogdx[i] = 5;
      cogdy[i] = 0;
      cogDirection[i] = "right";
    }
    else        // cogDirection[i] == "right"
    {
      if (cogYPos[i] == 210)
      {
        cogdx[i] = 0;
        cogdy[i] = 5;
        cogDirection[i] = "down";
      }
      else      // cogYPos[i] == 710
      {
        cogdx[i] = 0;
        cogdy[i] = -5;
        cogDirection[i] = "up";
      }
    }
  }
  if (ignoreDirection[i] > 0)
    ignoreDirection[i]--;
}


boolean touchingEdgeOfRect(int i)
{
  for (int x = 0; x < rectX.length; x++)
  {
    if (cogXPos[i] == rectX[x] && cogYPos[i] == rectY[x])      // touching edge of rectangle
      return true;
  }
  return false;
}