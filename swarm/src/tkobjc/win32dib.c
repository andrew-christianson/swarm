#ifdef _WIN32
#include "win32dib.h"
#include <misc.h>
#include <windows.h>

dib_t *
dib_create (void)
{
  dib_t *dib = xmalloc (sizeof (dib_t));
  
  dib->window = NULL;
  dib->colorMapBlocks = 0;
  dib->colorMapSize = 0;
  memset (dib->colorMapOffsets, 0, sizeof (dib->colorMapOffsets));
  memset (dib->colorMapObjects, 0, sizeof (dib->colorMapObjects));
  dib->sourceDC = NULL;
  dib->destDC = NULL;
  dib->dibInfo = xmalloc (sizeof (CDIB_BITMAP));
  dib->bitmap = NULL;
  dib->oldBitmap = NULL;
  dib->bits = NULL;
  dib->palette = NULL;
  dib->oldPalette = NULL;
  dib->xBitmapOffset = 0;
  dib->yBitmapOffset = 0;

  return dib;
}

void
dib_destroy (dib_t *dib)
{
  xfree (dib->dibInfo);
  dib->dibInfo = NULL;
  if (dib->bitmap)
    {
      if (dib->window)
        {
          HDC hdc = GetDC (dib->window);

          SelectObject (hdc, dib->oldBitmap);
          DeleteObject (dib->bitmap);
          ReleaseDC (dib->window, hdc);
        }
      else
        {
          HDC hdc = CreateCompatibleDC (NULL);

          SelectObject (hdc, dib->oldBitmap);
          DeleteObject (dib->bitmap);
          DeleteDC (hdc);
        }
    }
  else if (dib->bits != NULL)
    xfree (dib->bits);

  dib->bitmap = NULL;
  dib->oldBitmap = NULL;
  dib->bits = NULL;

  if (dib->palette)
    {
      DeleteObject (dib->palette);
      dib->palette = NULL;
    }
  dib->oldPalette = NULL;
  if (dib->sourceDC)
    {
      DeleteDC (dib->sourceDC);
      dib->sourceDC = NULL;
    }
  if (dib->destDC)
    {
      if (dib->window)
        ReleaseDC (dib->window, dib->destDC);
      else
        DeleteDC (dib->destDC);
      dib->destDC = NULL;
    }
  dib->window = NULL;
  dib->xBitmapOffset = 0;
  dib->yBitmapOffset = 0;
}

void
dib_createBitmap (dib_t *dib, HWND window, unsigned width, unsigned height)
{
  HDC hdc;

  if (window)
    hdc = GetDC (window);
  else
    hdc = CreateCompatibleDC (NULL);
  
  dib->window = window;

  if (width & 3)
    width += 4 - (width & 3);

#if 0
  if (dib->bitmap)
    {
      xfree (dib->dibInfo);
      SelectObject (hdc, dib->oldBitmap);
      DeleteObject (dib->bitmap);
      if (window)
        ReleaseDC (window, hdc);
      else
        DeleteDC (hdc);
      dib->bitmap = NULL;
      dib->oldBitmap = NULL;
      dib->bits = NULL;
    }
#endif

  dib->dibInfo->bmiHead.biSize = sizeof (BITMAPINFOHEADER);
  dib->dibInfo->bmiHead.biWidth = width;
  if (TOP_DOWN_DIB)
    dib->dibInfo->bmiHead.biHeight = -height;
  else
    dib->dibInfo->bmiHead.biHeight = height;
  dib->dibInfo->bmiHead.biPlanes = 1;
  dib->dibInfo->bmiHead.biBitCount = 8;
  dib->dibInfo->bmiHead.biCompression = BI_RGB;
  dib->dibInfo->bmiHead.biSizeImage = 0;
  dib->dibInfo->bmiHead.biClrUsed = 0;
  dib->dibInfo->bmiHead.biClrImportant = 0;
  dib->bitmap = CreateDIBSection (hdc,
				  (BITMAPINFO *)dib->dibInfo,
				  DIB_PAL_COLORS,
				  &dib->bits,
				  NULL,
				  0 /* ignored if above is NULL */ );
  if (window)
    ReleaseDC (window, hdc);
  else
    DeleteDC (hdc);
}

#define SNAPSHOTPALETTE ((void *)0xdeaf)

