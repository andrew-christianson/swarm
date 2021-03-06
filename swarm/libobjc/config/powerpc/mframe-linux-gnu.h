/* See ../README for copyright */

/*
 * The first eight words of non-FP are in registers (offset 4 in frame).
 * The first 13 FP args are in registers (offset 40 in frame).
 * If the method returns a structure, it's address is passed as an invisible
 * first argument, so only seven words of non-FP are passed in the registers.
 * Structures are always passed by reference.
 * Floats are placed in the frame as doubles.
 */

#define MFRAME_STACK_STRUCT     1
#define MFRAME_STRUCT_BYREF     1
#define MFRAME_SMALL_STRUCT     0
#define MFRAME_ARGS_SIZE        144
#define MFRAME_RESULT_SIZE      16
#define MFRAME_FLT_IN_FRAME_AS_DBL      1

/*
 * Structures are passed by reference as an invisible first argument, so
 * they go in the first register space for non-FP arguments - at offset 4.
 */
#define MFRAME_GET_STRUCT_ADDR(ARGS, TYPES) \
((*(TYPES)==_C_STRUCT_B || *(TYPES)==_C_UNION_B || *(TYPES)==_C_ARY_B) ? \
      *(void**)(((char*)(ARGS))+4): (void*)0)

#define MFRAME_SET_STRUCT_ADDR(ARGS, TYPES, ADDR) \
({if (*(TYPES)==_C_STRUCT_B || *(TYPES)==_C_UNION_B || *(TYPES)==_C_ARY_B) \
      *(void**)(((char*)(ARGS))+4) = (ADDR);})

/*
 * Typedef for structure to keep track of argument info while processing
 * a method.
 */
typedef struct rs6000_args 
{
  int int_args;         /* Number of integer arguments so far.          */
  int float_args;       /* Number of FP arguments so far.               */
  int regs_position;    /* The current position for non-FP args.        */
  int stack_position;   /* The current position in the stack frame.     */
} MFRAME_ARGS;


/*
 * Initialize a variable to keep track of argument info while processing a
 * method.  Keeps count of the number of arguments of each type seen and
 * the current offset in the non-FP registers.  This offset is adjusted
 * to take account of an invisible first argument used to return structures.
 */

#define MFRAME_INIT_ARGS(CUM, RTYPE) \
({ \
  (CUM).int_args = 0; \
  (CUM).float_args = 0; \
  (CUM).stack_position = 0; \
  (CUM).regs_position = \
    ((*(RTYPE)==_C_STRUCT_B || *(RTYPE)==_C_UNION_B || *(RTYPE)==_C_ARY_B) ? \
        4 + sizeof(void*) : 4); \
})

#define MFRAME_ARG_ENCODING(CUM, TYPE, STACK, DEST) \
({  \
  const char* type = (TYPE); \
\
  (TYPE) = objc_skip_typespec(type); \
  if (*type == _C_FLT || *type == _C_DBL) \
    { \
      if (++(CUM).float_args > 13) \
        { \
          (CUM).stack_position += ROUND ((CUM).stack_position, \
                                           __alignof__(double)); \
          sprintf((DEST), "%.*s%d", (TYPE)-type, type, (CUM).stack_position); \
          (STACK) = ROUND ((CUM).stack_position, sizeof(double)); \
        } \
      else \
        { \
          sprintf((DEST), "%.*s+%d", (TYPE)-type, type, \
                (int) (40 + sizeof (double) * ((CUM).float_args - 1))); \
        } \
    } \
  else \
    { \
      int align, size; \
\
      if (*type == _C_STRUCT_B || *type == _C_UNION_B || *type == _C_ARY_B) \
        { \
          align = __alignof__(void*); \
          size = sizeof (void*); \
        } \
      else \
        { \
          align = __alignof__(int); \
          size = objc_sizeof_type (type); \
        } \
\
      if (++(CUM).int_args > 8) \
        { \
          (CUM).stack_position += ROUND ((CUM).stack_position, align); \
          sprintf((DEST), "%.*s%d", (TYPE)-type, type, (CUM).stack_position); \
          (STACK) = ROUND ((CUM).stack_position, size); \
        } \
      else \
        { \
            (CUM).regs_position = ROUND((CUM).regs_position, align); \
          sprintf(dest, "%.*s+%d", (TYPE)-type, type, (CUM).regs_position); \
          (CUM).regs_position += ROUND (size, align); \
        } \
    } \
  (DEST)=&(DEST)[strlen(DEST)]; \
  if (*(TYPE) == '+') \
    { \
      (TYPE)++; \
    } \
  while (isDigit (*(TYPE))) \
    { \
      (TYPE)++; \
    } \
})
