// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <defobj.h>

#import "internal.h"
#import <gui.h>
#import <tkobjc/global.h>
#import <objectbase/Arguments.h>

id <TkExtra> globalTkInterp;

#import "simtools_tcl.x"
#import "analysis_tcl.x"
#ifdef _WIN32
#import "comm_tcl.x"
#import "tkbusy_tcl.x"
#endif

id <Error> WindowCreation, WindowUsage, MissingFiles,
  PaletteError, PixmapError,
  WindowGeometryRecordError;

void
initTkObjc (id arguments)
{
  if ([arguments getBatchModeFlag])
    tkobjc_initTclInterp (arguments);
  else
    {
      deferror (WindowCreation, NULL);
      deferror (WindowUsage, NULL);
      deferror (MissingFiles, NULL);
      deferror (PaletteError, NULL);
      deferror (PixmapError, NULL);
      deferror (WindowGeometryRecordError, NULL);
      
      tkobjc_initTkInterp (arguments);

      [globalTkInterp eval: "proc fmtx {sigfigures widget val} {\n"
                      "format \"%%.${sigfigures}g\" $val\n"
                      "}\n"];
      [globalTkInterp eval: simtools_tcl];

      if ([globalTkInterp newBLTp])
        [globalTkInterp eval: "uplevel #0 {"
                        "set hideOption -hide\n"
                        "set hideYes yes\n"
                        "set hideNo no\n"
                        "}\n"];
      else
        [globalTkInterp eval: "uplevel #0 {"
                        "set hideOption -mapped\n"
                        "set hideYes 0\n"
                        "set hideNo 1\n"
                      "}\n"];

      [globalTkInterp eval: analysis_tcl];
#ifdef _WIN32
      {
        const char *appName = [arguments getAppName];

        [globalTkInterp eval: comm_tcl];
        [globalTkInterp eval: "set %s [comm new %s]", appName, appName];
        [globalTkInterp eval: tkbusy_tcl];
      }
#endif
      [globalTkInterp eval: "uplevel #0 {\n"
                      "set obscured no\n"
                      "}\n"];
      
    }
}