void
dib_snapshot (dib_t *dib)
{
  PALETTEENTRY palette[256];
  int i;
  unsigned long newColorMap[256];
  HDC hdc = GetDC (dib->window);
  HDC hmemdc = CreateCompatibleDC (hdc);
  HDC hbmmem;
  RECT rect;
  unsigned width, height;
  int caps;
  HGDIOBJ hb1;
  unsigned offs;
  HPALETTE holdPal;
  LPBITMAPINFOHEADER pbmp;
  unsigned bufsize;
  PBYTE bits;

  GetWindowRect (dib->window, &rect);
  dib->bitmap = NULL;

  height = rect.bottom - rect.top;
  width = rect.right - rect.left;
  hbmmem = CreateCompatibleBitmap (hdc, width, height);
  hb1 = SelectObject (hmemdc, hbmmem);

  caps = GetDeviceCaps (hdc, RASTERCAPS);
  if (caps & RC_PALETTE)
    {
      UINT cnt;
      HPALETTE hpal;
      LOGPALETTE *plp;
      
      cnt = GetDeviceCaps (hdc, SIZEPALETTE);
      plp = xmalloc (sizeof (LOGPALETTE) + sizeof (PALETTEENTRY) * cnt);
      plp->palVersion = 0x0300;
      plp->palNumEntries = cnt;
      cnt = GetSystemPaletteEntries (hdc, 0, cnt, plp->palPalEntry);
      if (cnt == 0)
	abort ();
      hpal = CreatePalette (plp);
      xfree (plp);
      SelectPalette (hmemdc, hpal, FALSE);
      holdPal = SelectPalette (hdc, hpal, FALSE);
    }
  if (BitBlt (hmemdc, 0, 0, width, height, hdc, 0, 0, SRCCOPY) == FALSE)
    abort ();
  offs = sizeof(BITMAPINFOHEADER) + sizeof (RGBQUAD) * 256;
  bufsize = width * height;
  pbmp = (LPBITMAPINFOHEADER) xmalloc (offs);
  pbmp->biSize = sizeof (BITMAPINFOHEADER);
  pbmp->biWidth = width;
  pbmp->biHeight = -height;
  pbmp->biPlanes = 1;
  pbmp->biBitCount = 8;
  pbmp->biCompression = BI_RGB;
  bits = xmalloc (bufsize);
  hbmmem = SelectObject (hmemdc, hb1);

  if (GetDIBits (hmemdc, hbmmem, 0, height,
		 bits, (LPBITMAPINFO)pbmp, DIB_RGB_COLORS) != height)
    abort ();
      
  {
    int i;
    BYTE max = 0;
    RGBQUAD *colors = (PVOID)pbmp + sizeof (BITMAPINFOHEADER);

    for (i = 0; i < bufsize; i++)
      if (bits[i] > max)
	max = bits[i];
    
    {
      unsigned colorCount = max + 1;
      unsigned long map[colorCount];

      for (i = 0; i < colorCount; i++)
	map[i] = colors[i].rgbRed
	  | (colors[i].rgbGreen << 8)
	  | (colors[i].rgbBlue << 16);
      dib_augmentPalette (dib, SNAPSHOTPALETTE, colorCount, map);
    }
  }
  DeleteObject (hbmmem);
  xfree (pbmp);
  dib->bits = bits;
  SelectObject (hdc, holdPal);
  ReleaseDC (dib->window, hdc);
  DeleteDC (hmemdc);
}

int
dib_paletteIndexForObject (dib_t *dib, void *object)
{
  int i;

  for (i = 0; i < dib->colorMapBlocks; i++)
    if (object == dib->colorMapObjects[i])
      return i;
  return -1;
}

void
dib_augmentPalette (dib_t *dib,
		    void *object,
		    unsigned newColorMapSize, unsigned long *newColorMap)
{
  unsigned lastSize = dib->colorMapSize;
  
  dib->colorMapObjects[dib->colorMapBlocks] = object;
  dib->colorMapOffsets[dib->colorMapBlocks] = lastSize;
  dib->colorMapSize += newColorMapSize;
  dib->colorMapBlocks++;
  
  {
    unsigned i;
    RGBQUAD *rgb = &dib->dibInfo->rgb[lastSize];
    
    for (i = 0; i < newColorMapSize; i++)
      {
	rgb[i].rgbRed = newColorMap[i] & 0xff;
	rgb[i].rgbGreen = (newColorMap[i] >> 8) & 0xff;
	rgb[i].rgbBlue = newColorMap[i] >> 16;
      }
  }
  
  if (dib->bitmap)
    {
      HDC shdc = CreateCompatibleDC (NULL);
      
      dib->oldBitmap = SelectObject (shdc, dib->bitmap);
      SetDIBColorTable (shdc, 0, dib->colorMapSize, dib->dibInfo->rgb);
      SelectObject (shdc, dib->oldBitmap);
      DeleteDC (shdc);
    }
}

