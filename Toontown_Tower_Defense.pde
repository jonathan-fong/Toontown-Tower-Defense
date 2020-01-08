String gag;
boolean gagSelected;
boolean alive = true;
int cogLevel;
int cogCurrHealth;
int cogMaxHealth;
int cogX;
int cogY;
int dx;
int dy;
int ignoreDirectionChange = 20;
int lives = 20;
int score;
int[] rectX = {110, 250, 250, 390, 390, 530, 530, 
               670, 670, 810, 810, 950, 950, 1090, 1090};
int[] rectY = {210, 210, 710, 710, 210, 210, 710, 
               710, 210, 210, 710, 710, 210, 210, 710};
String direction;
float openSlotAnimation = 0;
float opendx = 0.5;

void setup()
{
  size(1260, 760);
  score = 0;
  fill(0);
  gagSelected = false;
  cogLevel = 1;
  for (int i = 0; i < cogAlive.length; i++)
  {
    cogCurrentHealth[i] = cogHealth[cogLevel];
  }
  cogMaxHealth = cogHealth[cogLevel];
  cogX = 110;
  cogY = height;
  dx = 0;
  dy = -5;
  direction = "up";
  cogAppear[0] = true;
  for (int i = 0; i < cogAlive.length; i++)
  {
    cogAlive[i] = true;
  }
}

void draw()
{
  background(128);
  fill(0);
  stroke(0);
  grid();
  textSize(48);
  //text("Welcome to Toontown Tower Defense!", width/2-400, 50);

  // Draw rectangles for the track
  fill(0);
  rect(80, 180, 60, 580);
  rect(80, 180, 200, 60);
  rect(220, 180, 60, 540);
  rect(220, 680, 200, 60);
  for (int x = 1; x < 4; x++)
  {
    rect(280*x+80, 180, 60, 560);
    rect(280*x+80, 180, 200, 60);
    rect(280*x+220, 180, 60, 540);
    rect(280*x+220, 680, 200, 60);
  }
  rect(1070, 680, 190, 60);
  text("Lives: "+lives, 1040, 50);

  
  displayCogs(1);

  // draw gag selections
  strokeWeight(5);
  fill(255, 255, 0);            // Trap
  rect(1160, 180, 80, 80);
  fill(0, 255, 0);              // Lure
  rect(1160, 260, 80, 80);
  fill(0, 0, 255);              // Sound
  rect(1160, 340, 80, 80);
  fill(255, 128, 0);            // Throw
  rect(1160, 420, 80, 80);
  fill(255, 0, 255);            // Squirt
  rect(1160, 500, 80, 80);
  fill(0, 255, 255);            // Drop
  rect(1160, 580, 80, 80);

  // checks if a gag is clicked
  if (gagSelected)
  {
    for (int i = 0; i < towers.length; i++)
    {
      if (!towers[i])
      {
        fill(openSlotAnimation+100, 0, 0);
        rect(towersX[i], towersY[i], 80, 80);
      }
      openSlotAnimation += opendx;
      if (openSlotAnimation == 155 || openSlotAnimation == 0)
        opendx *= -1;
    }
    if (gag == "Trap")
      fill(255, 255, 0);
    else if (gag == "Lure")
      fill(0, 255, 0);
    else if (gag == "Sound")
      fill(0, 0, 255);
    else if (gag == "Throw")
      fill(255, 128, 0);
    else if (gag == "Squirt")
      fill(255, 0, 255);
    else if (gag == "Drop")
      fill(0, 255, 255);
    rect(mouseX-40, mouseY-40, 80, 80);
  }

  drawTowers();
}

void grid()
{
  for (int x = 0; x <= width; x += 20)
  {
    for (int y = 0; y <= height; y += 20)
    {
      if (y%100 == 0)
        strokeWeight(5);
      else
        strokeWeight(1);
      line(0, y, width, y);
    }
    if (x % 100 == 0)
      strokeWeight(5);
    else
      strokeWeight(1);
    line(x, 0, x, height);
  }
}

