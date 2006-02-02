/* externvar.h.  Generated automatically by configure.  */
#ifndef _EXTERNVAR_H
#define _EXTERNVAR_H

#ifndef disable_externvar

#ifdef DLL

#define EXPORT_EXTERN extern
#define IMPORT_EXTERN extern
#define EXPORT_EXTERNDEF 

#ifdef BUILDING_SWARM

#ifdef EXPORT_EXTERN
#define externvar EXPORT_EXTERN
#else
#define externvar
#endif

#else

#ifdef IMPORT_EXTERN
#define externvar IMPORT_EXTERN
#else
#define externvar
#endif

#endif /* BUILDING_SWARM */

#ifdef EXPORT_EXTERNDEF
#define externvardef EXPORT_EXTERNDEF
#endif

#else

#define externvar extern
#define externvardef

#endif /* DLL */

#endif /* disable_externvar */

#endif