void
dib_fill (dib_t *dib,
	  int x, int y,
	  unsigned width, unsigned height,
	  unsigned char color)
{
  unsigned frameWidth = dib->dibInfo->bmiHead.biWidth;
  unsigned frameHeight = (dib->dibInfo->bmiHead.biHeight < 0
			  ? -dib->dibInfo->bmiHead.biHeight
			  : dib->dibInfo->bmiHead.biHeight);
  BYTE *base;
  int yoff;
  int wdiff, hdiff;
  int clipx, clipy;

  if (x < 0)
    {
      if (-x > width)
        return;
      width -= (-x);
      clipx = 0;
    }
  else if (x > frameWidth)
    return;
  else clipx = x;

  if (y < 0)
    {
      if (-y > height)
        return;
      height -= (-y);
      clipy = 0;
    }
  else if (y > frameHeight)
    return;
  else clipy = y;

  wdiff = clipx + width - frameWidth;

  if (wdiff > 0)
    width -= wdiff;

  hdiff = clipy + height - frameHeight;

  if (hdiff > 0)
    height -= hdiff;
  
  base = (BYTE *)dib->bits + (clipy * frameWidth);
  
  for (yoff = 0; yoff < height; yoff++)
    {
      int xoff;
      BYTE *ybase = &base[yoff * frameWidth + clipx];
      
      for (xoff = 0; xoff < width; xoff++)
	ybase[xoff] = color;
    }
}


void
dib_ellipse (dib_t *dib,
	     int x, int y,
	     unsigned width, unsigned height,
	     unsigned pixels,
	     unsigned char color)
{
  HPEN oldPen, pen;
  HBRUSH oldBrush;
  RGBQUAD *rgb = &dib->dibInfo->rgb[color];

  pen = CreatePen (PS_SOLID,
		   pixels,
		   RGB (rgb->rgbRed, rgb->rgbGreen, rgb->rgbBlue));

  dib_lock (dib);
  
  oldPen = SelectObject (dib->sourceDC, pen);
  oldBrush = SelectObject (dib->sourceDC, GetStockObject (NULL_BRUSH));

  Ellipse (dib->sourceDC, x, y, x + width, y + height);
  
  DeleteObject (SelectObject (dib->sourceDC, oldPen));
  SelectObject (dib->sourceDC, oldBrush);

  dib_unlock (dib);
}

void
dib_line (dib_t *dib,
          int x0, int y0,
          int x1, int y1,
          unsigned pixels,
          unsigned char color)
{
  HPEN oldPen, pen;
  HBRUSH oldBrush;
  RGBQUAD *rgb = &dib->dibInfo->rgb[color];

  pen = CreatePen (PS_SOLID,
		   pixels,
		   RGB (rgb->rgbRed, rgb->rgbGreen, rgb->rgbBlue));

  dib_lock (dib);
  
  oldPen = SelectObject (dib->sourceDC, pen);
  oldBrush = SelectObject (dib->sourceDC, GetStockObject (NULL_BRUSH));

  MoveToEx (dib->sourceDC, x0, y0, NULL);
  LineTo (dib->sourceDC, x1, y1);
  
  DeleteObject (SelectObject (dib->sourceDC, oldPen));
  SelectObject (dib->sourceDC, oldBrush);

  dib_unlock (dib);
}

void
dib_rectangle (dib_t *dib,
               int x, int y,
               unsigned width, unsigned height,
               unsigned pixels,
               unsigned char color)
{
  HPEN oldPen, pen;
  HBRUSH oldBrush;
  RGBQUAD *rgb = &dib->dibInfo->rgb[color];

  pen = CreatePen (PS_SOLID,
		   pixels,
		   RGB (rgb->rgbRed, rgb->rgbGreen, rgb->rgbBlue));

  dib_lock (dib);
  
  oldPen = SelectObject (dib->sourceDC, pen);
  oldBrush = SelectObject (dib->sourceDC, GetStockObject (NULL_BRUSH));

  Rectangle (dib->sourceDC, x, y, x + width, y + width);
  
  DeleteObject (SelectObject (dib->sourceDC, oldPen));
  SelectObject (dib->sourceDC, oldBrush);

  dib_unlock (dib);
}