boolean isTouchingEdgeOfRect(int cog)
{
  for (int x = 0; x < rectX.length; x++)
  {
    if (cogXPos[cog] == rectX[x] && cogYPos[cog] == rectY[x])      // touching edge of rectangle
      return true;
  }
  return false;
}

boolean gagClicked()
{
  if (mouseX >= 1160 && mouseX <= 1320 &&
      mouseY >= 180 && mouseY <= 660)
    return true;
  return false;
}

String gag()
{
  if (mouseX >= 1160 && mouseX <= 1320 &&
      mouseY >= 180 && mouseY <= 260)
    return "Trap";
  else if (mouseX >= 1160 && mouseX <= 1320 &&
           mouseY >= 260 && mouseY <= 340)
    return "Lure";
  else if (mouseX >= 1160 && mouseX <= 1320 &&
           mouseY >= 340 && mouseY <= 420)
    return "Sound";
  else if (mouseX >= 1160 && mouseX <= 1320 &&
           mouseY >= 420 && mouseY <= 500)
    return "Throw";
  else if (mouseX >= 1160 && mouseX <= 1320 &&
           mouseY >= 500 && mouseY <= 580)
    return "Squirt";
  else // (mouseX >= 1160 && mouseX <= 1320 &&
       //  mouseY >= 580 && mouseY <= 660)
    return "Drop";
}

