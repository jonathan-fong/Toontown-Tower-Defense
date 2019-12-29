int range = 100;

void drawTowers()
{
  for (int x = 0; x < 42; x++)
  {
    if (towers[x] == true)
    {
      if (towersGags[x] == "Trap")
      {
        fill(255, 255, 0);
        rect(towersX[x], towersY[x], 80, 80);
        trapAnimation(towersX[x]+40, towersY[x]+40, x);
        // trap animation
      }
      else if (towersGags[x] == "Lure")
      {
        fill(0, 255, 0);
        rect(towersX[x], towersY[x], 80, 80);
        lureAnimation(towersX[x]+40, towersY[x]+40, x);
        // lure animation
      }
      else if (towersGags[x] == "Sound")
      {
        fill(0, 0, 255);
        rect(towersX[x], towersY[x], 80, 80);
        soundAnimation(towersX[x]+40, towersY[x]+40, x);
        // sound animation
      }
      else if (towersGags[x] == "Throw")
      {
        fill(255, 128, 0);
        rect(towersX[x], towersY[x], 80, 80);
        throwAnimation(towersX[x]+40, towersY[x]+40,
                       towersY[x]+40-cogY, towersX[x]+40-cogX, x);
        // throw animation
      }
      else if (towersGags[x] == "Squirt")
      {
        fill(255, 0, 255);
        rect(towersX[x], towersY[x], 80, 80);
        squirtAnimation(towersX[x]+40, towersY[x]+40, x);
        // squirt animation
      }
      else if (towersGags[x] == "Drop")
      {
        fill(0, 255, 255);
        rect(towersX[x], towersY[x], 80, 80);
        dropAnimation(towersX[x]+40, towersY[x]+40, x);
        // drop animation
      }
    }
  }
}