BOOL
dib_paintBlit (dib_t *dib,
	       HDC destDC,
	       int destX, int destY,
	       int sourceX, int sourceY,
	       unsigned sourceWidth, unsigned sourceHeight)
{
  unsigned frameWidth = dib->dibInfo->bmiHead.biWidth;
  int diff;

  diff = (destX + sourceWidth) - frameWidth;

  if (diff > 0)
    sourceWidth -= diff;

  GdiFlush ();

  {
    /* Lock */
    HDC sourceDC = CreateCompatibleDC (destDC);

    dib->oldBitmap = SelectObject (sourceDC, dib->bitmap);
    
    /* Blit */
    {
      BOOL result;
      
      SelectPalette (destDC, dib->palette, FALSE);
      RealizePalette (destDC);
      result = BitBlt (destDC, 
		       destX, destY,
		       sourceWidth, sourceHeight,
		       sourceDC, 
		       sourceX + dib->xBitmapOffset,
		       sourceY + dib->yBitmapOffset,
		       SRCCOPY);
      
      /* Unlock */
      SelectObject (sourceDC, dib->oldBitmap);
      DeleteDC (sourceDC);
      
      return result;
    }
  }
}

BOOL
dib_copy (dib_t *source, dib_t *dest,
          int destx, int desty,
          unsigned width, unsigned height)
{
  BOOL result;

  dest->colorMapBlocks = source->colorMapBlocks;
  dest->colorMapSize = source->colorMapSize;
  memcpy (dest->colorMapOffsets,
	  source->colorMapOffsets,
	  sizeof (source->colorMapOffsets));
  memcpy (dest->colorMapObjects,
	  source->colorMapObjects,
	  sizeof (source->colorMapObjects));
  memcpy (dest->dibInfo->rgb,
	  source->dibInfo->rgb,
	  sizeof (RGBQUAD) * source->colorMapSize);
#if 0
  {
    HDC shdc = CreateCompatibleDC (NULL);
    
    dest->oldBitmap = SelectObject (shdc, dest->bitmap);
    SetDIBColorTable (shdc, 0, dest->colorMapSize, dest->dibInfo->rgb);
    SelectObject (shdc, dest->oldBitmap);
    DeleteDC (shdc);
  }
#endif

  if (dib_lock (dest) == NULL)
    return FALSE;
  if (dib_lock (source) == NULL)
    return FALSE;

  result = BitBlt (dest->sourceDC, destx, desty,
		   width, height,
		   source->sourceDC, 0, 0,
		   SRCCOPY);
  dib_unlock (source);
  dib_unlock (dest);
  return result;
}

BYTE *
dib_lock (dib_t *dib)
{
  GdiFlush ();
  
  dib->destDC = GetDC (dib->window);
  dib->sourceDC = CreateCompatibleDC (dib->destDC);

  dib->oldBitmap = SelectObject (dib->sourceDC, dib->bitmap);
  
  return dib->bits;
}

void
dib_unlock (dib_t *dib)
{
  SelectObject (dib->sourceDC, dib->oldBitmap);
  
  DeleteDC (dib->sourceDC);
  dib->sourceDC = NULL;
  ReleaseDC (dib->window, dib->destDC);
  dib->destDC = NULL;
}

#if 0
void
dib_setPaintOffset (dib_t *dib, int xOffset, int yOffset)
{
  dib->xBitmapOffset = xOffset;
  dib->yBitmapOffset = yOffset;
}

BYTE *
dib_getSurface (dib_t *dib)
{
  if (dib->bitmap == NULL)
    return NULL;

  return (BYTE *)dib->bits;
}

int
dib_getWidth (dib_t *dib)
{
  if (dib->bitmap == NULL)
    return -1;
  
  return dib->dibInfo->bmiHead.biWidth;
}


int
dib_getHeight (dib_t *dib)
{
  if (dib->bitmap == NULL)
    return -1;

  {
    int height = dib->dibInfo->bmiHead.biHeight;

    return height < 0 ? -height : height;
  }
}

BOOL
dib_blit (dib_t *dib,
	  int destX, int destY,
	  int sourceX, int sourceY,
	  unsigned sourceWidth, unsigned sourceHeight)
{
  int diff = destX + sourceWidth - dib->dibInfo->bmiHead.biWidth;
  
  if (diff > 0)
    sourceWidth -= diff;

  SelectPalette (dib->destDC, dib->palette, FALSE);
  RealizePalette (dib->destDC);
  return BitBlt (dib->destDC,
                 destX, destY,
                 sourceWidth, sourceHeight,
                 dib->sourceDC,
                 sourceX, sourceY,
                 SRCCOPY);
}

#endif
#endif