void mouseClicked()
{
  gagSelected = gagClicked();
  if (gagSelected)
    gag = gag();
  else
  {
    if (mouseX >= 140 && mouseX <= 220)
    {
      for (int i = 0; i < 6; i++)
      {
        if (!towers[i] && mouseY >= 240 + 80*i && mouseY <= 320 + 80*i)
        {
          towers[i] = true;
          towersGags[i] = gag;
          break;
        }
      }
      if (mouseY >= 240 && mouseY <= 320)
      {
        towers[0] = true;
        towersGags[0] = gag;
      }
      else if (mouseY >= 320 && mouseY <= 400)
      {
        towers[1] = true;
        towersGags[1] = gag;
      }
      else if (mouseY >= 400 && mouseY <= 480)
      {
        towers[2] = true;
        towersGags[2] = gag;
      }
      else if (mouseY >= 480 && mouseY <= 560)
      {
        towers[3] = true;
        towersGags[3] = gag;
      }
      else if (mouseY >= 560 && mouseY <= 640)
      {
        towers[4] = true;
        towersGags[4] = gag;
      }
      else if (mouseY >= 640 && mouseY <= 720)
      {
        towers[5] = true;
        towersGags[5] = gag;
      }
    }
    else if (mouseX >= 280 && mouseX <= 360)
    {
      if (mouseY >= 200 && mouseY <= 280)
      {
        towers[6] = true;
        towersGags[6] = gag;
      }
      else if (mouseY >= 280 && mouseY <= 360)
      {
        towers[7] = true;
        towersGags[7] = gag;
      }
      else if (mouseY >= 360 && mouseY <= 440)
      {
        towers[8] = true;
        towersGags[8] = gag;
      }
      else if (mouseY >= 440 && mouseY <= 520)
      {
        towers[9] = true;
        towersGags[9] = gag;
      }
      else if (mouseY >= 520 && mouseY <= 600)
      {
        towers[10] = true;
        towersGags[10] = gag;
      }
      else if (mouseY >= 600 && mouseY <= 680)
      {
        towers[11] = true;
        towersGags[11] = gag;
      }
    }
    else if (mouseX >= 420 && mouseX <= 500)
    {
      if (mouseY >= 240 && mouseY <= 320)
      {
        towers[12] = true;
        towersGags[12] = gag;
      }
      else if (mouseY >= 320 && mouseY <= 400)
      {
        towers[13] = true;
        towersGags[13] = gag;
      }
      else if (mouseY >= 400 && mouseY <= 480)
      {
        towers[14] = true;
        towersGags[14] = gag;
      }
      else if (mouseY >= 480 && mouseY <= 560)
      {
        towers[15] = true;
        towersGags[15] = gag;
      }
      else if (mouseY >= 560 && mouseY <= 640)
      {
        towers[16] = true;
        towersGags[16] = gag;
      }
      else if (mouseY >= 640 && mouseY <= 720)
      {
        towers[17] = true;
        towersGags[17] = gag;
      }
    }
    else if (mouseX >= 560 && mouseX <= 640)
    {
      if (mouseY >= 200 && mouseY <= 280)
      {
        towers[18] = true;
        towersGags[18] = gag;
      }
      else if (mouseY >= 280 && mouseY <= 360)
      {
        towers[19] = true;
        towersGags[19] = gag;
      }
      else if (mouseY >= 360 && mouseY <= 440)
      {
        towers[20] = true;
        towersGags[20] = gag;
      }
      else if (mouseY >= 440 && mouseY <= 520)
      {
        towers[21] = true;
        towersGags[21] = gag;
      }
      else if (mouseY >= 520 && mouseY <= 600)
      {
        towers[22] = true;
        towersGags[22] = gag;
      }
      else if (mouseY >= 600 && mouseY <= 680)
      {
        towers[23] = true;
        towersGags[23] = gag;
      }
    }
    else if (mouseX >= 700 && mouseX <= 780)
    {
      if (mouseY >= 240 && mouseY <= 320)
      {
        towers[24] = true;
        towersGags[24] = gag;
      }
      else if (mouseY >= 320 && mouseY <= 400)
      {
        towers[25] = true;
        towersGags[25] = gag;
      }
      else if (mouseY >= 400 && mouseY <= 480)
      {
        towers[26] = true;
        towersGags[26] = gag;
      }
      else if (mouseY >= 480 && mouseY <= 560)
      {
        towers[27] = true;
        towersGags[27] = gag;
      }
      else if (mouseY >= 560 && mouseY <= 640)
      {
        towers[28] = true;
        towersGags[28] = gag;
      }
      else if (mouseY >= 640 && mouseY <= 720)
      {
        towers[29] = true;
        towersGags[29] = gag;
      }
    }
    else if (mouseX >= 840 && mouseX <= 920)
    {
      if (mouseY >= 200 && mouseY <= 280)
      {
        towers[30] = true;
        towersGags[30] = gag;
      }
      else if (mouseY >= 280 && mouseY <= 360)
      {
        towers[31] = true;
        towersGags[31] = gag;
      }
      else if (mouseY >= 360 && mouseY <= 440)
      {
        towers[32] = true;
        towersGags[32] = gag;
      }
      else if (mouseY >= 440 && mouseY <= 520)
      {
        towers[33] = true;
        towersGags[33] = gag;
      }
      else if (mouseY >= 520 && mouseY <= 600)
      {
        towers[34] = true;
        towersGags[34] = gag;
      }
      else if (mouseY >= 600 && mouseY <= 680)
      {
        towers[35] = true;
        towersGags[35] = gag;
      }
    }
    else if (mouseX >= 980 && mouseX <= 1040)
    {
      if (mouseY >= 240 && mouseY <= 320)
      {
        towers[36] = true;
        towersGags[36] = gag;
      }
      else if (mouseY >= 320 && mouseY <= 400)
      {
        towers[37] = true;
        towersGags[37] = gag;
      }
      else if (mouseY >= 400 && mouseY <= 480)
      {
        towers[38] = true;
        towersGags[38] = gag;
      }
      else if (mouseY >= 480 && mouseY <= 560)
      {
        towers[39] = true;
        towersGags[39] = gag;
      }
      else if (mouseY >= 560 && mouseY <= 640)
      {
        towers[40] = true;
        towersGags[40] = gag;
      }
      else if (mouseY >= 640 && mouseY <= 720)
      {
        towers[41] = true;
        towersGags[41] = gag;
      }
      else
      {
        gagSelected = false;
      }
    }
  }
}